# https://medium.com/swlh/risc-v-assembly-for-beginners-387c6cd02c49

from typing import Dict, Optional, Union, List
import ast_tools
import misc
from AraDilYapici import AraDilYapiciVisitor
from AraDilYapici import ActivationRecord
from collections import OrderedDict
import compiler_utils as cu
import sys

"""
    Eksikler:
    implement strings
    Implement function parameters (a restriction of maximum 7 formal parameters is ok)
    
    e. Implement vectors as an additional type to integers. Overload "+,-,*,/" for vectors of same size so that they do element-wise operations with the parallel instructions of the V extension. (10 pts)
    
    
    Bonus:
    
    After you are done with all of the compulsory steps, you can also implement optional features you'd like Vox to have. These will help you get that Gazozuna Compiler award. Some of them could be:
    - Lower amount of temporary variables, better register allocation and lower register spill.
    - Reals in addition to integers (just like Javascript).
    - Garbage collection.
    - Runtime errors.
    - Functions with more than 7 formal parameters.
    - Vectors can hold a mixture of types and other vectors.
    - Cool additional syntactic sugar (like list expressions in Python).
    
    Eksik parametre kontrolü ve hatası
    Optimizasyon belki

"""


def compilation_error(error):
    sys.stderr.write('Compilation error: ' + error)


def runtime_error(error):
    sys.stderr.write('Runtime error: ' + error)


def get_global_type_name(var_name):
    return f'global_{var_name}_type'


def get_global_value_name(var_name):
    return f'global_{var_name}_value'


