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
    
    https://www.geeksforgeeks.org/basic-blocks-in-compiler-design/
    https://www.geeksforgeeks.org/directed-acyclic-graph-in-compiler-design-with-examples/
    https://www.codingninjas.com/codestudio/library/dag-representation
    https://www.javatpoint.com/dag-representation-for-basic-blocks
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
    vector negatif index, belki pythondaki gibi atlamali seyler
    
    print(a) çalışmıyor
        
    optimizasyon döngüsü çok uzun sürerse bıraksın onu ayarla. mesela 1 sn sürerse döngüden çıksın.
    reaching definition kullanmadığım için propogation çok verimli olmayabilir.
    
    sabit vektörleri de compile timede propogate et
    vektor[i] leri de compile timede propogate et
    

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
        self.fun_records: Dict[str, ActivationRecord] = func_activation_records
        self.global_string_to_label: Dict[str, str] = global_string_to_label
        self.aradil_sozlugu: Dict[str, Callable[[List[Any], int], List[str]]] = {}
        self.ara_dil_satirlari: List[List[Any]] = ara_dil_satirlari

    def aradilden_asm(self, komut, komut_indeksi=None):
        if komut[0] in self.aradil_sozlugu:
            asm = []
            if komut[0] != 'fun':
                asm.append('            # ' + cu.komut_stringi_yap(komut))
            asm.extend(self.aradil_sozlugu[komut[0]](komut, komut_indeksi))
            return asm
        else:
            return f'ERROR! Unknown IL {komut}'

    @abstractmethod
    def yap(self) -> List[str]:
        pass


class RiscVFunctionInfo:
    def __init__(self, activation_record: ActivationRecord):
        self.callee_saved_regs: Dict[str, bool] = {}
        self.activation_record: ActivationRecord = activation_record
        self.current_stack_size = activation_record.son_goreli_adres
        self.sp_extra_offset = 0
        self.fp_extra_offset = 0

    def get_total_stack_size(self):
        return self.sp_extra_offset + self.fp_extra_offset + self.current_stack_size

    def get_non_reg_arg_count(self):
        return max(self.activation_record.arg_count - 4, 0)

    def add_to_callee_saved_regs(self, regs: Union[str, List[str]]):
        """

        :param regs:registers to be saved when declaring a function and restored when exiting
        :return:
        """
        if isinstance(regs, str):
            regs = [regs]
        for reg in regs:
            if reg not in self.callee_saved_regs:
                self.callee_saved_regs[reg] = True
                self.fp_extra_offset += 8


