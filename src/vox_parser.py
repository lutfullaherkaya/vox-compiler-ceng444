# https://github.com/bozsahin/ceng444
# todo: pypy kullan
# Press Ctrl+F5 to execute it or replace it with your code.
# Press Double Shift to search everywhere for classes, files, tool windows, actions, and settings.


import sly
import lexer
import sys
import ast_tools


# todo: error reporting
# noinspection PyUnresolvedReferences,PyUnboundLocalVariable
class Parser(sly.Parser):
    tokens = lexer.Lexer.tokens
    # debugfile = 'parser.out'
    start = 'program'

    # todo: EOF olması lazım sonda ama EOF'la ne yapılır bilemedim.
    @_('var_decls fun_decls free_statements')
    def program(self, p):
        has_errors = False
        if hasattr(self, 'errorok'):
            has_errors = True

        return ast_tools.Program(p.var_decls, p.fun_decls, p.free_statements, has_errors)

    @_('VAR ID ASSIGN init ";"')
    def var_decl(self, p):
        return ast_tools.VarDecl(ast_tools.Identifier(p.ID, p.lineno, p.index), p.init)

    @_('VAR ID ";"')
    def var_decl(self, p):
        return ast_tools.VarDecl(ast_tools.Identifier(p.ID, p.lineno, p.index), None)

    @_('var_decls var_decl')
    def var_decls(self, p):
        p[0].append(p[1])
        return p[0]

    @_('')
    def var_decls(self, p):
        return []

    @_('FUN function')
    def fun_decl(self, p):
        return p.function

    @_('fun_decls fun_decl')
    def fun_decls(self, p):
        p[0].append(p[1])
        return p[0]

    @_('')
    def fun_decls(self, p):
        return []

    @_('simple_stmt ";"')
    def free_statement(self, p):
        return p.simple_stmt

    @_('error ";"')
    def free_statement(self, p):
        return ast_tools.ErrorStmt()

    @_('error "}"')
    def free_statement(self, p):
        return ast_tools.ErrorStmt()

    @_('compound_stmt')
    def free_statement(self, p):
        return p.compound_stmt

    @_('free_statements free_statement')
    def free_statements(self, p):
        p[0].append(p[1])
        return p[0]

    @_('')
    def free_statements(self, p):
        return []

    @_('expr')
    def init(self, p):
        return p.expr

    @_('"[" exprs_non_empty_w_commas "]"')
    def init(self, p):
        return p.exprs_non_empty_w_commas

    @_('asgn_stmt')
    def simple_stmt(self, p):
        return p.asgn_stmt

    @_('print_stmt')
    def simple_stmt(self, p):
        return p.print_stmt

    @_('return_stmt')
    def simple_stmt(self, p):
        return p.return_stmt

    @_('if_stmt')
    def compound_stmt(self, p):
        return p.if_stmt

    @_('while_stmt')
    def compound_stmt(self, p):
        return p.while_stmt

    @_('for_stmt')
    def compound_stmt(self, p):
        return p.for_stmt

    @_('free_statement')
    def statement(self, p):
        return p.free_statement

    @_('block')
    def statement(self, p):
        return p.block

    @_('statements statement')
    def statements(self, p):
        p[0].append(p[1])
        return p[0]

    @_('')
    def statements(self, p):
        return []

    @_('ID "[" aexpr "]" ASSIGN expr')
    def asgn_stmt(self, p):
        return ast_tools.SetVector(ast_tools.Identifier(p.ID, p.lineno, p.index), p.aexpr, p.expr)

    @_('ID ASSIGN expr')
    def asgn_stmt(self, p):
        return ast_tools.Assign(ast_tools.Identifier(p.ID, p.lineno, p.index), p.expr)

    @_('PRINT expr')
    def print_stmt(self, p):
        return ast_tools.Print(p.expr)

    @_('RETURN expr')
    def return_stmt(self, p):
        return ast_tools.Return(p.expr)

    @_('IF lexpr statement ELSE statement')
    def if_stmt(self, p):
        return ast_tools.IfElse(p.lexpr, p.statement0, p.statement1)

    @_('IF lexpr statement')
    def if_stmt(self, p):
        return ast_tools.IfElse(p.lexpr, p.statement, None)

    @_('WHILE lexpr statement')
    def while_stmt(self, p):
        return ast_tools.WhileLoop(p.lexpr, p.statement)

    @_('FOR "(" [ asgn_stmt ] ";" [ lexpr ] ";" [ asgn_stmt ] ")" statement')
    def for_stmt(self, p):
        return ast_tools.ForLoop(p.asgn_stmt0, p.lexpr, p.asgn_stmt1, p.statement)

    @_('"{" var_decls statements "}"')
    def block(self, p):
        return ast_tools.Block(p.var_decls, p.statements)

    @_('lexpr')
    def expr(self, p):
        return p.lexpr

    @_('aexpr')
    def expr(self, p):
        return p.aexpr

    @_('sexpr')
    def expr(self, p):
        return p.sexpr

    @_('exprs_non_empty_w_commas "," expr')
    def exprs_non_empty_w_commas(self, p):
        p[0].append(p.expr)
        return p[0]

    @_('expr')
    def exprs_non_empty_w_commas(self, p):
        return [p.expr]

    @_('lexpr OR lterm')
    def lexpr(self, p):
        return ast_tools.LBinary('or', p.lexpr, p.lterm)

    @_('lterm')
    def lexpr(self, p):
        return p.lterm

    @_('lterm AND lfact')
    def lterm(self, p):
        return ast_tools.LBinary('and', p.lterm, p.lfact)

    @_('lfact')
    def lterm(self, p):
        return p.lfact

    @_('cexpr')
    def lfact(self, p):
        return p.cexpr

    @_('"#" call')
    def lfact(self, p):
        return ast_tools.LPrimary(p.call)

    @_('"(" lexpr ")"')
    def lfact(self, p):
        return p.lexpr

    @_('"#" ID')
    def lfact(self, p):
        return ast_tools.LPrimary(ast_tools.Variable(ast_tools.Identifier(p.ID, p.lineno, p.index)))

    @_('"#" ID "[" aexpr "]"')
    def lfact(self, p):
        return ast_tools.LPrimary(ast_tools.GetVector(ast_tools.Identifier(p.ID, p.lineno, p.index), p.aexpr))

    @_('NOT lfact')
    def lfact(self, p):
        return ast_tools.LNot(p.lfact)

    @_('TRUE')
    def lfact(self, p):
        return ast_tools.LLiteral(p[0])

    @_('FALSE')
    def lfact(self, p):
        return ast_tools.LLiteral(p[0])

    @_('aexpr MINUS term')
    def aexpr(self, p):
        return ast_tools.ABinary('-', p.aexpr, p.term)

    @_('aexpr PLUS term')
    def aexpr(self, p):
        return ast_tools.ABinary('+', p.aexpr, p.term)

    @_('term')
    def aexpr(self, p):
        return p.term

    @_('term DIVIDE fact')
    def term(self, p):
        return ast_tools.ABinary('/', p.term, p.fact)

    @_('term TIMES fact')
    def term(self, p):
        return ast_tools.ABinary('*', p.term, p.fact)

    @_('fact')
    def term(self, p):
        return p.fact

    @_('MINUS fact')
    def fact(self, p):
        return ast_tools.AUMinus(p.fact)

    @_('call')
    def fact(self, p):
        return p.call

    @_('NUMBER')
    def fact(self, p):
        return ast_tools.ALiteral(p[0])

    @_('"(" aexpr ")"')
    def fact(self, p):
        return p.aexpr

    @_('ID "[" aexpr "]"')
    def fact(self, p):
        return ast_tools.GetVector(ast_tools.Identifier(p.ID, p.lineno, p.index), p.aexpr)

    @_('ID')
    def fact(self, p):
        return ast_tools.Variable(ast_tools.Identifier(p.ID, p.lineno, p.index))

    @_('aexpr NE aexpr')
    def cexpr(self, p):
        return ast_tools.Comparison('!=', p.aexpr0, p.aexpr1)

    @_('aexpr EQ aexpr')
    def cexpr(self, p):
        return ast_tools.Comparison('==', p.aexpr0, p.aexpr1)

    @_('aexpr LE aexpr')
    def cexpr(self, p):
        return ast_tools.Comparison('<=', p.aexpr0, p.aexpr1)

    @_('aexpr GE aexpr')
    def cexpr(self, p):
        return ast_tools.Comparison('>=', p.aexpr0, p.aexpr1)

    @_('aexpr LT aexpr')
    def cexpr(self, p):
        return ast_tools.Comparison('<', p.aexpr0, p.aexpr1)

    @_('aexpr GT aexpr')
    def cexpr(self, p):
        return ast_tools.Comparison('>', p.aexpr0, p.aexpr1)

    @_('STRING')
    def sexpr(self, p):
        return ast_tools.SLiteral(p.STRING)

    @_('exprs_non_empty_w_commas')
    def arguments(self, p):
        return p.exprs_non_empty_w_commas

    @_('ID "(" parameters ")" block')
    def function(self, p):
        return ast_tools.FunDecl(ast_tools.Identifier(p.ID, p.lineno, p.index), p.parameters, p.block)

    @_('ID "(" ")" block')
    def function(self, p):
        return ast_tools.FunDecl(ast_tools.Identifier(p.ID, p.lineno, p.index), [], p.block)

    @_('ids_non_empty_w_commas')
    def parameters(self, p):
        return p.ids_non_empty_w_commas

    @_('ID "," ids_non_empty_w_commas')
    def ids_non_empty_w_commas(self, p):
        # right recursion is neccesary for getting the index of identifiers
        # but right recursion is inefficient since it creates a new array for each identifier
        return [ast_tools.Identifier(p.ID, p.lineno, p.index)] + p.ids_non_empty_w_commas

    @_('ID')
    def ids_non_empty_w_commas(self, p):
        return [ast_tools.Identifier(p.ID, p.lineno, p.index)]

    @_('ID "(" arguments ")"')
    def call(self, p):
        return ast_tools.Call(ast_tools.Identifier(p.ID, p.lineno, p.index), p.arguments)

    @_('ID "(" ")"')
    def call(self, p):
        return ast_tools.Call(ast_tools.Identifier(p.ID, p.lineno, p.index), [])

    '''def error(self, token):
        if token:
            lineno = getattr(token, 'lineno', 0)
            if lineno:
                sys.stderr.write(f'sly: Syntax error at line {lineno}, token={token.type}\n')
            else:
                sys.stderr.write(f'sly: Syntax error, token={token.type}')
        else:
            sys.stderr.write('sly: Parse error in input. EOF\n')
            return None

        # Read ahead looking for a closing '}'
        while True:
            tok = next(self.tokens, None)
            if tok.type == '}' or tok.type == ';':
                break
            if not tok:
                print("End of File!")
                return None
        self.restart()'''
