def komut_stringi_yap(komut):
    sonuc = komut[0] + " "
    args = []
    for elem in komut[1:]:
        if elem is not None:
            if isinstance(elem, dict) and 'name' in elem:  # is a variable of NameIdPair
                var_name = elem['name']
                id = elem['id']
                if id == -1:
                    args.append('global_' + var_name)
                elif id == 0:
                    args.append(var_name)
                elif id > 0:
                    args.append(var_name + '-' + str(id))
            else:
                args.append(str(elem))

    return sonuc + ", ".join(args)
