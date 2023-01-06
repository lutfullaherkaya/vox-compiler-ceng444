#!/usr/bin/env python3

import argparse
import pickle
from misc import *
from lexer import Lexer
from compiler import Compiler, RiscVAssemblyYapici
import sys

arg_parser = argparse.ArgumentParser()

arg_parser.add_argument('test_type', choices=['scan', 'parse', 'analyze', 'compile'])
arg_parser.add_argument('filename', type=str)
arg_parser.add_argument('--save', action='store_true')

args = arg_parser.parse_args()

with open(args.filename,'r') as f:
    source = f.read()

if args.test_type == 'scan':
    toks = Lexer().tokenize(source)
    result = 'Tokens:\n'+'\n'.join([str(tok) for tok in toks])
    print(result)
    if args.save:
        with open(args.filename+'.toks', 'w') as f:
            f.write(result)

elif args.test_type == 'parse':
    intermediate = process(source)
    ast = generate_ast(intermediate)
    ast_str = PrintVisitor().visit(ast)
    print('PrintVisitor Output:')
    print(ast_str)
    if args.save:
        with open(args.filename+'.ast.pkl', 'wb') as f:
            pickle.dump(ast, f)
        with open(args.filename+'.ast', 'w') as f:
            f.write(ast_str)

elif args.test_type == 'compile':

    intermediate = process(source)
    has_errors = intermediate.has_errors
    ast = generate_ast(intermediate)
    print('PrintVisitor Output:')
    print(PrintVisitor().visit(ast))
    undecl_vars = undeclared_vars(intermediate)
    multiple_decls = multiple_var_declarations(intermediate)
    result = 'Undeclared vars:\n'
    result = result + '\n'.join([str(iden) for iden in undecl_vars])
    result = result + '\n' + 'Multiple var declarations:\n'
    result = result + '\n'.join([str(iden) for iden in multiple_decls])
    print(result)
    if len(undecl_vars) == 0 and len(multiple_decls) == 0 and not has_errors:
        compiler = Compiler(ast, RiscVAssemblyYapici)
        compiler.compile().save_ass(args.filename + '.s')
    else:
        sys.stderr.write('Compilation failed.\n')
        print('Compilation failed.')
    # todo: should we also assemble the code?


else:
    intermediate = process(source)
    ast = generate_ast(intermediate)
    print('PrintVisitor Output:')
    print(PrintVisitor().visit(ast))
    undecl_vars = undeclared_vars(intermediate)
    multiple_decls = multiple_var_declarations(intermediate)
    result = 'Undeclared vars:\n'
    result = result + '\n'.join([str(iden) for iden in undecl_vars])
    result = result + '\n'+'Multiple var declarations:\n'
    result = result + '\n'.join([str(iden) for iden in multiple_decls])
    print(result)
    if args.save:
        with open(args.filename+'.log', 'w') as f:
            f.write(result)
