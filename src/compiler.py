# hizli olmasi icin pypy kullanilabilir
from typing import Dict, Optional, Union, List, Callable, Any, Type
import ast_tools
from ast_tools import VarDecl
from abc import ABC, abstractmethod
import misc
from AraDilYapici import AraDilYapiciVisitor
from AraDilYapici import ActivationRecord
from AraDilYapici import NameIdPair
import optimizer
import compiler_utils as cu
import sys

"""
https://github.com/riscv-non-isa/riscv-asm-manual/blob/master/riscv-asm.md
    
    vektör implementasyonu
    vektör uzunluğunu vektörün ilk elemanından bir önceki eleman olarak (8 byte, 16 byte değil)
    tutuyorum ki her vector[i] dediğimde i +1 işlemini yapmayayım.
    değişken structuna yazsam olabilirdi, mesela 4 byte type deyip 4 byte vector length diyebilirdim ama demedim. 
    not: vektörler type ve değer çifti tutar, doğal olarak heterojen olurlar.
    
    
    
    
    Bonus:
    
    After you are done with all of the compulsory steps, you can also implement optional features you'd like Vox to have. 
    These will help you get that Gazozuna Compiler award. Some of them could be:
    - Lower amount of temporary variables, better register allocation and lower register spill.
    - Reals in addition to integers (just like Javascript).
    - Garbage collection.
    - Runtime errors.
    ✓ Functions with more than 7 formal parameters.
    ✓ Vectors can hold a mixture of types and other vectors.
    - Cool additional syntactic sugar (like list expressions in Python).
    
    Yapılabilecek optimizasyonlar:
    constant folding yanında constant propogation:
    https://en.wikipedia.org/wiki/Constant_folding
    özet: değişiklik olmayana kadar bir folding bir propogation yap.
    
    https://en.wikipedia.org/wiki/Optimizing_compiler
    
    todo: 
    remove unused  variables
    hata kontrol visitor açıp şunu ekle: Compilation error: Return statement can only be used inside a function.
    sadece fonksiyon içerisinde değiştirilen registerler savelensin.
    compiler utils compilation error quit yapmamalı, sadece sonunda dosyaya assembly yazılmasını engellemelidir.
    
    
    parametrelerden ayrıca local değişken yapmama gerek yok, direkt stackte var zaten parametreler (a reglerine sığmayan)
    type checking lazım illa. mesela vektör işlemlerinde vektörlerin tipi sayı olmalı. 
    Optimizasyon belki
    string + işlemi
    
    
    

"""


def get_global_type_name(var_name):
    return f'{var_name}_type'


def get_global_value_name(var_name):
    return f'{var_name}_value'


def get_global_length_name(var_name):
    return f'{var_name}_length'


def get_global_vector_name(var_name):
    return f'{var_name}_vector'


def is_temp(var_name_id: NameIdPair):
    return var_name_id['name'].startswith('.tmp')


class AssemblyYapici(ABC):
    def __init__(self,
                 global_vars: Dict[str, VarDecl],
                 func_activation_records: Dict[str, ActivationRecord],
                 global_string_to_label: Dict[str, str],
                 ara_dil_satirlari: List[List[Any]]):
        self.global_vars: Dict[str, VarDecl] = global_vars
        self.func_activation_records: Dict[str, ActivationRecord] = func_activation_records
        self.global_string_to_label: Dict[str, str] = global_string_to_label
        self.aradil_sozlugu: Dict[str, Callable[[List[Any]], List[str]]] = {}
        self.ara_dil_satirlari: List[List[Any]] = ara_dil_satirlari

    def aradilden_asm(self, komut):
        if komut[0] in self.aradil_sozlugu:
            asm = []
            if komut[0] != 'fun':
                asm.append('            # ' + cu.komut_stringi_yap(komut))
            asm.extend(self.aradil_sozlugu[komut[0]](komut))
            return asm
        else:
            return f'ERROR! Unknown IL {komut}'

    @abstractmethod
    def yap(self) -> List[str]:
        pass