class RiscVAssemblyYapici(AssemblyYapici):
    def __init__(self,
                 global_vars: Dict[str, VarDecl],
                 func_activation_records: Dict[str, ActivationRecord],
                 global_string_to_label: Dict[str, str],
                 ara_dil_satirlari: List[List[Any]]):
        super().__init__(global_vars, func_activation_records, global_string_to_label, ara_dil_satirlari)
        self.fun_infos: Dict[str, RiscVFunctionInfo] = {fun_name: RiscVFunctionInfo(self.fun_records[fun_name])
                                                        for fun_name in self.fun_records}
        self.current_fun_label = ''
        self.current_arg_index = -1
        self.current_param_index = -1
        self.aradil_sozlugu = {
            'fun': self.cevir_fun,
            'return': self.cevir_return,
            'call': self.cevir_call,
            'copy': self.cevir_copy,
            'arg': self.cevir_arg,
            'vector': self.cevir_vector,
            'vector_set': self.cevir_vector_set,
            'vector_get': self.cevir_vector_get,
            'global': self.cevir_global,
            'branch': self.cevir_branch,
            'branch_if_true': self.cevir_branch_if_true,
            'branch_if_false': self.cevir_branch_if_false,
            'label': self.cevir_label,
            'param': self.cevir_param,
            'and': self.ceviriler_mantiksal,
            'or': self.ceviriler_mantiksal,
            'add': self.ceviriler_aritmetik,
            'sub': self.ceviriler_aritmetik,
            'mul': self.ceviriler_aritmetik,
            'div': self.ceviriler_aritmetik,
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

        for i, komut in enumerate(self.ara_dil_satirlari):
            assembly_lines.extend(self.aradilden_asm(komut, i))

        if len(self.global_vars) > 0 or \
                len(self.global_string_to_label):
            assembly_lines.extend(['',
                                   '  .data'])
        for name, vardecl in self.global_vars.items():
            if vardecl.initializer is not None:
                if type(vardecl.initializer) == list:
                    global_vector_name = get_global_vector_name(name)
                    assembly_lines.extend([f'{get_global_type_name(name)}:    .quad {self.tip_rakamlari["vector"]}',
                                           f'{get_global_value_name(name)}:   .quad {global_vector_name}',
                                           f'{get_global_length_name(name)}:  .quad {len(vardecl.initializer)}',
                                           f'{global_vector_name}:'])
                    for i in range(len(vardecl.initializer)):
                        assembly_lines.append('  .quad 0, 0')
                    assembly_lines.append('')
                elif isinstance(vardecl.initializer, ast_tools.ALiteral):
                    assembly_lines.extend([f'{get_global_type_name(name)}:   .quad {self.tip_rakamlari["int"]}',
                                           f'{get_global_value_name(name)}:  .quad {int(vardecl.initializer.value)}',
                                           f''])
                elif isinstance(vardecl.initializer, ast_tools.SLiteral):
                    assembly_lines.extend([f'{get_global_type_name(name)}:   .quad {self.tip_rakamlari["string"]}',
                                           f'{get_global_value_name(name)}:  .quad {self.global_string_to_label[vardecl.initializer.value]}',
                                           f''])
                elif isinstance(vardecl.initializer, ast_tools.LLiteral):
                    assembly_lines.extend([f'{get_global_type_name(name)}:   .quad {self.tip_rakamlari["bool"]}',
                                           f'{get_global_value_name(name)}:  .quad {int(vardecl.initializer.value)}',
                                           f''])
                else:
                    assembly_lines.extend([f'{get_global_type_name(name)}:   .quad {self.tip_rakamlari["int"]}',
                                           f'{get_global_value_name(name)}:  .quad 0',
                                           f''])
            else:
                assembly_lines.extend([f'{get_global_type_name(name)}:   .quad {self.tip_rakamlari["int"]}',
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
            if index > 0:
                asm.extend([f'  addi {addr_reg}, {addr_reg}, {index * 16}'])
        else:
            asm.extend(self.asm_var_or_const_to_reg(index, None, tmp_reg))
            asm.extend([f'  slli {tmp_reg}, {tmp_reg}, 4',
                        f'  add {addr_reg}, {addr_reg}, {tmp_reg}'])
        return asm

    def cevir_arg(self, komut, komut_indeksi=None):
        arg_name_id = komut[1]
        asm = []
        if self.current_arg_index == -1:  # first arg
            arg_count = 1
            while self.ara_dil_satirlari[komut_indeksi + arg_count][0] != 'call':
                arg_count += 1

            non_reg_arg_cnt = max(arg_count - 4, 0)
            if non_reg_arg_cnt > 0:
                self.fun_infos[self.current_fun_label].sp_extra_offset += 16 * non_reg_arg_cnt
                asm.append(f'  addi sp, sp, -{16 * non_reg_arg_cnt}')
        self.current_arg_index += 1
        if self.current_arg_index <= 3:
            asm.extend(self.asm_var_or_const_to_reg(arg_name_id,
                                                    f'a{2 * self.current_arg_index}',
                                                    f'a{2 * self.current_arg_index + 1}'))
        else:
            non_reg_index = self.current_arg_index - 4
            asm.extend(self.asm_var_or_const_to_reg(arg_name_id, 't0', 't1'))
            asm.extend([f'  sd t0, {16 * non_reg_index}(sp)',
                        f'  sd t1, {16 * non_reg_index + 8}(sp)'])

        return asm

    def cevir_call(self, komut, komut_indeksi=None):
        ret_val_name_id = komut[1]
        func_name = komut[2]

        non_reg_arg_count = max(self.current_arg_index + 1 - 4, 0)
        self.current_arg_index = -1
        asm = [f'  call {func_name}']
        if non_reg_arg_count > 0:
            asm.append(f'  addi sp, sp, {16 * non_reg_arg_count}')
            self.fun_infos[self.current_fun_label].sp_extra_offset -= 16 * non_reg_arg_count

        if ret_val_name_id is not None:
            asm.extend(self.asm_reg_to_var('t0', ret_val_name_id, 'a0', 'a1'))

        return asm

    def cevir_copy(self, komut, komut_indeksi=None):
        asm = []
        if len(komut) < 3:
            asm.extend(self.asm_reg_to_var('t0', komut[1], 'zero', 'zero'))
        else:
            asm.extend(self.asm_var_or_const_to_reg(komut[2], 't0', 't1'))
            asm.extend(self.asm_reg_to_var('t2', komut[1], 't0', 't1'))

        return asm

    def cevir_vector(self, komut, komut_indeksi=None):
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

    def cevir_vector_set(self, komut, komut_indeksi=None):
        vector_name_id = komut[1]
        index = komut[2]
        expr_name_id = komut[3]
        asm = []
        asm.extend(self.asm_get_vector_elm_addr('t0', 't2', vector_name_id, index))
        asm.extend(self.asm_var_or_const_to_reg(expr_name_id, 't0', 't1'))
        asm.extend([f'  sd t0, 0(t2)',
                    f'  sd t1, 8(t2)'])
        return asm

    def cevir_vector_get(self, komut, komut_indeksi=None):
        result_name_id = komut[1]
        vector_name_id = komut[2]
        index = komut[3]
        asm = []
        asm.extend(self.asm_get_vector_elm_addr('t0', 't1', vector_name_id, index))
        asm.extend([f'  ld t0, 0(t1)',
                    f'  ld t1, 8(t1)'])
        asm.extend(self.asm_reg_to_var('t2', result_name_id, 't0', 't1'))

        return asm

    def cevir_global(self, komut, komut_indeksi=None):
        # Compiler sınıfı oluşturur globalleri
        return []

    def cevir_branch(self, komut, komut_indeksi=None):
        return [f'  j {komut[1]}']

    def cevir_label(self, komut, komut_indeksi=None):
        return [f'{komut[1]}:']

    def cevir_fun(self, komut, komut_indeksi=None):
        label = komut[1]
        signature = komut[2]
        param_count = komut[3]

        self.current_fun_label = label
        if self.fun_infos[self.current_fun_label].activation_record.calls_another_fun:
            self.fun_infos[self.current_fun_label].add_to_callee_saved_regs(['ra'])
        total_stack_size = self.fun_infos[self.current_fun_label].get_total_stack_size()
        asm = [f'',
               f'# fun {signature};',
               f'{label}:']
        if total_stack_size > 0:
            asm.append(f'  addi sp, sp, -{total_stack_size}')

        for i, reg_to_save in enumerate(self.fun_infos[self.current_fun_label].callee_saved_regs):
            asm.append(f'  sd {reg_to_save}, {total_stack_size - 8 * (i + 1)}(sp)')

        return asm

    def cevir_param(self, komut, komut_indeksi=None):
        param_name_id = komut[1]
        self.current_param_index += 1
        asm = []
        if self.current_param_index <= 3:
            asm.extend(self.asm_reg_to_var('t0', param_name_id,
                                           f'a{2 * self.current_param_index}',
                                           f'a{2 * self.current_param_index + 1}'))
        else:
            total_stack_size = self.fun_infos[self.current_fun_label].get_total_stack_size()
            non_reg_index = self.current_param_index - 4
            asm.extend([f'  ld t1, {16 * non_reg_index + total_stack_size}(sp)',
                        f'  ld t2, {16 * non_reg_index + 8 + total_stack_size}(sp)'])
            asm.extend(self.asm_reg_to_var('t0', param_name_id,
                                           't1',
                                           't2'))
        if self.current_param_index == self.fun_infos[self.current_fun_label].activation_record.arg_count - 1:
            self.current_param_index = -1
        return asm

    def cevir_return(self, komut, komut_indeksi=None):
        asm = []
        if len(komut) >= 2:
            asm.extend(self.asm_var_or_const_to_reg(komut[1], 'a0', 'a1'))

        total_stack_size = self.fun_infos[self.current_fun_label].get_total_stack_size()
        for i, reg_to_save in enumerate(self.fun_infos[self.current_fun_label].callee_saved_regs):
            asm.append(f'  ld {reg_to_save}, {total_stack_size - 8 * (i + 1)}(sp)')
        if total_stack_size > 0:
            asm.extend([f'  addi sp, sp, {total_stack_size}'])
        if self.current_fun_label == 'main':
            asm.append('  li a0, 0')
        asm.append(f'  ret')
        return asm

    def cevir_branch_if_true(self, komut, komut_indeksi=None):
        asm = []
        asm.extend(self.asm_var_or_const_to_reg(komut[1], None, 't0'))
        asm.extend([f'  bne t0, zero, {komut[2]}'])
        return asm

    def cevir_branch_if_false(self, komut, komut_indeksi=None):
        asm = []
        asm.extend(self.asm_var_or_const_to_reg(komut[1], None, 't0'))
        asm.extend([f'  beq t0, zero, {komut[2]}'])
        return asm

    def ceviriler_mantiksal(self, komut, komut_indeksi=None):
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

    def ceviriler_aritmetik(self, komut, komut_indeksi=None):
        result_name_id = komut[1]
        left_name_id = komut[2]
        right_name_id = komut[3]
        asm = []
        asm.extend(self.asm_var_or_const_to_reg(left_name_id, 'a0', 'a1'))
        asm.extend(self.asm_var_or_const_to_reg(right_name_id, 'a2', 'a3'))
        asm.extend([f'  call __vox_{komut[0]}__'])
        asm.extend(self.asm_reg_to_var('t0', result_name_id, 'a0', 'a1'))
        return asm

    def ceviriler_karsilastirma(self, komut, komut_indeksi=None):
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
        degisken_adresleri = self.fun_records[self.current_fun_label].degisken_goreli_adresleri
        key = (place['name'], place['id'])
        if key in degisken_adresleri:
            return str(self.fun_infos[self.current_fun_label].sp_extra_offset + degisken_adresleri[key]) + '(sp)'
        else:
            return None

    def _value_addr(self, place: NameIdPair):
        degisken_adresleri = self.fun_records[self.current_fun_label].degisken_goreli_adresleri
        key = (place['name'], place['id'])
        if key in degisken_adresleri:
            return str(self.fun_infos[self.current_fun_label].sp_extra_offset + degisken_adresleri[key] + 8) + '(sp)'
        else:
            return None

    def _length_addr(self, place: NameIdPair):
        """
        only works right after vector variable initialization since variable vector address can change.
        """
        degisken_adresleri = self.fun_records[self.current_fun_label].degisken_goreli_adresleri
        key = (place['name'], place['id'])
        if key in degisken_adresleri:
            return str(self.fun_infos[self.current_fun_label].sp_extra_offset + degisken_adresleri[key] + 16) + '(sp)'
        else:
            return None

    def _vector_first_elm_sp_index(self, place: NameIdPair):
        """
        only works right after vector variable initialization since variable vector address can change.
        """
        degisken_adresleri = self.fun_records[self.current_fun_label].degisken_goreli_adresleri
        key = (place['name'], place['id'])
        if key in degisken_adresleri:
            return self.fun_infos[self.current_fun_label].sp_extra_offset + degisken_adresleri[key] + 24
        else:
            return None


class BasicBlock:
    def __init__(self):
        self.komutlar: List[List[Any]] = []

    def add(self, komut):
        self.komutlar.append(komut)


class DAGNode:
    def __init__(self, label=None, identifiers=None, left: "DAGNode" = None, right: "DAGNode" = None):
        self.label = label
        if identifiers is None:
            self.identifiers = []
        else:
            self.identifiers = identifiers
        self.left: Optional[DAGNode] = left
        self.right: Optional[DAGNode] = right


class DAGBlock:
    def __init__(self, block: BasicBlock):
        self.block: BasicBlock = block
        self.vars_to_node = {}
        binary_ops = ['add', 'sub', 'mul', 'div', 'and', 'or', '<', '>', '<=', '>=', '==', '!=']
        unary_ops = ['!']
        self.nodes: List[DAGNode] = []

        for komut in block.komutlar:
            if komut[0] in binary_ops + unary_ops + ['copy']:
                x = komut[1]
                y = komut[2]
                n = None
                if y not in self.vars_to_node:
                    self.vars_to_node[y] = DAGNode(identifiers=[y])
                    self.nodes.append(self.vars_to_node[y])
                if komut[0] in binary_ops:  # case 1
                    op = komut[0]
                    z = komut[3]
                    if z not in self.vars_to_node:
                        self.vars_to_node[z] = DAGNode(identifiers=[z])
                        self.nodes.append(self.vars_to_node[z])
                    n = DAGNode(op, left=self.vars_to_node[y], right=self.vars_to_node[z])
                    self.nodes.append(n)
                elif komut[0] in unary_ops:  # case 2
                    op = komut[0]

                    for node in self.nodes:
                        if node.label == op and node.right is None and node.left is self.vars_to_node[y]:
                            n = node
                            break
                    if n is None:
                        n = DAGNode(label=op, left=self.vars_to_node[y])
                        self.nodes.append(n)
                elif komut[0] == 'copy':  # case 3
                    n = self.vars_to_node[y]
                if x in self.vars_to_node:
                    self.vars_to_node[x].identifiers.remove(x)
                    self.vars_to_node.pop(x)

                n.identifiers.append(x)
                self.vars_to_node[x] = n


class DAG:
    def __init__(self, ara_dil_satirlari: List[List[Any]]):
        self.ara_dil_satirlari: List[List[Any]] = ara_dil_satirlari
        self.fun_basic_blocks: Dict[str, List[BasicBlock]] = {}
        self.fun_dags: Dict[str, List[DAGBlock]] = {}

    def generate_basic_blocks(self):
        current_func = None
        for komut in self.ara_dil_satirlari:
            if komut[0] == 'fun':
                current_func = komut[1]
                self.fun_basic_blocks[current_func] = [BasicBlock()]
            if komut[0] in ['label']:
                self.fun_basic_blocks[current_func].append(BasicBlock())
                self.fun_basic_blocks[current_func][-1].add(komut)
            elif komut[0] in ['branch_if_true', 'branch_if_false', 'branch', 'call', 'return']:
                self.fun_basic_blocks[current_func][-1].add(komut)
                self.fun_basic_blocks[current_func].append(BasicBlock())
            else:
                self.fun_basic_blocks[current_func][-1].add(komut)

    def generate_dag(self):
        for fun_name in self.fun_basic_blocks:
            self.fun_dags[fun_name] = []
            for block in self.fun_basic_blocks[fun_name]:
                if len(block.komutlar) > 0:
                    self.fun_dags[fun_name].append(DAGBlock(block))


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

            # todo: bu calismiyor.  reaching definition analysis lazım.
            # constant_propagator = optimizer.ConstantPropogationVisitor()
            # constant_propagator.visit(self.ast)

            olu_kod_oldurucu = optimizer.OluKodOldurucuVisitor()
            olu_kod_oldurucu.visit(self.ast)

            changes_made = olu_kod_oldurucu.changes_made or constant_folder.changes_made  # or constant_propagator.changes_made
            # print(ast_tools.PrintVisitor().visit(self.ast))

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
        dag = DAG(self.ara_dil_satirlari)
        dag.generate_basic_blocks()
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


if __name__ == '__main__':
    bb = BasicBlock()
    bb.add(['mul', 'a', 'b', 'c'])
    bb.add(['copy', 'd', 'b'])
    bb.add(['mul', 'e', 'd', 'c'])
    bb.add(['copy', 'b', 'e'])
    bb.add(['add', 'f', 'b', 'c'])
    bb.add(['add', 'g', 'd', 'f'])
    block = DAGBlock(bb)
    print(1)
