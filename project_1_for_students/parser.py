import sly
from src import lexer


class Parser(sly.Parser):
    tokens = lexer.Lexer.tokens
