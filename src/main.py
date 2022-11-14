# https://github.com/bozsahin/ceng444
# todo: pypy kullan
import sys
from lexer import Lexer
from VoxParser import VoxParser

if __name__ == '__main__':
    lexer = Lexer()
    parser = VoxParser()
    if len(sys.argv) > 1:
        filename = sys.argv[1]
        with open(filename) as f:
            text = f.read()
            print(list(map(lambda x: (str(x.type) + ('' if (x.value == x.type) else ' ' + str(x.value))),
                           lexer.tokenize(text))))
            result = parser.parse(lexer.tokenize(text))
            print(result)
    else:
        while True:
            try:
                text = input('> ')  # ornek: x = 3 + 42 * (s - t)
            except EOFError:
                break
            if text:
                print(list(map(lambda x: (str(x.type) + ('' if (x.value == x.type) else ' ' + str(x.value))),
                               lexer.tokenize(text))))

                result = parser.parse(lexer.tokenize(text))
                print(result)
