from dataclasses import dataclass
from typing import Dict, Optional, Union, List, Tuple, TypedDict
from ast_tools import *
import sys
import compiler_utils as cu


class NameIdPair(TypedDict):
    name: str
    id: int  # -1 means global variable


class ActivationRecord:
    def __init__(self):
        self.degisken_sayilari: Dict[str, int] = {}
        self.degisken_goreli_adresleri: Dict[Tuple[str, int], int] = {}
        self.tmp_count = 0
        self.son_goreli_adres = 0

    def degisken_ekle(self, degisken_adi: str):
        if degisken_adi not in self.degisken_sayilari:
            self.degisken_sayilari[degisken_adi] = 1
        else:
            self.degisken_sayilari[degisken_adi] += 1

        degisken_ad_ve_id = {'name': degisken_adi, 'id': self.degisken_sayilari[degisken_adi] - 1}

        ad, var_id = degisken_ad_ve_id['name'], degisken_ad_ve_id['id']

        self.degisken_goreli_adresleri[(ad, var_id)] = self.son_goreli_adres
        self.son_goreli_adres += 16
        return degisken_ad_ve_id

    def vektor_degiskeni_ekle(self, degisken_adi: str, vektor_uzunlugu: int):
        degisken_ad_ve_id = self.degisken_ekle(degisken_adi)
        self.son_goreli_adres += 16 * vektor_uzunlugu + 8
        return degisken_ad_ve_id


class AraDilScope:
    """
     bunun sayesinde ağacı gezerken değişken adından NameIdPair bulabiliriz, böylece değişkenin göreli adresini bulabiliriz
     """
    activation_record: Optional[ActivationRecord]

    def __init__(self, parent: Optional['AraDilScope'] = None, symbols: Optional[List[Identifier]] = None,
                 activation_record: Optional[ActivationRecord] = None):
        self.parent: Optional['AraDilScope'] = parent
        self.activation_record = activation_record
        if self.parent is not None and \
                self.parent.activation_record is not None and \
                self.activation_record is None:
            self.activation_record = self.parent.activation_record

        # last symbol is the one in the current scope
        self.symbol_table: Dict[str, "Symbol"] = {}

        if symbols is not None:
            for symbol in symbols:
                self.add(symbol)

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.drop_symbol_table()

    def add(self, identifier: Identifier, vector_length: Optional[int] = None) -> NameIdPair:
        if identifier.name not in self.symbol_table:
            if vector_length is None:
                degisken_ad_ve_id = self.activation_record.degisken_ekle(identifier.name)
            else:
                degisken_ad_ve_id = self.activation_record.vektor_degiskeni_ekle(identifier.name, vector_length)
            self.symbol_table[identifier.name] = Symbol(identifier, degisken_ad_ve_id['id'])
            return degisken_ad_ve_id

    def remove(self, identifier: Identifier):
        if identifier.name in self.symbol_table:
            del self.symbol_table[identifier.name]

    def get(self, identifier: Identifier) -> "Symbol":
        if identifier.name in self.symbol_table:
            return self.symbol_table[identifier.name]
        elif self.parent is not None:
            return self.parent.get(identifier)
        else:  # since we are sure that each variable is declared before use, this is global variable
            return Symbol(identifier, -1)

    def get_name_id_pair(self, identifier: Identifier) -> NameIdPair:
        symbol = self.get(identifier)
        return {'name': identifier.name, 'id': symbol.id}

    def generate_tmp(self) -> NameIdPair:
        if self.activation_record is None:
            raise Exception("Activation record is None")
        tmp = f'.tmp{self.activation_record.tmp_count}'  # encoded with a dot to avoid name conflicts with real variables
        self.activation_record.tmp_count += 1
        return self.add(Identifier(tmp, -1, 1))

    def drop_symbol_table(self):
        self.symbol_table = {}


@dataclass
class Symbol:
    identifier: Identifier
    id: int  # -1 means global


class Labels:
    def __init__(self):
        self.counts = {
            'ifelse': 0,
            'while': 0,
            'for': 0,
            'and': 0,
            'or': 0,
            'string': 0,
        }
        # .L for local label

    def create_endifelse(self):
        self.counts['ifelse'] += 1
        return f'.L_endif{self.counts["ifelse"]}', f'.L_endelse{self.counts["ifelse"]}'

    def create_while(self):
        self.counts['while'] += 1
        return f'.L_while_body{self.counts["while"]}', f'.L_while_cond{self.counts["while"]}'

    def create_for(self):
        self.counts['for'] += 1
        return f'.L_for_body{self.counts["for"]}', f'.L_for_cond{self.counts["for"]}'

    def create_and(self):
        self.counts['and'] += 1
        return f'.L_short_and{self.counts["and"]}', f'.L_and{self.counts["and"]}'

    def create_or(self):
        self.counts['or'] += 1
        return f'.L_short_or{self.counts["or"]}', f'.L_or{self.counts["or"]}'

    def create_string(self):
        self.counts['string'] += 1
        return f'.L_string{self.counts["string"]}'


