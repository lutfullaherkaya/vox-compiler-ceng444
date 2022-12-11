from ast_tools import *
from typing import List

from lexer import Lexer
from vox_parser import Parser
from dataclasses import dataclass
from typing import Dict, Optional, Union
import sys


def semantic_error(msg, line=None, column=None):
    sys.stderr.write(f"Semantic error at {get_location_str(line, column)}: {msg}\n")


def get_location_str(line, column=None):
    string = f'line {line}'
    if column is not None:
        string += f', column {column}'
    return string


def process(source):
    '''parse the source text here. you may return the AST specified in ast_tools.py or something else.'''
    lexer = Lexer()
    parser = Parser()
    result = parser.parse(lexer.tokenize(source))
    return result


def generate_ast(intermediate) -> Program:
    '''return the AST using the output of process() here.'''
    return intermediate


def undeclared_vars(intermediate) -> List[Identifier]:
    '''return all of the undeclared uses of the variables in the order they appear in the source code here,
     using the return value of process()'''
    return UnDeclVarVisitor().visit(intermediate)


def multiple_var_declarations(intermediate) -> List[Identifier]:
    '''return all of the subsequent declarations of a
    previously declared variable if the re-declaration cannot be explained by shadowing,
    in the order they appear in the source code, using the return value of process()'''
    return MultiVarDeclVisitor().visit(intermediate)


class Scope:
    def __init__(self, parent: Optional['Scope'] = None, symbols: Optional[List[Identifier]] = None):
        self.parent: Optional['Scope'] = parent
        # last symbol is the one in the current scope
        self.symbol_table: Dict[str, "Symbol"] = {}
        if symbols is not None:
            for symbol in symbols:
                self.add(symbol)

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.drop_symbol_table()

    def add(self, identifier: Identifier):
        if identifier.name not in self.symbol_table:
            self.symbol_table[identifier.name] = Symbol(identifier)

    def remove(self, identifier: Identifier):
        if identifier.name in self.symbol_table:
            del self.symbol_table[identifier.name]

    def get(self, identifier: Identifier) -> Optional["Symbol"]:
        if identifier.name in self.symbol_table:
            return self.symbol_table[identifier.name]
        elif self.parent is not None:
            return self.parent.get(identifier)
        else:
            return None

    def get_error_if_not_declared(self, identifier: Identifier) -> Optional["Symbol"]:
        symbol = self.get(identifier)
        if symbol is None:
            semantic_error(f"Identifier '{identifier.name}' referenced without being declared.",
                           identifier.lineno)

        return symbol

    def drop_symbol_table(self):
        self.symbol_table = {}


@dataclass
class Symbol:
    id: Identifier


