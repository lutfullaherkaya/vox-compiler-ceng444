# https://github.com/bozsahin/ceng444
# todo: pypy kullan

# Press Ctrl+F5 to execute it or replace it with your code.
# Press Double Shift to search everywhere for classes, files, tool windows, actions, and settings.


import sly
import ast_tools


# Compute column.
#     input is the input text string
#     token is a token instance
def find_column(text, token):
    last_cr = text.rfind('\n', 0, token.index)
    if last_cr < 0:
        last_cr = 0
    column = (token.index - last_cr) + 1
    return column


# noinspection PyUnresolvedReferences,PyUnboundLocalVariable
class Lexer(sly.Lexer):
    # Do not modify the sets Lexer.literals and Lexer.tokens!
    tokens = {NUMBER, ID, WHILE, IF, ELSE, PRINT,
              PLUS, MINUS, TIMES, DIVIDE, ASSIGN,
              EQ, LT, LE, GT, GE, NE, AND,
              FALSE, TRUE, FUN, FOR, OR,
              RETURN, VAR, STRING, NOT}

    # LE := <=
    # EQ := ==
    # LT := <
    # GT := >
    # GE := >=
    # NE := !=

    # Do not modify the sets Lexer.literals and Lexer.tokens!
    literals = {'(', ')', '{', '}', '[', ']', ';', ',', '#'}

    # String containing ignored characters between tokens
    ignore = ' \t'
    ignore_comment = r'//.*'

    @_(r'\n+')
    def ignore_newline(self, t):
        self.lineno += t.value.count('\n')

    def error(self, t):
        char = t.value[0]
        print(f"sly: Lexer error at line {self.lineno}: Illegal character '{char}'")
        self.index += 1
        t.value = char
        return t

    ID = r'[a-zA-Z_][a-zA-Z0-9_]*'
    ID['if'] = IF
    ID['else'] = ELSE
    ID['while'] = WHILE
    ID['for'] = FOR
    ID['fun'] = FUN
    ID['return'] = RETURN
    ID['var'] = VAR
    ID['print'] = PRINT
    ID['and'] = AND
    ID['or'] = OR
    ID['true'] = TRUE
    ID['false'] = FALSE

    LE = r'<='
    EQ = r'=='
    GE = r'>='
    NE = r'!='
    LT = r'<'
    GT = r'>'

    PLUS = r'\+'
    MINUS = r'-'
    TIMES = r'\*'
    DIVIDE = r'/'
    ASSIGN = r'='
    NOT = r'!'

    def __init__(self):
        self.nesting_level = 0

    @_(r'\{')
    def lbrace(self, t):
        t.type = '{'  # Set token type to the expected literal
        self.nesting_level += 1
        return t

    @_(r'\}')
    def rbrace(self, t):
        t.type = '}'  # Set token type to the expected literal
        self.nesting_level -= 1
        return t

    @_(r'\d+\.\d+',
       r'\d+')
    def NUMBER(self, t):
        # each token t for NUMBER should have type(t.value) == float
        t.value = float(t.value)
        return t

    @_(r'\".*?\"')
    def STRING(self, t):
        # each token t for STRING should have type(t.value) == str (remove the quotes!)
        t.value = t.value[1:-1]
        return t

    @_(r'true')
    def TRUE(self, t):
        # each token t for TRUE/FALSE should have type(t.value) == bool
        t.value = True
        return t

    @_(r'false')
    def FALSE(self, t):
        # each token t for TRUE/FALSE should have type(t.value) == bool
        t.value = False
        return t
