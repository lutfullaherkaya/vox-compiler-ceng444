# https://medium.com/swlh/risc-v-assembly-for-beginners-387c6cd02c49

from typing import Dict, Optional, Union, List
import ast_tools
import misc
from misc import AraDilYapiciVisitor
import compiler_utils as cu


class AssemblyYapici:
    def __init__(self, relative_addr_table):
        self.relative_addr_table = relative_addr_table
        self.sp_extra_offset = 0
        self.aradil_sozlugu = {
            'call': self.call_to_asm,
            'param': self.param_dan_asm_ye,
            'copy': self.copy_den_asm_ye,
            '+': self.dortislem_den_asm_ye,
            '-': self.dortislem_den_asm_ye,
            '*': self.dortislem_den_asm_ye,
            '/': self.dortislem_den_asm_ye,
        }

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
            # todo: vektor icin
            type_addr = self._type_addr(komut[1])
            value_addr = self._value_addr(komut[1])
            asm.extend([f'  ld t0, {type_addr}',
                        f'  sd t0, (sp)',
                        f'  ld t0, {value_addr}',
                        f'  sd t0, 8(sp)'])

        return '\n'.join(asm) + '\n'

    # todo
    def call_to_asm(self, komut):
        asm = ['  mv a1, sp',
               f'  li a0, {komut[3]}',
               f'  call {komut[2]}',
               f'  addi sp, sp, {16 * komut[3]}']

        self.sp_extra_offset -= 16 * komut[3]

        if komut[1] is not None:
            type_addr = self._type_addr(komut[1])
            value_addr = self._value_addr(komut[1])
            asm.extend([f'  sd a0, {type_addr}',
                        f'  sd a1, {value_addr}'])

        return '\n'.join(asm) + '\n'

    def copy_den_asm_ye(self, komut):
        type_addr = self._type_addr(komut[1])
        value_addr = self._value_addr(komut[1])

        if type(komut[2]) == int:
            asm = [f'  sd zero, {type_addr}',
                   f'  li t0, {komut[2]}',
                   f'  sd t0, {value_addr}']
        else:
            # todo: değişken parametre için
            type_addr_from = self._type_addr(komut[2])
            value_addr_from = self._value_addr(komut[2])
            asm = [f'  ld t0, {type_addr_from}',
                   f'  sd t0, {type_addr}',
                   f'  ld t0, {value_addr_from}',
                   f'  sd t0, {value_addr}']

        return '\n'.join(asm) + '\n'

    def dortislem_den_asm_ye(self, komut):
        result_type_addr = self._type_addr(komut[1])
        result_value_addr = self._value_addr(komut[1])
        # assuming type is 0 (int)
        operand1_value_addr = self._value_addr(komut[2])
        operand2_value_addr = self._value_addr(komut[3])

        islemler = {
            '+': 'add',
            '-': 'sub',
            '*': 'mul',
            '/': 'div',
        }
        islem = islemler[komut[0]]

        asm = [f'  sd zero, {result_type_addr}',
               f'  ld t0, {operand1_value_addr}',
               f'  ld t1, {operand2_value_addr}',
               f'  {islem} t0, t0, t1',
               f'  sd t0, {result_value_addr}']
        return '\n'.join(asm) + '\n'

    def _type_addr(self, place):
        return str(self.sp_extra_offset + self.relative_addr_table[place]) + '(sp)'

    def _value_addr(self, place):
        return str(self.sp_extra_offset + self.relative_addr_table[place] + 8) + '(sp)'


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
        places = self.ara_dil_yapici_visitor.program_symbol_table
        stack_size = len(places) * 16 + 8
        relative_addr_table = {place: addr for (place, addr) in zip(places, range(0, stack_size - 8, 16))}
        on_soz = [
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
            asm_yapici = AssemblyYapici(relative_addr_table)

            for komut in self.ara_dil_yapici_visitor.ara_dil_sozleri:
                asm_dosyasi.write('            # ' + cu.komut_stringi_yap(komut) + '\n')
                asm_dosyasi.write(asm_yapici.aradilden_asm(komut))
            for satir in son_soz:
                asm_dosyasi.write(f'{satir}\n')

        return self

    def ara_dildeki_floatlari_int_yap(self):
        for komut in self.ara_dil_yapici_visitor.ara_dil_sozleri:
            for i, arg in enumerate(komut):
                if type(arg) == float:
                    komut[i] = int(arg)
