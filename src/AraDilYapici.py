from dataclasses import dataclass
from typing import Dict, Optional, Union, List
from ast_tools import *
import sys


class Scope:
    def __init__(self, parent: Optional['Scope'] = None, symbols: Optional[List[Identifier]] = None):
        self.parent: Optional['Scope'] = parent
        # last symbol is the one in the current scope
        self.symbol_table: Dict[str, "Symbol"] = {}
        self.tmp_count = 0
        if symbols is not None:
            for symbol in symbols:
                self.add(symbol)

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.drop_symbol_table()

    def add(self, identifier: Identifier):
        if identifier.name not in self.symbol_table:
            self.symbol_table[identifier.name] = Symbol(identifier)

    def remove(self, identifier: Identifier):
        if identifier.name in self.symbol_table:
            del self.symbol_table[identifier.name]

    def get(self, identifier: Identifier) -> Optional["Symbol"]:
        if identifier.name in self.symbol_table:
            return self.symbol_table[identifier.name]
        elif self.parent is not None:
            return self.parent.get(identifier)
        else:
            return None

    def get_error_if_not_declared(self, identifier: Identifier) -> Optional["Symbol"]:
        symbol = self.get(identifier)
        if symbol is None:
            semantic_error(f"Identifier '{identifier.name}' referenced without being declared.",
                           identifier.lineno)

        return symbol

    def generate_tmp(self):
        tmp = f'.tmp{self.tmp_count}'  # encoded with a dot to avoid name conflicts with real variables
        identifier = Identifier(tmp, -1, -1)
        self.tmp_count += 1
        self.add(identifier)
        return identifier.name

    def drop_symbol_table(self):
        self.symbol_table = {}


@dataclass
class Symbol:
    id: Identifier


