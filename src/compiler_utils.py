# thanks to bracket_utils of cem hoca (il_instr_to_str)
def komut_stringi_yap(komut):
    return komut[0] + " " + ", ".join([str(elem) for elem in komut[1:] if elem is not None])
