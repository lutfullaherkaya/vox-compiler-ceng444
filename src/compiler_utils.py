import sys


def komut_stringi_yap(komut):
    sonuc = komut[0] + " "
    args = []
    for elem in komut[1:]:
        if elem is not None:
            if isinstance(elem, dict) and 'name' in elem:  # is a variable of NameIdPair
                var_name = elem['name']
                var_id = elem['id']
                if var_id == -1:
                    args.append('global_' + var_name)
                elif var_id == 0:
                    args.append(var_name)
                elif var_id > 0:
                    args.append(var_name + '-' + str(var_id))
            else:
                if type(elem) is str:
                    args.append(f'"{elem}"')
                else:
                    args.append(str(elem))

    return sonuc + ", ".join(args)


def compilation_error(error, lineno=None):
    if lineno is not None:
        sys.stderr.write('Compilation error at line ' + str(lineno) + ': ' + error + '\n')
    else:
        sys.stderr.write('Compilation error: ' + error + '\n')
    sys.stderr.write('Compilation failed.\n')
    sys.exit(1)


def compilation_warning(warning, lineno=None):
    if lineno is not None:
        sys.stderr.write('Compilation warning: at line ' + str(lineno) + ': ' + warning + '\n')
    else:
        sys.stderr.write('Compilation warning: ' + warning)


def runtime_error(error):
    sys.stderr.write('Runtime error: ' + error)
