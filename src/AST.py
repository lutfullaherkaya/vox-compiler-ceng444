import sys
from typing import List, Union
import abc


def elements_unique(elements):
    return len(elements) == len(set(elements))


def get_location_str(line, column=None):
    string = f'line {line}'
    if column is not None:
        string += f', column {column}'
    return string


class ASTNode(metaclass=abc.ABCMeta):
    end = None
    index = None
    lineno = -1

    def __init__(self, p=None):
        if p is not None:
            self.end = p.end
            self.index = p.index
            self.lineno = p.lineno

    def error(self, msg, line=None, column=None):
        if line is None:
            line = self.lineno
        sys.stderr.write(f"Error at {get_location_str(line, column)}: {msg}\n")


class FreeStatement(ASTNode):
    def __init__(self, p, stmt):
        super().__init__(p)
        self.stmt = stmt


class Statement(ASTNode):
    def __init__(self, p, stmt: Union["FreeStatement", "Block"]):
        super().__init__(p)
        self.stmt = stmt


class VarDecls(ASTNode):
    def __init__(self, decls: List["VarDecl"]):
        super().__init__(None)
        self.decls = decls
        self.declSet = {}
        for var_decl in self.decls:
            self.error_if_duplicate_else_add_to_set(var_decl)

    def append(self, var_decl: "VarDecl"):
        self.decls.append(var_decl)
        self.error_if_duplicate_else_add_to_set(var_decl)

    def error_if_duplicate_else_add_to_set(self, var_decl):
        if var_decl.id in self.declSet:
            var_decl.error(f'Variable "{var_decl.id}" already declared in scope at'
                           f' {get_location_str(self.declSet[var_decl.id].lineno)}.')
        else:
            self.declSet[var_decl.id] = var_decl


class VarDecl(ASTNode):
    def __init__(self, p, id_, init=None):
        super().__init__(p)
        self.id = id_
        self.init = init


class Block(ASTNode):
    def __init__(self, p, var_decls: VarDecls = None,
                 statements: List[Statement] = None):
        super().__init__(p)
        if var_decls is None:
            var_decls = []
        else:
            self.var_decls = var_decls

        if statements is None:
            statements = []
        else:
            self.statements = statements
