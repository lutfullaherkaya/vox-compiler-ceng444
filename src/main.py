# https://github.com/bozsahin/ceng444
import sys
import misc


if __name__ == '__main__':

    if len(sys.argv) > 1:
        filename = sys.argv[1]
        with open(filename) as f:
            text = f.read()

            intermediate = misc.process(text)
            ast = misc.generate_ast(intermediate)
            ast_str = misc.PrintVisitor().visit(ast)
            print('PrintVisitor Output:')
            print(ast_str)



    else:
        while True:
            try:
                text = input('> ')  # ornek: x = 3 + 42 * (s - t)
            except EOFError:
                break
            if text:
                print(misc.generate_ast(misc.process(text)))

