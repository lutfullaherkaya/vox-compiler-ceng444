import sly
import bracket_lexer

class Parser(sly.Parser):
    tokens = bracket_lexer.Lexer.tokens

    def __init__(self):
        super().__init__()
        self._lexer = bracket_lexer.Lexer()
        self._il = []
        self._places = set()
        self._tmp_count = 0

    def translate_to_IL(self, source):
        self.parse(self._lexer.tokenize(source))
        return self._il, self._places

    def _generate_IL(self, il_instrs):
        self._il.extend(il_instrs)

    def _generate_tmp(self):
        tmp = f'tmp{self._tmp_count}'
        self._tmp_count += 1
        self._places.add(tmp)
        return tmp

    @_("program statement ';'")
    def program(self, p):
        pass

    @_('empty')
    def program(self, p):
        pass

    @_('print_stmt','assign_stmt')
    def statement(self, p):
        pass

    @_('PRINT expr')
    def print_stmt(self, p):
        self._generate_IL([('PARAM', p.expr['place']),
                           ('CALL', None, '__br_print__', 1)])

    @_("ID '=' expr")
    def assign_stmt(self, p):
        self._places.add(p[0])
        self._generate_IL([('COPY', p[0], p.expr['place'])])

    @_("expr '+' term")
    def expr(self, p):
        place = self._generate_tmp()
        self._generate_IL([('PARAM', p.term['place']),
                           ('PARAM', p.expr['place']),
                           ('CALL', place, '__br_add__', 2)])
        return {'place': place}

    @_('term')
    def expr(self, p):
        return p[0]

    @_('ID')
    def term(self, p):
        if p[0] not in self._places:
            print(f'Error, name {p[0]} is not defined')
            exit()
        return {'place': p[0]}

    @_('vector')
    def term(self, p):
        return p[0]

    @_('NUMBER')
    def term(self, p):
        return {'place': p[0]}

    @_("'[' arguments ']'")
    def vector(self, p):
        instrs = [('PARAM', expr['place']) for expr in p.arguments[::-1]]
        place = self._generate_tmp()
        instrs.append(('CALL', place, '__br_initvector__', len(p.arguments)))
        self._generate_IL(instrs)
        return {'place': place}

    @_("arguments ',' expr")
    def arguments(self, p):
        p.arguments.append(p.expr)
        return p.arguments

    @_("expr")
    def arguments(self, p):
        return [p.expr]

    @_('')
    def empty(self, p):
        pass