class Labels:
    def __init__(self):
        self.counts = {
            'ifelse': 0,
            'while': 0,
            'for': 0,
            'and': 0,
            'or': 0,
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


class AraDilYapiciVisitor(ASTNodeVisitor):
    def __init__(self):
        super().__init__()
        self.current_scope: Optional[Scope] = None
        self.global_fun_decls = {}
        self.ara_dil_sozleri = []
        self.program_symbol_table = None
        self.labels = Labels()

    def visit_SLiteral(self, sliteral: SLiteral):
        # todo: implement
        pass

    def visit_Program(self, program: Program):
        # todo: implement
        for fundecl in program.fun_decls:
            self.global_fun_decls[fundecl.identifier.name] = fundecl
        with Scope() as scope:
            self.current_scope = scope
            for var_decl in program.var_decls:
                self.visit(var_decl)
            for fun_decl in program.fun_decls:
                self.visit(fun_decl)
            for stmt in program.statements:
                self.visit(stmt)
            self.program_symbol_table = scope.symbol_table
            self.current_scope = scope.parent

    def visit_ErrorStmt(self, errorstmt: ErrorStmt):
        pass

    def visit_VarDecl(self, vardecl: VarDecl):
        if vardecl.initializer is not None:
            if type(vardecl.initializer) == list:
                # todo: vektor tanımlama
                for elem in vardecl.initializer:
                    self.visit(elem)
            else:
                self._ara_dile_ekle([['copy', vardecl.identifier.name, self.visit(vardecl.initializer)]])
        else:
            self._ara_dile_ekle([['copy', vardecl.identifier.name]])

        self.current_scope.add(vardecl.identifier)
        return vardecl.identifier.name

    def visit_FunDecl(self, fundecl: FunDecl):
        # todo: implement
        with Scope(self.current_scope, fundecl.params) as func_scope:
            self.current_scope = func_scope
            self.visit(fundecl.body)
            self.current_scope = func_scope.parent

    def visit_Assign(self, assign: Assign):
        rhs_name = self.visit(assign.expr)
        self._ara_dile_ekle(['copy', assign.identifier.name, rhs_name])

    def visit_SetVector(self, setvector: SetVector):
        # todo: implement
        self.visit(setvector.vector_index)
        self.visit(setvector.expr)

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
            cond_name = self.visit(forloop.condition)
            self._ara_dile_ekle(['branch_if_true', cond_name, body_label])
        else:
            self._ara_dile_ekle(['branch', body_label])

    def visit_Return(self, returnn: Return):
        # todo: implement
        self.visit(returnn.expr)

    def visit_WhileLoop(self, whileloop: WhileLoop):
        body_label, cond_label = self.labels.create_while()
        self._ara_dile_ekle([['branch', cond_label],
                             ['label', body_label]])
        self.visit(whileloop.body)
        self._ara_dile_ekle(['label', cond_label])
        cond_name = self.visit(whileloop.condition)
        self._ara_dile_ekle(['branch_if_true', cond_name, body_label])

    def visit_Block(self, block: Block):
        # todo: implement
        with Scope(self.current_scope) as block_scope:
            self.current_scope = block_scope
            for var_decl in block.var_decls:
                self.visit(var_decl)
            for stmt in block.statements:
                self.visit(stmt)
            self.current_scope = block_scope.parent

    def visit_Print(self, printt: Print):
        self._ara_dile_ekle([['param', self.visit(printt.expr)],
                             ['call', None, '__br_print__', 1]])

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
        result_name = self.current_scope.generate_tmp()
        left_name = self.visit(lbinary.left)
        if lbinary.op == 'and':
            short_label, label = self.labels.create_and()
            self._ara_dile_ekle(['branch_if_false', left_name, short_label])
            right_name = self.visit(lbinary.right)
            self._ara_dile_ekle([['branch_if_false', right_name, short_label],
                                 ['copy', result_name, True],
                                 ['branch', label],
                                 ['label', short_label],
                                 ['copy', result_name, False],
                                 ['label', label]])
        elif lbinary.op == 'or':
            short_label, label = self.labels.create_or()
            self._ara_dile_ekle(['branch_if_true', left_name, short_label])
            right_name = self.visit(lbinary.right)
            self._ara_dile_ekle([['branch_if_true', right_name, short_label],
                                 ['copy', result_name, False],
                                 ['branch', label],
                                 ['label', short_label],
                                 ['copy', result_name, True],
                                 ['label', label]])

        return result_name

    def visit_Comparison(self, comparison: Comparison):
        return self.binary_op(comparison)

    def visit_LLiteral(self, lliteral: LLiteral):
        name = self.current_scope.generate_tmp()
        self._ara_dile_ekle([['copy', name, lliteral.value]])
        return name

    def visit_LPrimary(self, lprimary: LPrimary):
        # todo: implement
        return self.visit(lprimary.primary)

    def visit_GetVector(self, getvector: GetVector):
        # todo: implement
        self.visit(getvector.vector_index)

    def visit_Variable(self, variable: Variable):
        return variable.identifier.name;

    def visit_LNot(self, lnot: LNot):
        result_name = self.current_scope.generate_tmp()
        right_name = self.visit(lnot.right)
        self._ara_dile_ekle([
            ('!', result_name, right_name)
        ])
        return result_name

    def visit_ABinary(self, abinary: ABinary):
        return self.binary_op(abinary)

    def visit_AUMinus(self, auminus: AUMinus):
        return self.binary_op(ABinary('-', ALiteral(0), auminus.right))

    def visit_ALiteral(self, aliteral: ALiteral):
        # todo: optimisation: add seperate instructions for literals instead of putting them in a variable
        name = self.current_scope.generate_tmp()
        self._ara_dile_ekle([['copy', name, aliteral.value]])
        return name

    def visit_Call(self, call: Call):
        # todo: implement
        if self.get_error_if_func_not_declared(call.callee) is None:
            pass
        for arg in call.arguments:
            self.visit(arg)

    def binary_op(self, binary: Union[ABinary, LBinary, Comparison]) -> str:
        result_name = self.current_scope.generate_tmp()
        left_name = self.visit(binary.left)
        right_name = self.visit(binary.right)
        self._ara_dile_ekle([
            [binary.op, result_name, left_name, right_name]
        ])
        return result_name

    def _ara_dile_ekle(self, sozler):
        if isinstance(sozler[0], list) or isinstance(sozler[0], tuple):
            self.ara_dil_sozleri.extend(sozler)
        elif isinstance(sozler[0], str):
            self.ara_dil_sozleri.append(sozler)
