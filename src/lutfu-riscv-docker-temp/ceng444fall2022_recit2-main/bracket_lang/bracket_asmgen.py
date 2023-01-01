
from bracket_utils import il_instr_to_str


class AssemblyGenerator:
    def __init__(self, relative_addr_table):
        self.relative_addr_table = relative_addr_table
        self.sp_extra_offset = 0
    
    def il_instr_to_asm(self, il_instr):
        if il_instr[0] == 'CALL':
            return self.CALL_to_asm(il_instr)
        if il_instr[0] == 'PARAM':
            return self.PARAM_to_asm(il_instr)
        if il_instr[0] == 'COPY':
            return self.COPY_to_asm(il_instr)
        else:
            return f'ERROR! Unknown IL {il_instr}'

    def PARAM_to_asm(self, il_instr):
        self.sp_extra_offset += 16
        asm = ['  addi sp, sp, -16']

        if type(il_instr[1]) == int:
            asm.extend(['  sd zero, (sp)',
                       f'  li t0, {il_instr[1]}',
                       f'  sd t0, 8(sp)'])
        else:
            type_addr = self._type_addr(il_instr[1])
            value_addr = self._value_addr(il_instr[1])
            asm.extend([f'  ld t0, {type_addr}',
                         '  sd t0, (sp)',
                        f'  ld t0, {value_addr}',
                        f'  sd t0, 8(sp)'])
        
        return '\n'.join(asm)+'\n'


    def CALL_to_asm(self, il_instr):
        asm = ['  mv a1, sp',
              f'  li a0, {il_instr[3]}',
              f'  call {il_instr[2]}',
              f'  addi sp, sp, {16*il_instr[3]}']
        
        self.sp_extra_offset -= 16*il_instr[3]
        
        if il_instr[1] is not None:
            type_addr = self._type_addr(il_instr[1])
            value_addr = self._value_addr(il_instr[1])
            asm.extend([f'  sd a0, {type_addr}',
                        f'  sd a1, {value_addr}'])
        
        return '\n'.join(asm)+'\n'

    def COPY_to_asm(self, il_instr):
        type_addr = self._type_addr(il_instr[1])
        value_addr = self._value_addr(il_instr[1])   

        if type(il_instr[2]) == int:
            asm = [f'  sd zero, {type_addr}',
                   f'  li t0, {il_instr[2]}',
                   f'  sd t0, {value_addr}']
        else:
            type_addr_from = self._type_addr(il_instr[2])
            value_addr_from = self._value_addr(il_instr[2])
            asm = [f'  ld t0, {type_addr_from}',
                   f'  sd t0, {type_addr}',
                   f'  ld t0, {value_addr_from}',
                   f'  sd t0, {value_addr}']
        
        return '\n'.join(asm)+'\n'

    def _type_addr(self, place):
        return str(self.sp_extra_offset+self.relative_addr_table[place])+'(sp)'

    def _value_addr(self, place):
        return str(self.sp_extra_offset+self.relative_addr_table[place]+8)+'(sp)'