class UnDeclVarVisitor(ASTNodeVisitor):
    def __init__(self):
        super().__init__()
        self.current_scope: Optional[Scope] = None
        self.global_fun_decls = {}

    def visit_SLiteral(self, sliteral: SLiteral):
        return []

    def visit_Program(self, program: Program):
        un_declared_vars = []
        for fundecl in program.fun_decls:
            self.global_fun_decls[fundecl.identifier.name] = fundecl
        with Scope() as scope:
            self.current_scope = scope
            for var_decl in program.var_decls:
                un_declared_vars += self.visit(var_decl)
            for fun_decl in program.fun_decls:
                un_declared_vars += self.visit(fun_decl)
            for stmt in program.statements:
                un_declared_vars += self.visit(stmt)
            self.current_scope = scope.parent
        return un_declared_vars

    def visit_ErrorStmt(self, errorstmt: ErrorStmt):
        return []

    def visit_VarDecl(self, vardecl: VarDecl):
        un_declared_vars = []

        if vardecl.initializer is not None:
            if type(vardecl.initializer) == list:
                for elem in vardecl.initializer:
                    un_declared_vars += self.visit(elem)
            else:
                un_declared_vars += self.visit(vardecl.initializer)
        self.current_scope.add(vardecl.identifier)

        return un_declared_vars

    def visit_FunDecl(self, fundecl: FunDecl):
        un_declared_vars = []
        # todo: func parameters and func body should not be in different scopes, right now they are
        with Scope(self.current_scope, fundecl.params) as func_scope:
            self.current_scope = func_scope
            un_declared_vars += self.visit(fundecl.body)
            self.current_scope = func_scope.parent

        return un_declared_vars

    def visit_Assign(self, assign: Assign):
        un_declared_vars = []
        if self.current_scope.get_error_if_not_declared(assign.identifier) is None:
            un_declared_vars.append(assign.identifier)
        un_declared_vars += self.visit(assign.expr)
        return un_declared_vars

    def visit_SetVector(self, setvector: SetVector):
        un_declared_vars = []
        if self.current_scope.get_error_if_not_declared(setvector.identifier) is None:
            un_declared_vars.append(setvector.identifier)
        un_declared_vars += self.visit(setvector.vector_index)
        un_declared_vars += self.visit(setvector.expr)
        return un_declared_vars

    def visit_ForLoop(self, forloop: ForLoop):
        un_declared_vars = []

        if forloop.initializer is not None:
            un_declared_vars += self.visit(forloop.initializer)
        if forloop.condition is not None:
            un_declared_vars += self.visit(forloop.condition)
        if forloop.increment is not None:
            un_declared_vars += self.visit(forloop.increment)

        un_declared_vars += self.visit(forloop.body)

        return un_declared_vars

    def visit_Return(self, returnn: Return):
        return self.visit(returnn.expr)

    def visit_WhileLoop(self, whileloop: WhileLoop):
        return self.visit(whileloop.condition) + self.visit(whileloop.body)

    def visit_Block(self, block: Block):
        un_declared_vars = []
        with Scope(self.current_scope) as block_scope:
            self.current_scope = block_scope
            for var_decl in block.var_decls:
                un_declared_vars += self.visit(var_decl)
            for stmt in block.statements:
                un_declared_vars += self.visit(stmt)
            self.current_scope = block_scope.parent
        return un_declared_vars

    def visit_Print(self, printt: Print):
        return self.visit(printt.expr)

    def visit_IfElse(self, ifelse: IfElse):
        un_declared_vars = []
        un_declared_vars += self.visit(ifelse.condition)
        un_declared_vars += self.visit(ifelse.if_branch)
        if ifelse.else_branch is not None:
            un_declared_vars += self.visit(ifelse.else_branch)
        return un_declared_vars

    def visit_LBinary(self, lbinary: LBinary):
        return self.visit(lbinary.left) + self.visit(lbinary.right)

    def visit_Comparison(self, comparison: Comparison):
        return self.visit(comparison.left) + self.visit(comparison.right)

    def visit_LLiteral(self, lliteral: LLiteral):
        return []

    def visit_LPrimary(self, lprimary: LPrimary):
        return self.visit(lprimary.primary)

    def visit_GetVector(self, getvector: GetVector):
        un_declared_vars = []
        if self.current_scope.get_error_if_not_declared(getvector.identifier) is None:
            un_declared_vars.append(getvector.identifier)
        un_declared_vars += self.visit(getvector.vector_index)
        return un_declared_vars

    def visit_Variable(self, variable: Variable):
        un_declared_vars = []
        if self.current_scope.get_error_if_not_declared(variable.identifier) is None:
            un_declared_vars.append(variable.identifier)
        return un_declared_vars

    def visit_LNot(self, lnot: LNot):
        return self.visit(lnot.right)

    def visit_ABinary(self, abinary: ABinary):
        return self.visit(abinary.left) + self.visit(abinary.right)

    def visit_AUMinus(self, auminus: AUMinus):
        return self.visit(auminus.right)

    def visit_ALiteral(self, aliteral: ALiteral):
        return []

    def visit_Call(self, call: Call):
        un_declared_vars = []
        if self.get_error_if_func_not_declared(call.callee) is None:
            # un_declared_vars.append(call.callee)
            pass
        for arg in call.arguments:
            un_declared_vars += self.visit(arg)
        return un_declared_vars

    def get_error_if_func_not_declared(self, callee: Identifier):
        if callee.name not in self.global_fun_decls:
            semantic_error(f"Function identifier '{callee.name}' referenced without being declared.",
                           callee.lineno)
            return None
        return self.global_fun_decls[callee.name]


