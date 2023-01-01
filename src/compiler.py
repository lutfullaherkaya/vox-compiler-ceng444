# https://medium.com/swlh/risc-v-assembly-for-beginners-387c6cd02c49

from typing import Dict, Optional, Union, List
import ast_tools
import misc
from AraDilYapici import AraDilYapiciVisitor
from AraDilYapici import ActivationRecord
import compiler_utils as cu
import sys


def compilation_error(error):
    sys.stderr.write('Compilation error: ' + error)


def runtime_error(error):
    sys.stderr.write('Runtime error: ' + error)


def get_global_type_name(var_name):
    return f'global_{var_name}_type'


def get_global_value_name(var_name):
    return f'global_{var_name}_value'


class AssemblyYapici:
    def __init__(self, global_vars, main_activation_record: ActivationRecord):
        self.global_vars = global_vars
        self.main_activation_record = main_activation_record
        self.sp_extra_offset = 0
        self.aradil_sozlugu = {
            'call': self.call_den_asm_ye,
            'param': self.param_dan_asm_ye,
            'copy': self.copy_den_asm_ye,
            'global': self.global_den_asm_ye,
            'branch': self.branch_den_asm_ye,
            'branch_if_true': self.branch_if_true_den_asm_ye,
            'branch_if_false': self.branch_if_false_den_asm_ye,
            'label': self.label_den_asm_ye,
            'fun': self.fun_den_asm_ye,
            '+': self.dortislem_den_asm_ye,
            '-': self.dortislem_den_asm_ye,
            '*': self.dortislem_den_asm_ye,
            '/': self.dortislem_den_asm_ye,
            'and': self.mantiksal_den_asm_ye,
            'or': self.mantiksal_den_asm_ye,
            '!': self.mantiksal_den_asm_ye,
            '<': self.karsilastirma_dan_asm_ye,
            '>': self.karsilastirma_dan_asm_ye,
            '<=': self.karsilastirma_dan_asm_ye,
            '>=': self.karsilastirma_dan_asm_ye,
            '==': self.karsilastirma_dan_asm_ye,
            '!=': self.karsilastirma_dan_asm_ye,

        }
        self.type_values = {
            'int': 0,
            'vector': 1,
            'bool': 2,
        }

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

    def param_dan_asm_ye(self, komut):
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

        return '\n'.join(asm) + '\n'

    # todo
    def call_den_asm_ye(self, komut):
        asm = ['  mv a1, sp',
               f'  li a0, {komut[3]}',
               f'  call {komut[2]}',
               f'  addi sp, sp, {16 * komut[3]}']

        self.sp_extra_offset -= 16 * komut[3]

        if komut[1] is not None:
            asm.extend(self.asm_reg_to_var('t0', komut[1], 'a0', 'a1'))

        return '\n'.join(asm) + '\n'

    def copy_den_asm_ye(self, komut):
        type_addr = self._type_addr(komut[1])
        value_addr = self._value_addr(komut[1])
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
                type_addr_from = self._type_addr(komut[2])
                value_addr_from = self._value_addr(komut[2])
                asm.extend(self.asm_var_to_reg(komut[2], 't0', 't1'))
                asm.extend(self.asm_reg_to_var('t2', komut[1], 't0', 't1'))

        return '\n'.join(asm) + '\n'

    def global_den_asm_ye(self, komut):
        # Compiler sınıfı oluşturur globalleri
        return ''

    def branch_den_asm_ye(self, komut):
        return f'  j {komut[1]}\n'

    def label_den_asm_ye(self, komut):
        return f'{komut[1]}:\n'

    def fun_den_asm_ye(self, komut):
        asm = []

        return f'{komut[1]}:\n'

    def branch_if_true_den_asm_ye(self, komut):
        asm = []
        asm.extend(self.asm_var_to_reg(komut[1], None, 't0'))
        asm.extend([f'  bne t0, zero, {komut[2]}'])
        return '\n'.join(asm) + '\n'

    def branch_if_false_den_asm_ye(self, komut):
        asm = []
        asm.extend(self.asm_var_to_reg(komut[1], None, 't0'))
        asm.extend([f'  beq t0, zero, {komut[2]}'])
        return '\n'.join(asm) + '\n'

    def dortislem_den_asm_ye(self, komut):
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
        return '\n'.join(asm) + '\n'

    def mantiksal_den_asm_ye(self, komut):
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

        return '\n'.join(asm) + '\n'

    def karsilastirma_dan_asm_ye(self, komut):
        if komut[0] == '>':
            return self.karsilastirma_dan_asm_ye(['<', komut[1], komut[3], komut[2]])
        elif komut[0] == '>=':
            return self.karsilastirma_dan_asm_ye(['<=', komut[1], komut[3], komut[2]])

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
        return '\n'.join(asm) + '\n'

    def _type_addr(self, place):
        goreli_adresler = self.main_activation_record.degisken_goreli_adresleri
        key = (place['name'], place['id'])
        if key in goreli_adresler:
            return str(self.sp_extra_offset + goreli_adresler[key]) + '(sp)'
        else:
            return None

    def _value_addr(self, place):
        goreli_adresler = self.main_activation_record.degisken_goreli_adresleri
        key = (place['name'], place['id'])
        if key in goreli_adresler:
            return str(self.sp_extra_offset + goreli_adresler[key] + 8) + '(sp)'
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
        relative_addr_table = {place: addr for (place, addr) in zip(places, range(0, stack_size - 8, 16))}
        on_soz = [
            f'#include "vox_lib.h"',
            f'  ',
            f'  .global main',
            f'  .text',
            f'  .align 2',
            f'main:',
            f'  addi sp, sp, -{stack_size}',
            f'  sd ra, {stack_size - 8}(sp)'  # caller saved oldugu icin stacke kaydediyoruz
        ]
        son_soz = [
            f'  ld ra, {stack_size - 8}(sp)',  # caller saved oldugu icin stackten cekiyoruz
            f'  addi sp, sp, {stack_size}',
            f'  mv a0, zero',
            f'  ret'
        ]

        with open(filename, 'w') as asm_dosyasi:
            for satir in on_soz:
                asm_dosyasi.write(f'{satir}\n')
            asm_yapici = AssemblyYapici(self.ara_dil_yapici_visitor.global_vars,
                                        self.ara_dil_yapici_visitor.main_activation_record)

            for komut in self.ara_dil_yapici_visitor.ara_dil_sozleri:
                asm_dosyasi.write('            # ' + cu.komut_stringi_yap(komut) + '\n')
                asm_dosyasi.write(asm_yapici.aradilden_asm(komut))
            for satir in son_soz:
                asm_dosyasi.write(f'{satir}\n')

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