class AssemblyYapici:
    def __init__(self, global_vars, func_activation_records: Dict[str, ActivationRecord]):
        self.global_vars = global_vars
        self.func_activation_records: Dict[str, ActivationRecord] = func_activation_records
        self.sp_extra_offset = 0
        self.current_stack_size = 0
        self.current_fun_label = ''
        self.aradil_sozlugu = {
            'call_vox_lib': self.cevir_call_vox_lib,
            'arg_vox_lib': self.cevir_arg_vox_lib,
            'call': self.cevir_call,
            'arg': self.cevir_arg,
            'copy': self.cevir_copy,
            'global': self.cevir_global,
            'branch': self.cevir_branch,
            'branch_if_true': self.cevir_branch_if_true,
            'branch_if_false': self.cevir_branch_if_false,
            'label': self.cevir_label,
            'fun': self.cevir_fun,
            'param': self.cevir_param,
            'ret': self.cevir_ret,
            'endfun': self.cevir_endfun,
            '+': self.ceviriler_dortislem,
            '-': self.ceviriler_dortislem,
            '*': self.ceviriler_dortislem,
            '/': self.ceviriler_dortislem,
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
        self.type_values = {
            'int': 0,
            'vector': 1,
            'bool': 2,
        }
        self.current_fun_callee_saved_regs = OrderedDict()

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
                self.sp_extra_offset += 8

    def asm_var_to_reg(self, var_name_id, type_reg=None, value_reg=None):
        # asm = [f'      # asm_var_to_reg(var:{var_name}, type_reg:{type_reg}, value_reg:{value_reg})']
        asm = []
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
            compilation_error(f'Unknown variable {var_name_id["name"]}')
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
            compilation_error(f'Unknown variable {var_name_id["name"]}')
        return asm

    def get_global_type_name(self, var_name):
        if var_name in self.global_vars:
            return self.global_vars[var_name]
        else:
            return None

    def aradilden_asm(self, komut):
        if komut[0] in self.aradil_sozlugu:
            return self.aradil_sozlugu[komut[0]](komut)
        else:
            return f'ERROR! Unknown IL {komut}'

    def cevir_arg_vox_lib(self, komut):
        self.sp_extra_offset += 16
        asm = ['  addi sp, sp, -16']

        if type(komut[1]) == int:
            asm.extend([f'  sd zero, (sp)',
                        f'  li t0, {komut[1]}',
                        f'  sd t0, 8(sp)'])
        else:
            # todo: vektor ve icin
            asm.extend(self.asm_var_to_reg(komut[1], 't0', 't1'))
            asm.extend([f'  sd t0, (sp)',
                        f'  sd t1, 8(sp)'])

        return asm

    def cevir_arg(self, komut):
        arg_name_id = komut[1]
        arg_index = komut[2]
        asm = []
        if arg_index <= 3:
            asm.extend(self.asm_var_to_reg(arg_name_id,
                                           f'a{2 * arg_index}',
                                           f'a{2 * arg_index + 1}'))
        else:
            # todo: implement more than 3 args
            pass

        return asm

    def cevir_call_vox_lib(self, komut):
        asm = ['  mv a1, sp']
        if len(komut) > 3:
            # todo: implement func args
            asm.append(f'  li a0, {komut[3]}')

        asm.extend([f'  call {komut[2]}'])

        if len(komut) > 3:
            asm.extend([f'  addi sp, sp, {16 * komut[3]}'])
            self.sp_extra_offset -= 16 * komut[3]

        if komut[1] is not None:
            asm.extend(self.asm_reg_to_var('t0', komut[1], 'a0', 'a1'))

        return asm

    def cevir_call(self, komut):
        ret_val_name_id = komut[1]
        func_name = komut[2]
        asm = [f'  call {func_name}']
        if ret_val_name_id is not None:
            asm.extend(self.asm_reg_to_var('t0', ret_val_name_id, 'a0', 'a1'))

        return asm

    def cevir_copy(self, komut):

        asm = []
        if len(komut) < 3:
            asm.extend(self.asm_reg_to_var('t0', komut[1], 'zero', 'zero'))
        else:
            if type(komut[2]) == int:  # immediate
                asm.extend([f'  li t0, {komut[2]}'])
                asm.extend(self.asm_reg_to_var('t1', komut[1], 'zero', 't0'))
            elif type(komut[2]) == bool:
                asm.extend([f'  li t1, {self.type_values["bool"]}',
                            f'  li t2, {int(komut[2])}'])
                asm.extend(self.asm_reg_to_var('t0', komut[1], 't1', 't2'))
            else:  # değişken parametre için
                asm.extend(self.asm_var_to_reg(komut[2], 't0', 't1'))
                asm.extend(self.asm_reg_to_var('t2', komut[1], 't0', 't1'))

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
        degisken_adresleri = self.func_activation_records[label].degisken_goreli_adresleri
        self.add_to_saved_regs(['ra', 'fp'])

        self.current_stack_size = len(degisken_adresleri) * 16
        total_stack_size = self.current_stack_size + self.sp_extra_offset

        asm = [f'',
               f'# fun {signature};',
               f'{label}:',
               f'  addi sp, sp, -{total_stack_size}']

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
            # todo: implement more than 3 params
            pass

        return asm

    def cevir_ret(self, komut):
        asm = self.asm_var_to_reg(komut[1], 'a0', 'a1')
        return asm

    def cevir_endfun(self, komut):
        total_stack_size = self.current_stack_size + self.sp_extra_offset
        asm = []
        for i, reg_to_save in enumerate(self.current_fun_callee_saved_regs):
            asm.append(f'  ld {reg_to_save}, {total_stack_size - 8 * (i + 1)}(sp)')
        asm.extend([f'  addi sp, sp, {total_stack_size}',
                    f'  ret'])
        self.sp_extra_offset = 0
        self.current_fun_callee_saved_regs = OrderedDict()
        return asm

    def cevir_branch_if_true(self, komut):
        asm = []
        asm.extend(self.asm_var_to_reg(komut[1], None, 't0'))
        asm.extend([f'  bne t0, zero, {komut[2]}'])
        return asm

    def cevir_branch_if_false(self, komut):
        asm = []
        asm.extend(self.asm_var_to_reg(komut[1], None, 't0'))
        asm.extend([f'  beq t0, zero, {komut[2]}'])
        return asm

    def ceviriler_dortislem(self, komut):
        # assuming type is 0 (int)
        result_name = komut[1]
        operand0_name = komut[2]
        operand1_name = komut[3]

        islemler = {
            '+': 'add',
            '-': 'sub',
            '*': 'mul',
            '/': 'div',
        }
        islem = islemler[komut[0]]

        asm = []
        asm.extend(self.asm_var_to_reg(operand0_name, None, 't0'))
        asm.extend(self.asm_var_to_reg(operand1_name, None, 't1'))
        asm.extend([f'  {islem} t0, t0, t1'])
        asm.extend(self.asm_reg_to_var('t1', result_name, 'zero', 't0'))
        return asm

    def ceviriler_mantiksal(self, komut):
        # assuming type is 3 (bool)
        result_name = komut[1]
        operand0_name = komut[2]
        operand1_name = komut[3]

        asm = []
        asm.extend(self.asm_var_to_reg(operand0_name, None, 't0'))
        if komut[0] in ['and', 'or']:
            asm.extend(self.asm_var_to_reg(operand1_name, None, 't1'))
            asm.extend([f'  {komut[0]} t0, t0, t1'])
        elif komut[0] == '!':
            asm.extend([f'  xori t0, t0, 1'])

        asm.extend([f'  li t2, {self.type_values["bool"]}'])
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
        asm.extend(self.asm_var_to_reg(operand0_name, None, 't0'))
        asm.extend(self.asm_var_to_reg(operand1_name, None, 't1'))

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

        asm.extend([f'  li t1, {self.type_values["bool"]}'])
        asm.extend(self.asm_reg_to_var('t0', result_name, 't1', 't2'))
        return asm

    def _type_addr(self, place):
        degisken_adresleri = self.func_activation_records[self.current_fun_label].degisken_goreli_adresleri
        key = (place['name'], place['id'])
        if key in degisken_adresleri:
            return str(self.sp_extra_offset + degisken_adresleri[key]) + '(sp)'
        else:
            return None

    def _value_addr(self, place):
        degisken_adresleri = self.func_activation_records[self.current_fun_label].degisken_goreli_adresleri
        key = (place['name'], place['id'])
        if key in degisken_adresleri:
            return str(self.sp_extra_offset + degisken_adresleri[key] + 8) + '(sp)'
        else:
            return None


class Compiler:

    def __init__(self, program: ast_tools.Program):
        self.program = program
        self.main_assembly_lines = []
        self.ara_dil_yapici_visitor = AraDilYapiciVisitor()
        self.ara_dil_yapici_visitor.visit(self.program)
        self.ara_dildeki_floatlari_int_yap()

    def compile(self):
        print(self.ara_dil_yapici_visitor.ara_dil_sozleri)
        return self

    def save_ass(self, filename: str):
        places = self.ara_dil_yapici_visitor.main_activation_record.degisken_goreli_adresleri
        stack_size = len(places) * 16 + 8
        on_soz = [f'#include "vox_lib.h"',
                  f'  ',
                  f'  .global main',
                  f'  .text',
                  f'  .align 2']

        with open(filename, 'w') as asm_dosyasi:
            for satir in on_soz:
                asm_dosyasi.write(f'{satir}\n')
            asm_yapici = AssemblyYapici(self.ara_dil_yapici_visitor.global_vars,
                                        self.ara_dil_yapici_visitor.func_activation_records)

            for komut in self.ara_dil_yapici_visitor.ara_dil_sozleri:
                if komut[0] != 'fun':
                    asm_dosyasi.write('            # ' + cu.komut_stringi_yap(komut) + '\n')
                satirlar = asm_yapici.aradilden_asm(komut)
                if satirlar:
                    asm_dosyasi.write('\n'.join(satirlar))
                    asm_dosyasi.write('\n')

            if len(self.ara_dil_yapici_visitor.global_vars) > 0:
                asm_dosyasi.write(f'\n  .data\n')
                for global_name in self.ara_dil_yapici_visitor.global_vars:
                    asm_dosyasi.write(f'{get_global_type_name(global_name)}:  .quad 0\n')
                    asm_dosyasi.write(f'{get_global_value_name(global_name)}: .quad 0\n\n')

        return self

    def ara_dildeki_floatlari_int_yap(self):
        for komut in self.ara_dil_yapici_visitor.ara_dil_sozleri:
            for i, arg in enumerate(komut):
                if type(arg) == float:
                    komut[i] = int(arg)
