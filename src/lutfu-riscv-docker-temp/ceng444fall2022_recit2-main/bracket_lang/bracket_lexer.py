import sly

class Lexer(sly.Lexer):
    tokens = {ID, NUMBER, PRINT}

    literals = {'[', '+', ']', ';', ',', '='}

    ignore = ' \t\r\f\v'

    ignore_comment = r'//.*'

    ID = r'[a-zA-Z_][a-zA-Z0-9_]*'
    ID['print'] = PRINT

    @_(r'-?\d+')
    def NUMBER(self, t):
        t.value = int(t.value)
        return t

    @_(r'\n+')
    def ignore_newline(self, t):
        self.lineno += t.value.count('\n')

    def error(self, t):
        print('Line %d: Bad character %r' % (self.lineno, t.value[0]))
        self.index += 1
        t.value = t.value[0]
        return t
