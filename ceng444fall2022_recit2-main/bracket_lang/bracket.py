#!/usr/bin/env python3
import sys
import argparse
import bracket_parser
import bracket_utils
import bracket_asmgen

arg_parser = argparse.ArgumentParser()
arg_parser.add_argument('source_file')
arg_parser.add_argument('--save_il', action='store_true')
args = arg_parser.parse_args()

with open(args.source_file) as f:
    il, places = bracket_parser.Parser().translate_to_IL(f.read())

if(args.save_il):
    il_filename = bracket_utils.strip_br_extension(args.source_file)+'.il'
    with open(il_filename, 'w') as f:
        f.write(f'places: {", ".join(places)}\n\nIL:\n')
        f.write('\n'.join([bracket_utils.il_instr_to_str(il_instr) for il_instr in il]))



stack_size = len(places)*16+8
relative_addr_table = {place:addr for (place, addr) in zip(places,range(0,stack_size-8,16))}

asm_filename = bracket_utils.strip_br_extension(args.source_file)+'.s'
asm_file = open(asm_filename, 'w')

asm_file.write('#include "lib_bracket.h"\n\n')

text_section_prologue = f'''  .global main
  .text
  .align 2
main:
  addi sp, sp, -{stack_size}
  sd ra, {stack_size-8}(sp)
'''

asm_file.write(text_section_prologue)

asm_generator = bracket_asmgen.AssemblyGenerator(relative_addr_table)
for il_instr in il:
    asm_file.write('            # '+bracket_utils.il_instr_to_str(il_instr)+'\n')
    asm_file.write(asm_generator.il_instr_to_asm(il_instr))

text_section_epilogue = f'''  ld ra, {stack_size-8}(sp)
  addi sp, sp, {stack_size}
  mv a0, zero
  ret
'''

asm_file.write(text_section_epilogue)
asm_file.close()



