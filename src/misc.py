from ast_tools import *
from typing import List

from lexer import Lexer
from my_parser import Parser


def process(source):
    '''parse the source text here. you may return the AST specified in ast_tools.py or something else.'''
    lexer = Lexer()
    parser = Parser()
    result = parser.parse(lexer.tokenize(source))
    return result


def generate_ast(intermediate) -> Program:
    '''return the AST using the output of process() here.'''
    return intermediate


def undeclared_vars(intermediate) -> List[Identifier]:
    '''return all of the undeclared uses of the variables in the order they appear in the source code here,
     using the return value of process()'''
    return []


def multiple_var_declarations(intermediate) -> List[Identifier]:
    '''return all of the subsequent declarations of a
    previously declared variable if the re-declaration cannot be explained by shadowing,
    in the order they appear in the source code, using the return value of process()'''
    return MultiVarDeclVisitor().visit(intermediate)
