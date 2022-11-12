# https://github.com/bozsahin/ceng444
# todo: pypy kullan
import sys
from VoxLexer import VoxLexer

if __name__ == '__main__':
    lexer = VoxLexer()
    if len(sys.argv) > 1:
        filename = sys.argv[1]
        with open(filename) as f:
            text = f.read()
            for tok in lexer.tokenize(text):
                print('%r\t\t%r' % (tok.value, tok.type))
    else:
        while True:
            try:
                text = input('> ')  # ornek: x = 3 + 42 * (s - t)
            except EOFError:
                break
            if text:
                for tok in lexer.tokenize(text):
                    print('%r\t\t%r' % (tok.value, tok.type))