class MultiVarDeclVisitor(ASTNodeVisitor):
    @staticmethod
    def get_and_error_multiple_var_decls(var_decls: List[Union[VarDecl, Identifier]]) -> List[Identifier]:
        identifier_set = {}  # name -> Identifier
        result = []
        for var_decl in var_decls:
            if isinstance(var_decl, VarDecl):
                identifier = var_decl.identifier
            else:
                identifier = var_decl

            if identifier.name in identifier_set:
                semantic_error(f'Identifier "{identifier.name}" already declared in scope at'
                               f' {get_location_str(identifier_set[identifier.name].lineno)}.',
                               identifier.lineno)
                result.append(identifier)
            else:
                identifier_set[identifier.name] = identifier
        return result

    def visit_SLiteral(self, sliteral: SLiteral):
        return []

    def visit_Program(self, program: Program):
        multiple_var_decls = self.get_and_error_multiple_var_decls(program.var_decls)
        for fun_decl in program.fun_decls:
            multiple_var_decls += self.visit(fun_decl)
        for stmt in program.statements:
            multiple_var_decls += self.visit(stmt)
        return multiple_var_decls

    def visit_ErrorStmt(self, errorstmt: ErrorStmt):
        return []

    def visit_VarDecl(self, vardecl: VarDecl):
        return []

    def visit_FunDecl(self, fundecl: FunDecl):
        block = fundecl.body
        multiple_var_decls = self.get_and_error_multiple_var_decls(fundecl.params + block.var_decls)
        for stmt in block.statements:
            visited_var_decls = self.visit(stmt)
            multiple_var_decls += visited_var_decls
        return multiple_var_decls

    def visit_Assign(self, assign: Assign):
        return []

    def visit_SetVector(self, setvector: SetVector):
        return []

    def visit_ForLoop(self, forloop: ForLoop):
        return self.visit(forloop.body)

    def visit_Return(self, returnn: Return):
        return []

    def visit_WhileLoop(self, whileloop: WhileLoop):
        return self.visit(whileloop.body)

    def visit_Block(self, block: Block):
        multiple_var_decls = self.get_and_error_multiple_var_decls(block.var_decls)
        for stmt in block.statements:
            visited_var_decls = self.visit(stmt)
            multiple_var_decls += visited_var_decls
        return multiple_var_decls

    def visit_Print(self, printt: Print):
        return []

    def visit_IfElse(self, ifelse: IfElse):
        if ifelse.else_branch is None:
            return self.visit(ifelse.if_branch)
        else:
            return self.visit(ifelse.if_branch) + self.visit(ifelse.else_branch)

    def visit_LBinary(self, lbinary: LBinary):
        return []

    def visit_Comparison(self, comparison: Comparison):
        return []

    def visit_LLiteral(self, lliteral: LLiteral):
        return []

    def visit_LPrimary(self, lprimary: LPrimary):
        return []

    def visit_GetVector(self, getvector: GetVector):
        return []

    def visit_Variable(self, variable: Variable):
        return []

    def visit_LNot(self, lnot: LNot):
        return []

    def visit_ABinary(self, abinary: ABinary):
        return []

    def visit_AUMinus(self, auminus: AUMinus):
        return []

    def visit_ALiteral(self, aliteral: ALiteral):
        return []

    def visit_Call(self, call: Call):
        return []
