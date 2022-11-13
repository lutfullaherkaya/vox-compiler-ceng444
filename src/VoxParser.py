# https://github.com/bozsahin/ceng444
# todo: pypy kullan
# Press Ctrl+F5 to execute it or replace it with your code.
# Press Double Shift to search everywhere for classes, files, tool windows, actions, and settings.


from sly import Parser
from VoxLexer import VoxLexer
import sys
import AST


# todo: error reporting
# noinspection PyUnresolvedReferences,PyUnboundLocalVariable
class VoxParser(Parser):
    tokens = VoxLexer.tokens
    debugfile = 'parser.out'
    start = 'program'

    # todo: EOF olması lazım sonda ama EOF'la ne yapılır bilemedim.
    @_('var_decls fun_decls free_statements')
    def program(self, p):
        pass

    @_('VAR ID "=" init ";"')
    def var_decl(self, p):
        return AST.VarDecl(p, p.ID, p.init)

    @_('VAR ID ";"')
    def var_decl(self, p):
        return AST.VarDecl(p, p.ID)

    @_('var_decls var_decl')
    def var_decls(self, p):
        if not p[0].decls:
            p[0].lineno = p.lineno
            p[0].index = p.index
            p[0].end = p.end

        p[0].append(p[1])
        return p[0]

    @_('')
    def var_decls(self, p):
        return AST.VarDecls([])

    @_('FUN function')
    def fun_decl(self, p):
        pass

    @_('fun_decl fun_decls')
    def fun_decls(self, p):
        pass

    @_('')
    def fun_decls(self, p):
        pass

    @_('simple_stmt ";"')
    def free_statement(self, p):
        pass

    @_('compound_stmt')
    def free_statement(self, p):
        pass

    @_('free_statement free_statements')
    def free_statements(self, p):
        pass

    @_('')
    def free_statements(self, p):
        pass

    @_('expr')
    def init(self, p):
        pass

    @_('"[" exprs_non_empty_w_commas "]"')
    def init(self, p):
        pass

    @_('asgn_stmt')
    def simple_stmt(self, p):
        pass

    @_('print_stmt')
    def simple_stmt(self, p):
        pass

    @_('return_stmt')
    def simple_stmt(self, p):
        pass

    @_('if_stmt')
    def compound_stmt(self, p):
        pass

    @_('while_stmt')
    def compound_stmt(self, p):
        pass

    @_('for_stmt')
    def compound_stmt(self, p):
        pass

    @_('free_statement')
    def statement(self, p):
        return AST.Statement(p, p[0])

    @_('block')
    def statement(self, p):
        return AST.Statement(p, p[0])

    @_('statement statements')
    def statements(self, p):
        pass

    @_('')
    def statements(self, p):
        pass

    @_('ID "[" aexpr "]" "=" expr')
    def asgn_stmt(self, p):
        pass

    @_('ID "=" expr')
    def asgn_stmt(self, p):
        pass

    @_('PRINT expr')
    def print_stmt(self, p):
        pass

    @_('RETURN expr')
    def return_stmt(self, p):
        pass

    @_('IF lexpr statement ELSE statement')
    def if_stmt(self, p):
        pass

    @_('IF lexpr statement')
    def if_stmt(self, p):
        pass

    @_('WHILE lexpr statement')
    def while_stmt(self, p):
        pass

    @_('FOR "(" asgn_stmt ";" lexpr ";" asgn_stmt ")" statement')
    def for_stmt(self, p):
        pass

    @_('FOR "(" asgn_stmt ";" lexpr ";" ")" statement')
    def for_stmt(self, p):
        pass

    @_('FOR "(" asgn_stmt ";" ";" asgn_stmt ")" statement')
    def for_stmt(self, p):
        pass

    @_('FOR "(" asgn_stmt ";" ";" ")" statement')
    def for_stmt(self, p):
        pass

    @_('FOR "(" ";" lexpr ";" asgn_stmt ")" statement')
    def for_stmt(self, p):
        pass

    @_('FOR "(" ";" lexpr ";" ")" statement')
    def for_stmt(self, p):
        pass

    @_('FOR "(" ";" ";" asgn_stmt ")" statement')
    def for_stmt(self, p):
        pass

    @_('FOR "(" ";" ";" ")" statement')
    def for_stmt(self, p):
        pass

    @_('"{" var_decls statements "}"')
    def block(self, p):
        return AST.Block(p, p.var_decls, p.statements)

    @_('lexpr')
    def expr(self, p):
        pass

    @_('aexpr')
    def expr(self, p):
        pass

    @_('sexpr')
    def expr(self, p):
        pass

    @_('expr "," exprs_non_empty_w_commas')
    def exprs_non_empty_w_commas(self, p):
        pass

    @_('expr')
    def exprs_non_empty_w_commas(self, p):
        pass

    @_('lexpr OR lterm')
    def lexpr(self, p):
        pass

    @_('lterm')
    def lexpr(self, p):
        pass

    @_('lterm AND lfact')
    def lterm(self, p):
        pass

    @_('lfact')
    def lterm(self, p):
        pass

    @_('cexpr')
    def lfact(self, p):
        pass

    @_('"#" call')
    def lfact(self, p):
        pass

    @_('"(" lexpr ")"')
    def lfact(self, p):
        pass

    @_('"#" ID')
    def lfact(self, p):
        pass

    @_('"#" ID "[" aexpr "]"')
    def lfact(self, p):
        pass

    @_('"!" lfact')
    def lfact(self, p):
        pass

    @_('TRUE')
    def lfact(self, p):
        pass

    @_('FALSE')
    def lfact(self, p):
        pass

    @_('aexpr "-" term')
    def aexpr(self, p):
        pass

    @_('aexpr "+" term')
    def aexpr(self, p):
        pass

    @_('term')
    def aexpr(self, p):
        pass

    @_('term "/" fact')
    def term(self, p):
        pass

    @_('term "*" fact')
    def term(self, p):
        pass

    @_('fact')
    def term(self, p):
        pass

    @_('"-" fact')
    def fact(self, p):
        pass

    @_('call')
    def fact(self, p):
        pass

    @_('NUMBER')
    def fact(self, p):
        pass

    @_('"(" aexpr ")"')
    def fact(self, p):
        pass

    @_('ID "[" aexpr "]"')
    def fact(self, p):
        pass

    @_('ID')
    def fact(self, p):
        pass

    @_('aexpr NOT_EQUAL aexpr')
    def cexpr(self, p):
        pass

    @_('aexpr EQUAL aexpr')
    def cexpr(self, p):
        pass

    @_('aexpr LE aexpr')
    def cexpr(self, p):
        pass

    @_('aexpr GE aexpr')
    def cexpr(self, p):
        pass

    @_('aexpr "<" aexpr')
    def cexpr(self, p):
        pass

    @_('aexpr ">" aexpr')
    def cexpr(self, p):
        pass

    @_('STRING')
    def sexpr(self, p):
        pass

    @_('exprs_non_empty_w_commas')
    def arguments(self, p):
        pass

    @_('ID "(" parameters ")" block')
    def function(self, p):
        return 'function', p[0], p[2], p[4]

    @_('ID "(" ")" block')
    def function(self, p):
        return 'function', p[0], '', p[3]

    @_('ids_non_empty_w_commas')
    def parameters(self, p):
        pass

    @_('ID "," ids_non_empty_w_commas')
    def ids_non_empty_w_commas(self, p):
        pass

    @_('ID')
    def ids_non_empty_w_commas(self, p):
        pass

    @_('ID "(" arguments ")"')
    def call(self, p):
        pass

    @_('ID "(" ")"')
    def call(self, p):
        pass