class RiscVAssemblyYapici(AssemblyYapici):
    def __init__(self,
                 global_vars: Dict[str, VarDecl],
                 func_activation_records: Dict[str, ActivationRecord],
                 global_string_to_label: Dict[str, str],
                 ara_dil_satirlari: List[List[Any]]):
        super().__init__(global_vars, func_activation_records, global_string_to_label, ara_dil_satirlari)
        self.sp_extra_offset = 0
        self.fp_extra_offset = 0
        self.current_stack_size = 0
        self.current_fun_label = ''
        self.current_fun_callee_saved_regs: Dict[str, bool] = {}
        self.current_fun_non_reg_arg_count = 0
        self.aradil_sozlugu: Dict[str, Callable[[List[Any]], List[str]]] = {
            'call': self.cevir_call,
            'arg_count': self.cevir_arg_count,
            'arg': self.cevir_arg,
            'copy': self.cevir_copy,
            'vector': self.cevir_vector,
            'vector_set': self.cevir_vector_set,
            'vector_get': self.cevir_vector_get,
            'global': self.cevir_global,
            'branch': self.cevir_branch,
            'branch_if_true': self.cevir_branch_if_true,
            'branch_if_false': self.cevir_branch_if_false,
            'label': self.cevir_label,
            'fun': self.cevir_fun,
            'param': self.cevir_param,
            'ret': self.cevir_ret,
            'endfun': self.cevir_endfun,
            'and': self.ceviriler_mantiksal,
            'or': self.ceviriler_mantiksal,
            '!': self.ceviriler_mantiksal,
            '<': self.ceviriler_karsilastirma,
            '>': self.ceviriler_karsilastirma,
            '<=': self.ceviriler_karsilastirma,
            '>=': self.ceviriler_karsilastirma,
            '==': self.ceviriler_karsilastirma,
            '!=': self.ceviriler_karsilastirma,
        }
        self.tip_rakamlari: Dict[str, int] = {
            'int': 0,
            'vector': 1,
            'bool': 2,
            'string': 3,
        }

    def yap(self):
        assembly_lines = []
        assembly_lines.extend(self.get_on_soz())

        for komut in self.ara_dil_satirlari:
            assembly_lines.extend(self.aradilden_asm(komut))

        if len(self.global_vars) > 0 or \
                len(self.global_string_to_label):
            assembly_lines.extend(['',
                                   '  .data'])
        for name, vardecl in self.global_vars.items():
            if vardecl.initializer is not None and type(vardecl.initializer) == list:
                global_vector_name = get_global_vector_name(name)
                assembly_lines.extend([f'{get_global_type_name(name)}:    .quad {self.tip_rakamlari["vector"]}',
                                       f'{get_global_value_name(name)}:   .quad {global_vector_name}',
                                       f'{get_global_length_name(name)}:  .quad {len(vardecl.initializer)}',
                                       f'{global_vector_name}:'])
                for i in range(len(vardecl.initializer)):
                    assembly_lines.append('  .quad 0, 0')
                assembly_lines.append('')
            else:
                assembly_lines.extend([f'{get_global_type_name(name)}:   .quad 0',
                                       f'{get_global_value_name(name)}:  .quad 0',
                                       f''])

        for string_value, string_label in self.global_string_to_label.items():
            # .ascii does not add a null terminator, thus use .string
            assembly_lines.append(f'{string_label}:  .string "{string_value}"')

        return assembly_lines

    def get_on_soz(self):
        on_soz = [f'#include "vox_lib.h"',
                  f'  ',
                  f'  .global main',
                  f'  .text',
                  f'  .align 2']
        return on_soz

    def add_to_saved_regs(self, regs: Union[str, List[str]]):
        """

        :param regs:registers to be saved when declaring a function and restored when exiting
        :return:
        """
        if isinstance(regs, str):
            regs = [regs]
        for reg in regs:
            if reg not in self.current_fun_callee_saved_regs:
                self.current_fun_callee_saved_regs[reg] = True
                self.fp_extra_offset += 8

    def asm_var_or_const_to_reg(self, var_name_id, type_reg=None, value_reg=None):
        # asm = [f'      # asm_var_to_reg(var:{var_name}, type_reg:{type_reg}, value_reg:{value_reg})']
        asm = []
        if type(var_name_id) == int:
            if type_reg is not None:
                asm.append(f'  li {type_reg}, {self.tip_rakamlari["int"]}')
            if value_reg is not None:
                asm.append(f'  li {value_reg}, {var_name_id}')
        elif type(var_name_id) == bool:
            if type_reg is not None:
                asm.append(f'  li {type_reg}, {self.tip_rakamlari["bool"]}')
            if value_reg is not None:
                asm.append(f'  li {value_reg}, {int(var_name_id)}')
        elif type(var_name_id) == str:
            if type_reg is not None:
                asm.append(f'  li {type_reg}, {self.tip_rakamlari["string"]}')
            if value_reg is not None:
                asm.append(f'  la {value_reg}, {self.global_string_to_label[var_name_id]}')
        else:
            type_addr = self._type_addr(var_name_id)
            value_addr = self._value_addr(var_name_id)
            if type_addr is not None:  # local
                if type_reg is not None:
                    asm.append(f'  ld {type_reg}, {type_addr}')
                if value_reg is not None:
                    asm.append(f'  ld {value_reg}, {value_addr}')
            elif var_name_id["name"] in self.global_vars:
                if type_reg is not None:
                    asm.append(f'  ld {type_reg}, {get_global_type_name(var_name_id["name"])}')
                if value_reg is not None:
                    asm.append(f'  ld {value_reg}, {get_global_value_name(var_name_id["name"])}')
            else:
                cu.compilation_error(f'Unknown variable {var_name_id["name"]}')
        return asm

    def asm_reg_to_var(self, temp_reg, var_name_id, type_reg=None, value_reg=None):
        """
        :param temp_reg: only used for storing to global variables
        """
        # asm = [f'      # asm_reg_to_var(tmp:{temp_reg}, var:{var_name}, type_reg:{type_reg}, value_reg:{value_reg})']
        asm = []
        type_addr = self._type_addr(var_name_id)
        value_addr = self._value_addr(var_name_id)
        if type_addr is not None:  # local
            if type_reg is not None:
                asm.append(f'  sd {type_reg}, {type_addr}')
            if value_reg is not None:
                asm.append(f'  sd {value_reg}, {value_addr}')
        elif var_name_id["name"] in self.global_vars:
            asm.append(f'  la {temp_reg}, {get_global_type_name(var_name_id["name"])}')
            if type_reg is not None:
                asm.append(f'  sd {type_reg}, ({temp_reg})')
            if value_reg is not None:
                asm.append(f'  sd {value_reg}, 8({temp_reg})')
        else:
            cu.compilation_error(f'Unknown variable {var_name_id["name"]}')
        return asm

    def asm_get_vector_elm_addr(self, tmp_reg, addr_reg, vector_name_id, index):
        asm = []
        asm.extend(self.asm_var_or_const_to_reg(vector_name_id, None, addr_reg))
        if type(index) == int:
            asm.extend([f'  addi {addr_reg}, {addr_reg}, {index * 16}'])
        else:
            asm.extend(self.asm_var_or_const_to_reg(index, None, tmp_reg))
            asm.extend([f'  slli {tmp_reg}, {tmp_reg}, 4',
                        f'  add {addr_reg}, {addr_reg}, {tmp_reg}'])
        return asm

    def cevir_arg_count(self, komut):
        asm = []
        non_reg_arg_count = komut[1] - 4
        if non_reg_arg_count > 0:
            self.current_fun_non_reg_arg_count = non_reg_arg_count
            self.sp_extra_offset += 16 * non_reg_arg_count
            asm.append(f'  addi sp, sp, -{16 * non_reg_arg_count}')

        return asm

    def cevir_arg(self, komut):
        arg_name_id = komut[1]
        arg_index = komut[2]
        asm = []
        if arg_index <= 3:
            asm.extend(self.asm_var_or_const_to_reg(arg_name_id,
                                                    f'a{2 * arg_index}',
                                                    f'a{2 * arg_index + 1}'))
        else:
            non_reg_index = arg_index - 4
            asm.extend(self.asm_var_or_const_to_reg(arg_name_id, 't0', 't1'))
            asm.extend([f'  sd t0, {16 * non_reg_index}(sp)',
                        f'  sd t1, {16 * non_reg_index + 8}(sp)'])

        return asm

    def cevir_call(self, komut):
        ret_val_name_id = komut[1]
        func_name = komut[2]
        asm = [f'  call {func_name}']
        if self.current_fun_non_reg_arg_count > 0:
            asm.append(f'  addi sp, sp, {16 * self.current_fun_non_reg_arg_count}')
            self.sp_extra_offset -= 16 * self.current_fun_non_reg_arg_count
        self.current_fun_non_reg_arg_count = 0

        if ret_val_name_id is not None:
            asm.extend(self.asm_reg_to_var('t0', ret_val_name_id, 'a0', 'a1'))

        return asm

    def cevir_copy(self, komut):
        asm = []
        if len(komut) < 3:
            asm.extend(self.asm_reg_to_var('t0', komut[1], 'zero', 'zero'))
        else:
            asm.extend(self.asm_var_or_const_to_reg(komut[2], 't0', 't1'))
            asm.extend(self.asm_reg_to_var('t2', komut[1], 't0', 't1'))

        return asm

    def cevir_vector(self, komut):
        name_id = komut[1]
        length = komut[2]

        type_addr = self._type_addr(name_id)

        asm = []

        if type_addr is not None:  # local
            length_addr = self._length_addr(name_id)
            i_first_elm = self._vector_first_elm_sp_index(name_id)
            asm.extend([f'  li t1, {self.tip_rakamlari["vector"]}',
                        f'  add t2, sp, {i_first_elm}'])
            asm.extend(self.asm_reg_to_var('t0', name_id, 't1', 't2'))

            asm.extend([f'  li t0, {length}',
                        f'  sd t0, {length_addr}'])
        elif name_id["name"] in self.global_vars:
            pass
        else:
            # impossible if undeclared variable check is done before
            cu.compilation_error(f'Unknown variable {name_id["name"]}')

        return asm

    def cevir_vector_set(self, komut):
        vector_name_id = komut[1]
        index = komut[2]
        expr_name_id = komut[3]
        asm = []
        asm.extend(self.asm_var_or_const_to_reg(expr_name_id, 't0', 't1'))
        asm.extend(self.asm_get_vector_elm_addr('t3', 't2', vector_name_id, index))
        asm.extend([f'  sd t0, 0(t2)',
                    f'  sd t1, 8(t2)'])
        return asm

    def cevir_vector_get(self, komut):
        result_name_id = komut[1]
        vector_name_id = komut[2]
        index = komut[3]
        asm = []
        asm.extend(self.asm_get_vector_elm_addr('t0', 't1', vector_name_id, index))
        asm.extend([f'  ld t0, 0(t1)',
                    f'  ld t1, 8(t1)'])
        asm.extend(self.asm_reg_to_var('t2', result_name_id, 't0', 't1'))

        return asm

    def cevir_global(self, komut):
        # Compiler sınıfı oluşturur globalleri
        return []

    def cevir_branch(self, komut):
        return [f'  j {komut[1]}']

    def cevir_label(self, komut):
        return [f'{komut[1]}:']

    def cevir_fun(self, komut):
        label = komut[1]
        signature = komut[2]
        param_count = komut[3]

        self.current_fun_label = label
        self.add_to_saved_regs(['ra', 'fp'])

        self.current_stack_size = self.func_activation_records[label].son_goreli_adres
        total_stack_size = self.current_stack_size + self.sp_extra_offset + self.fp_extra_offset

        asm = [f'',
               f'# fun {signature};',
               f'{label}:']
        if total_stack_size > 0:
            asm.append(f'  addi sp, sp, -{total_stack_size}')

        for i, reg_to_save in enumerate(self.current_fun_callee_saved_regs):
            asm.append(f'  sd {reg_to_save}, {total_stack_size - 8 * (i + 1)}(sp)')
        asm.append(f'  addi fp, sp, {total_stack_size}')

        return asm

    def cevir_param(self, komut):
        param_name_id = komut[1]
        param_index = komut[2]
        asm = []
        if param_index <= 3:
            asm.extend(self.asm_reg_to_var('t0', param_name_id,
                                           f'a{2 * param_index}',
                                           f'a{2 * param_index + 1}'))
        else:
            non_reg_index = param_index - 4
            asm.extend([f'  ld t1, {16 * non_reg_index}(fp)',
                        f'  ld t2, {16 * non_reg_index + 8}(fp)'])
            asm.extend(self.asm_reg_to_var('t0', param_name_id,
                                           't1',
                                           't2'))

        return asm

    def cevir_ret(self, komut):
        asm = self.asm_var_or_const_to_reg(komut[1], 'a0', 'a1')
        return asm

    def cevir_endfun(self, komut):
        total_stack_size = self.current_stack_size + self.sp_extra_offset + self.fp_extra_offset
        asm = []
        for i, reg_to_save in enumerate(self.current_fun_callee_saved_regs):
            asm.append(f'  ld {reg_to_save}, {total_stack_size - 8 * (i + 1)}(sp)')
        if total_stack_size > 0:
            asm.extend([f'  addi sp, sp, {total_stack_size}'])
        asm.append(f'  ret')
        self.sp_extra_offset = 0
        self.fp_extra_offset = 0
        self.current_fun_callee_saved_regs = {}
        return asm

    def cevir_branch_if_true(self, komut):
        asm = []
        asm.extend(self.asm_var_or_const_to_reg(komut[1], None, 't0'))
        asm.extend([f'  bne t0, zero, {komut[2]}'])
        return asm

    def cevir_branch_if_false(self, komut):
        asm = []
        asm.extend(self.asm_var_or_const_to_reg(komut[1], None, 't0'))
        asm.extend([f'  beq t0, zero, {komut[2]}'])
        return asm

    def ceviriler_mantiksal(self, komut):
        # assuming type is 3 (bool)
        result_name = komut[1]
        operand0_name = komut[2]

        asm = []
        asm.extend(self.asm_var_or_const_to_reg(operand0_name, None, 't0'))
        if komut[0] in ['and', 'or']:
            operand1_name = komut[3]
            asm.extend(self.asm_var_or_const_to_reg(operand1_name, None, 't1'))
            asm.extend([f'  {komut[0]} t0, t0, t1'])
        elif komut[0] == '!':
            asm.extend([f'  xori t0, t0, 1'])

        asm.extend([f'  li t2, {self.tip_rakamlari["bool"]}'])
        asm.extend(self.asm_reg_to_var('t1', result_name, 't2', 't0'))

        return asm

    def ceviriler_karsilastirma(self, komut):
        if komut[0] == '>':
            return self.ceviriler_karsilastirma(['<', komut[1], komut[3], komut[2]])
        elif komut[0] == '>=':
            return self.ceviriler_karsilastirma(['<=', komut[1], komut[3], komut[2]])

        # assuming type is 0 (int)
        result_name = komut[1]
        operand0_name = komut[2]
        operand1_name = komut[3]

        asm = []
        asm.extend(self.asm_var_or_const_to_reg(operand0_name, None, 't0'))
        asm.extend(self.asm_var_or_const_to_reg(operand1_name, None, 't1'))

        if komut[0] == '<':
            asm.extend([f'  slt t2, t0, t1'])
        elif komut[0] == '<=':
            asm.extend([f'  slt t2, t0, t1',
                        f'  sub t0, t0, t1',
                        f'  seqz t0, t0',
                        f'  or t2, t2, t0'])
        elif komut[0] in ['==', '!=']:
            asm.extend([f'  sub t0, t0, t1',
                        f'  {"seqz" if komut[0] == "==" else "snez"} t2, t0'])

        asm.extend([f'  li t1, {self.tip_rakamlari["bool"]}'])
        asm.extend(self.asm_reg_to_var('t0', result_name, 't1', 't2'))
        return asm

    def _type_addr(self, place: NameIdPair):
        degisken_adresleri = self.func_activation_records[self.current_fun_label].degisken_goreli_adresleri
        key = (place['name'], place['id'])
        if key in degisken_adresleri:
            return str(self.sp_extra_offset + degisken_adresleri[key]) + '(sp)'
        else:
            return None

    def _value_addr(self, place: NameIdPair):
        degisken_adresleri = self.func_activation_records[self.current_fun_label].degisken_goreli_adresleri
        key = (place['name'], place['id'])
        if key in degisken_adresleri:
            return str(self.sp_extra_offset + degisken_adresleri[key] + 8) + '(sp)'
        else:
            return None

    def _length_addr(self, place: NameIdPair):
        """
        only works right after vector variable initialization since variable vector address can change.
        """
        degisken_adresleri = self.func_activation_records[self.current_fun_label].degisken_goreli_adresleri
        key = (place['name'], place['id'])
        if key in degisken_adresleri:
            return str(self.sp_extra_offset + degisken_adresleri[key] + 16) + '(sp)'
        else:
            return None

    def _vector_first_elm_sp_index(self, place: NameIdPair):
        """
        only works right after vector variable initialization since variable vector address can change.
        """
        degisken_adresleri = self.func_activation_records[self.current_fun_label].degisken_goreli_adresleri
        key = (place['name'], place['id'])
        if key in degisken_adresleri:
            return self.sp_extra_offset + degisken_adresleri[key] + 24
        else:
            return None


