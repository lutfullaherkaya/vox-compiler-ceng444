# https://github.com/bozsahin/ceng444
# todo: pypy kullan

# Press Ctrl+F5 to execute it or replace it with your code.
# Press Double Shift to search everywhere for classes, files, tool windows, actions, and settings.


from sly import Lexer


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
class VoxLexer(Lexer):
    # Set of token names.   This is always required
    tokens = {
        ID, NUMBER, STRING,
        IF, ELSE,
        WHILE, FOR,
        FUN, RETURN,
        VAR,
        PRINT,
        AND, OR,
        TRUE, FALSE,
        EQUAL, NOT_EQUAL, LE, GE,
    }

    literals = {'(', ')', '{', '}', '[', ']', '#', '=', ';', '<', '>', '!', '+', '-', '*', '/', ','}

    # String containing ignored characters between tokens
    ignore = ' \t'
    ignore_comment = r'//.*'

    @_(r'\n+')
    def ignore_newline(self, t):
        self.lineno += t.value.count('\n')

    def error(self, t):
        print('Line %d: Bad character %r' % (self.lineno, t.value[0]))
        self.index += 1

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

    NUMBER = r'\d+\.\d+|\d+'
    STRING = r'\".*?\"'
    EQUAL = r'=='
    NOT_EQUAL = r'!='
    LE = r'<='
    GE = r'>='

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