class AraDilYapiciVisitor(ASTNodeVisitor):
    def __init__(self):
        super().__init__()
        self.current_scope: Optional[AraDilScope] = None
        self.func_activation_records: Dict[str, ActivationRecord] = {}
        self.fun_decls: Dict[str, FunDecl] = {}
        self.ara_dil_sozleri = []
        self._ara_dil_fonksiyon_tanim_sozleri = []
        self.labels: Labels = Labels()
        self.global_vars: Dict[str, VarDecl] = {}
        self.global_string_to_label: Dict[str, str] = {}

        self._fonksiyon_tanimlaniyor = False
        self.main_activation_record: ActivationRecord = ActivationRecord()

    def visit_SLiteral(self, sliteral: SLiteral):
        # todo: optimisation: add seperate instructions for literals instead of putting them in a variable
        self.global_string_to_label[sliteral.value] = self.labels.create_string()
        name_id = self.current_scope.generate_tmp()
        self._ara_dile_ekle([['copy', name_id, sliteral.value]])
        return name_id

    def visit_Program(self, program: Program):
        self._ara_dile_ekle(['fun', 'main', 'main()', 0])

        for fundecl in program.fun_decls:
            self.func_activation_records[fundecl.identifier.name] = ActivationRecord()
            self.fun_decls[fundecl.identifier.name] = fundecl
        self.func_activation_records['main'] = self.main_activation_record

        with AraDilScope(None, None, self.main_activation_record) as scope:
            self.current_scope = scope
            for var_decl in program.var_decls:
                self.add_global(var_decl)
            for fun_decl in program.fun_decls:
                self.visit(fun_decl)
            for stmt in program.statements:
                self.visit(stmt)
            self.current_scope = scope.parent

        self._ara_dile_ekle(['endfun'])
        self.ara_dil_sozleri.extend(self._ara_dil_fonksiyon_tanim_sozleri)

    def visit_ErrorStmt(self, errorstmt: ErrorStmt):
        pass

    def visit_VarDecl(self, vardecl: VarDecl):
        if type(vardecl.initializer) == list:
            degisken_ad_ve_id = self.current_scope.add(vardecl.identifier, len(vardecl.initializer))
            self._ara_dile_ekle(['vector', degisken_ad_ve_id, len(vardecl.initializer)])
            for i, elem in enumerate(vardecl.initializer):
                elem_ad_ve_id = self.visit(elem)
                self._ara_dile_ekle([['vector_set', degisken_ad_ve_id, i, elem_ad_ve_id]])
        elif vardecl.initializer is None:
            degisken_ad_ve_id = self.current_scope.add(vardecl.identifier)
            self._ara_dile_ekle([['copy', degisken_ad_ve_id]])
        else:
            degisken_ad_ve_id = self.current_scope.add(vardecl.identifier)
            self._ara_dile_ekle(['copy', degisken_ad_ve_id, self.visit(vardecl.initializer)])

        return degisken_ad_ve_id

    def add_global(self, vardecl: VarDecl):
        # global komutunu bir seye donusturmuyorum. sadece self.global_vars kullaniyorum.
        # global komutunu olusturma sebebim ara dili okumak istersem anlayayim global oldugunu diye.
        # main fonksiyonunun bir görevi de global degiskenleri ilklendirmek oluyor.
        self._ara_dile_ekle(['global', vardecl.identifier.name])
        degisken_ad_ve_id = {'name': vardecl.identifier.name, 'id': -1}

        if type(vardecl.initializer) == list:
            self.global_vars[vardecl.identifier.name] = vardecl
            for i, elem in enumerate(vardecl.initializer):
                elem_ad_ve_id = self.visit(elem)
                self._ara_dile_ekle([['vector_set', degisken_ad_ve_id, i, elem_ad_ve_id]])
        elif vardecl.initializer is None:
            self.global_vars[vardecl.identifier.name] = vardecl
        else:
            self.global_vars[vardecl.identifier.name] = vardecl
            self._ara_dile_ekle([['copy', degisken_ad_ve_id, self.visit(vardecl.initializer)]])

        return degisken_ad_ve_id

    def visit_FunDecl(self, fundecl: FunDecl):
        self._fonksiyon_tanimlaniyor = True
        func_label = fundecl.identifier.name
        self._ara_dile_ekle(['fun', func_label, self.get_func_signature(fundecl), len(fundecl.params)])

        main_scope = self.current_scope

        # here we cut the scope tree. function cant see caller scope.
        # since globals are not in any scope, they are hidden from all functions here but
        # seeing globals is handled in compiler part.
        with AraDilScope(None, None, self.func_activation_records[func_label]) as func_scope:
            self.current_scope = func_scope

            for i, param in enumerate(fundecl.params):
                degisken_ad_ve_id = self.current_scope.add(param)
                self._ara_dile_ekle(['param', degisken_ad_ve_id, i])

            self.visit(fundecl.body)

            self.current_scope = main_scope
        self._ara_dile_ekle(['endfun'])
        self._fonksiyon_tanimlaniyor = False

    def visit_Assign(self, assign: Assign):
        rhs_ad_ve_id = self.visit(assign.expr)
        degisken_ad_ve_id = self.current_scope.get_name_id_pair(assign.identifier)
        self._ara_dile_ekle(['copy', degisken_ad_ve_id, rhs_ad_ve_id])

    def visit_SetVector(self, setvector: SetVector):
        vector = self.current_scope.get_name_id_pair(setvector.identifier)
        index = self.visit(setvector.vector_index)
        expr = self.visit(setvector.expr)
        self._ara_dile_ekle([['vector_set', vector, index, expr]])

    def visit_ForLoop(self, forloop: ForLoop):
        body_label, cond_label = self.labels.create_for()
        if forloop.initializer is not None:
            self.visit(forloop.initializer)
        self._ara_dile_ekle([['branch', cond_label],
                             ['label', body_label]])
        self.visit(forloop.body)
        if forloop.increment is not None:
            self.visit(forloop.increment)
        self._ara_dile_ekle(['label', cond_label])
        if forloop.condition is not None:
            cond_name_ve_id = self.visit(forloop.condition)
            self._ara_dile_ekle(['branch_if_true', cond_name_ve_id, body_label])
        else:
            self._ara_dile_ekle(['branch', body_label])

    def visit_Return(self, returnn: Return):
        ad_ve_id = self.visit(returnn.expr)
        self._ara_dile_ekle(['ret', ad_ve_id])
        self._ara_dile_ekle(['endfun'])
        return ad_ve_id

    def visit_WhileLoop(self, whileloop: WhileLoop):
        body_label, cond_label = self.labels.create_while()
        self._ara_dile_ekle([['branch', cond_label],
                             ['label', body_label]])
        self.visit(whileloop.body)
        self._ara_dile_ekle(['label', cond_label])
        cond_name_ve_id = self.visit(whileloop.condition)
        self._ara_dile_ekle(['branch_if_true', cond_name_ve_id, body_label])

    def visit_Block(self, block: Block):
        with AraDilScope(self.current_scope) as block_scope:
            self.current_scope = block_scope
            for var_decl in block.var_decls:
                self.visit(var_decl)
            for stmt in block.statements:
                self.visit(stmt)
            self.current_scope = block_scope.parent

    def visit_Print(self, printt: Print):
        self._ara_dile_ekle([['arg_vox_lib', self.visit(printt.expr)],
                             ['call_vox_lib', None, '__br_print__', 1]])

    def visit_IfElse(self, ifelse: IfElse):
        endif_label, endelse_label = self.labels.create_endifelse()
        self._ara_dile_ekle([['branch_if_false', self.visit(ifelse.condition), endif_label]])

        self.visit(ifelse.if_branch)

        if ifelse.else_branch is not None:
            self._ara_dile_ekle([['branch', endelse_label]])

        self._ara_dile_ekle([['label', endif_label]])

        if ifelse.else_branch is not None:
            self.visit(ifelse.else_branch)
            self._ara_dile_ekle([['label', endelse_label]])

    def visit_LBinary(self, lbinary: LBinary):
        result_name_id_pair = self.current_scope.generate_tmp()

        left_name = self.visit(lbinary.left)
        if lbinary.op == 'and':
            short_label, label = self.labels.create_and()
            self._ara_dile_ekle(['branch_if_false', left_name, short_label])
            right_name = self.visit(lbinary.right)
            self._ara_dile_ekle([['branch_if_false', right_name, short_label],
                                 ['copy', result_name_id_pair, True],
                                 ['branch', label],
                                 ['label', short_label],
                                 ['copy', result_name_id_pair, False],
                                 ['label', label]])
        elif lbinary.op == 'or':
            short_label, label = self.labels.create_or()
            self._ara_dile_ekle(['branch_if_true', left_name, short_label])
            right_name = self.visit(lbinary.right)
            self._ara_dile_ekle([['branch_if_true', right_name, short_label],
                                 ['copy', result_name_id_pair, False],
                                 ['branch', label],
                                 ['label', short_label],
                                 ['copy', result_name_id_pair, True],
                                 ['label', label]])

        return result_name_id_pair

    def visit_Comparison(self, comparison: Comparison):
        return self.binary_op(comparison)

    def visit_LLiteral(self, lliteral: LLiteral):
        name_id_pair = self.current_scope.generate_tmp()
        self._ara_dile_ekle([['copy', name_id_pair, lliteral.value]])
        return name_id_pair

    def visit_LPrimary(self, lprimary: LPrimary):
        return self.visit(lprimary.primary)

    def visit_GetVector(self, getvector: GetVector):
        vector = self.current_scope.get_name_id_pair(getvector.identifier)
        index = self.visit(getvector.vector_index)
        result = self.current_scope.generate_tmp()
        self._ara_dile_ekle([['vector_get', result, vector, index]])

    def visit_Variable(self, variable: Variable):
        name_id_pair = self.current_scope.get_name_id_pair(variable.identifier)
        return name_id_pair

    def visit_LNot(self, lnot: LNot):
        result_name_id = self.current_scope.generate_tmp()
        right_name_id = self.visit(lnot.right)
        self._ara_dile_ekle([
            ('!', result_name_id, right_name_id)
        ])
        return result_name_id

    def visit_ABinary(self, abinary: ABinary):
        return self.binary_op(abinary)

    def visit_AUMinus(self, auminus: AUMinus):
        return self.binary_op(ABinary('-', ALiteral(0), auminus.right))

    def visit_ALiteral(self, aliteral: ALiteral):
        # todo: optimisation: add seperate instructions for literals instead of putting them in a variable
        name_id = self.current_scope.generate_tmp()
        self._ara_dile_ekle([['copy', name_id, aliteral.value]])
        return name_id

    def visit_Call(self, call: Call):
        param_count = len(self.fun_decls[call.callee.name].params)
        if len(call.arguments) != param_count:
            cu.compilation_warning(f'Function {call.callee.name} expects {param_count} arguments, '
                                   f'but {len(call.arguments)} were given. Empty arguments are set to 0. '
                                   f'Redundant arguments will not be evaluated.', call.callee.lineno)
        self._ara_dile_ekle(['arg_count', param_count])
        for i in range(param_count):
            if i < len(call.arguments):
                name_ad_ve_id = self.visit(call.arguments[i])
                self._ara_dile_ekle(['arg', name_ad_ve_id, i])
            else:
                name_ad_ve_id = self.current_scope.generate_tmp()
                self._ara_dile_ekle(['copy', name_ad_ve_id, 0])
                self._ara_dile_ekle(['arg', name_ad_ve_id, i])

        ret_val_name_id_pair = self.current_scope.generate_tmp()
        self._ara_dile_ekle(['call', ret_val_name_id_pair, call.callee.name])
        return ret_val_name_id_pair

    def binary_op(self, binary: Union[ABinary, LBinary, Comparison]) -> NameIdPair:
        result_name_id = self.current_scope.generate_tmp()
        left_name_id = self.visit(binary.left)
        right_name_id = self.visit(binary.right)
        self._ara_dile_ekle([
            [binary.op, result_name_id, left_name_id, right_name_id]
        ])
        return result_name_id

    def _ara_dile_ekle(self, sozler):
        if self._fonksiyon_tanimlaniyor:
            hedef_ara_dil_sozleri = self._ara_dil_fonksiyon_tanim_sozleri
        else:
            hedef_ara_dil_sozleri = self.ara_dil_sozleri

        if isinstance(sozler[0], list) or isinstance(sozler[0], tuple):
            hedef_ara_dil_sozleri.extend(sozler)
        elif isinstance(sozler[0], str):
            hedef_ara_dil_sozleri.append(sozler)

    def get_func_signature(self, fundecl: Union[FunDecl, str]):
        if isinstance(fundecl, str):
            fundecl = self.fun_decls[fundecl]
        return f'{fundecl.identifier.name}({", ".join([param.name for param in fundecl.params])})'