class Compiler:
    def __init__(self, ast: ast_tools.Program, asm_yapici_cls: Type[AssemblyYapici]):
        self.ast: ast_tools.Program = ast
        self.ara_dil_yapici_visitor = AraDilYapiciVisitor()
        self.assembly_lines: List[str] = []
        self.ara_dil_satirlari: List[List[Any]] = []
        self.AssemblyYapici: Type[AssemblyYapici] = asm_yapici_cls
        self.asm_yapici: Optional[AssemblyYapici] = None

    def ast_optimize_et(self):
        changes_made = True
        while changes_made:
            constant_folder = optimizer.ConstantFoldingVisitor()
            constant_folder.visit(self.ast)
            changes_made = constant_folder.changes_made
            if not changes_made:
                break
            constant_propagator = optimizer.ConstantPropogationVisitor()
            constant_propagator.visit(self.ast)
            changes_made = constant_propagator.changes_made

        olu_kod_oldurucu = optimizer.OluKodOldurucuVisitor()
        olu_kod_oldurucu.visit(self.ast)

    def ara_dil_optimize_et(self):
        pass

    def assembly_optimize_et(self):
        pass

    def ara_dil_yap(self):
        self.ara_dil_yapici_visitor.visit(self.ast)
        self.ara_dil_satirlari = self.ara_dil_yapici_visitor.ara_dil_sozleri

    def assembly_yap(self):
        self.asm_yapici = self.AssemblyYapici(self.ara_dil_yapici_visitor.global_vars,
                                              self.ara_dil_yapici_visitor.func_activation_records,
                                              self.ara_dil_yapici_visitor.global_string_to_label,
                                              self.ara_dil_satirlari)
        self.assembly_lines = self.asm_yapici.yap()

    def compile(self):
        self.ast_optimize_et()
        self.ara_dil_yap()
        self.ara_dil_optimize_et()
        self.ara_dildeki_floatlari_int_yap()
        self.assembly_yap()
        self.assembly_optimize_et()

        return self

    def save_ass(self, filename: str):
        with open(filename, 'w') as asm_dosyasi:
            for satir in self.assembly_lines:
                asm_dosyasi.write(f'{satir}\n')

        return self

    def ara_dildeki_floatlari_int_yap(self):
        for komut in self.ara_dil_satirlari:
            for i, arg in enumerate(komut):
                if type(arg) == float:
                    komut[i] = int(arg)
