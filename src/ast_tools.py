from __future__ import annotations
from dataclasses import dataclass, field
from abc import ABC, abstractmethod
from typing import List, Union, Dict, Optional
import sys


def semantic_error(msg, line=None, column=None):
    sys.stderr.write(f"Semantic error at {get_location_str(line, column)}: {msg}\n")


def get_location_str(line, column=None):
    string = f'line {line}'
    if column is not None:
        string += f', column {column}'
    return string


@dataclass(frozen=True)
class ASTNode:
    pass


@dataclass(frozen=True)
class Expr(ASTNode):
    '''expressions. some of the the parse tree components are not explicitly represented (such as parantheses to increase precedence)'''
    pass


@dataclass(frozen=True)
class LExpr(Expr):
    '''logical expressions. conditions of if/while/for stmts, operands of logical operators, and primaries prepended with # are members.'''
    pass


@dataclass(frozen=True)
class AExpr(Expr):
    '''arithmetic expressions.'''
    pass


@dataclass(frozen=True)
class SLiteral(Expr):
    '''string literal. the grammar makes them unusable in arithmetic/logical ops when they are expressed as naked string literals.'''
    value: str


@dataclass(frozen=True)
class Stmt(ASTNode):
    '''statements. middle classes of statements (simpleStmt/free-statement etc.) are not explicitly represented.'''
    pass


@dataclass(frozen=True)
class ErrorStmt(Stmt):
    '''this node should correspond to an error during parsing that is resolved with character re-synchronization.'''
    pass


@dataclass(frozen=True)
class Decl(ASTNode):
    '''declarations.'''
    pass


@dataclass(frozen=True)
class Identifier:
    '''represents an identifier token. lineno and index fields are added to help with error reporting.'''
    name: str
    lineno: int
    index: int


@dataclass(frozen=True)
class VarDecl(Decl):
    '''variable declaration. the initilializer attribute is None if the variable is not initialized to any value,
    it is a list if the variable is initialized as a vector, and and Expr if it is initialized as a non-vector.'''
    identifier: Identifier
    initializer: Union[Expr, List[Expr], None]


@dataclass(frozen=True)
class FunDecl(Decl):
    '''function declaration. as in fun identifier(params...) body'''
    identifier: Identifier
    params: List[Identifier]
    body: Block


@dataclass(frozen=True)
class Program(ASTNode):
    '''the root node of the AST.'''
    var_decls: List[VarDecl]
    fun_decls: List[FunDecl]
    statements: List[Stmt]


@dataclass(frozen=True)
class Assign(Stmt):
    '''assignments to a variable in the form identifier = expr'''
    identifier: Identifier
    expr: Expr


@dataclass(frozen=True)
class SetVector(Stmt):
    '''assignments to a member of vector in the form identifier[vector_index] = expr'''
    identifier: Identifier
    vector_index: AExpr
    expr: Expr


@dataclass(frozen=True)
class ForLoop(Stmt):
    '''a for loop. If any of the fields are left empty, such as in for(;;){}, set them as None.'''
    initializer: Union[Assign, None]
    condition: Union[LExpr, None]
    increment: Union[Assign, None]
    body: Stmt


@dataclass(frozen=True)
class Return(Stmt):
    expr: Expr


@dataclass(frozen=True)
class WhileLoop(Stmt):
    condition: LExpr
    body: Stmt


@dataclass(frozen=True)
class Block(Stmt):
    var_decls: List[VarDecl]
    statements: List[Stmt]


@dataclass(frozen=True)
class Print(Stmt):
    expr: Expr


@dataclass(frozen=True)
class IfElse(Stmt):
    '''an if-else statement. If there is no else corresponding to this if, set else_branch as None.'''
    condition: LExpr
    if_branch: Stmt
    else_branch: Union[Stmt, None]


@dataclass(frozen=True)
class LBinary(LExpr):
    '''logical binary operations and and or. Set op as "and"/"or".'''
    op: str
    left: LExpr
    right: LExpr


@dataclass(frozen=True)
class Comparison(LExpr):
    '''comparison operations <,>,==,!=,<=,>=. Set op as "<"/">"/"=="/"!="/"<="/">=".'''
    op: str
    left: AExpr
    right: AExpr


@dataclass(frozen=True)
class LLiteral(LExpr):
    '''logical literals (TRUE/FALSE tokens).'''
    value: bool


@dataclass(frozen=True)
class LPrimary(LExpr):
    '''# operator on primaries: function calls(# fizzbuzz()), vector accesses(# foo[0]) or variables (# bar) to cast them explicitly as logical.'''
    primary: Union[Call, GetVector, Variable]


@dataclass(frozen=True)
class GetVector(AExpr):
    '''vector access as an expression, as in foo = identifier[vector_index]'''
    identifier: Identifier
    vector_index: AExpr


@dataclass(frozen=True)
class Variable(AExpr):
    '''variable access as an expression, as in foo = identifier'''
    identifier: Identifier


@dataclass(frozen=True)
class LNot(LExpr):
    '''! operation.'''
    right: LExpr


@dataclass(frozen=True)
class ABinary(AExpr):
    '''arithmetic binary operations +,-,* or /. Set op as "+"/"-"/"*" or "/"'''
    op: str
    left: AExpr
    right: AExpr


@dataclass(frozen=True)
class AUMinus(AExpr):
    '''unary minus operation'''
    right: AExpr


@dataclass(frozen=True)
class ALiteral(AExpr):
    '''arithmetic literals (Number)'''
    value: float


@dataclass(frozen=True)
class Call(AExpr):
    '''function call as an expression, as in foo = callee(arguments...)'''
    callee: Identifier
    arguments: List[Expr]


# https://stackoverflow.com/questions/11154668/is-the-visitor-pattern-useful-for-dynamically-typed-languages
class ASTNodeVisitor(ABC):
    def __init__(self):
        self.ASTNodes = {
            SLiteral: self.visit_SLiteral,
            Program: self.visit_Program,
            ErrorStmt: self.visit_ErrorStmt,
            VarDecl: self.visit_VarDecl,
            FunDecl: self.visit_FunDecl,
            Assign: self.visit_Assign,
            SetVector: self.visit_SetVector,
            ForLoop: self.visit_ForLoop,
            Return: self.visit_Return,
            WhileLoop: self.visit_WhileLoop,
            Block: self.visit_Block,
            Print: self.visit_Print,
            IfElse: self.visit_IfElse,
            LBinary: self.visit_LBinary,
            Comparison: self.visit_Comparison,
            LLiteral: self.visit_LLiteral,
            LPrimary: self.visit_LPrimary,
            GetVector: self.visit_GetVector,
            Variable: self.visit_Variable,
            LNot: self.visit_LNot,
            ABinary: self.visit_ABinary,
            AUMinus: self.visit_AUMinus,
            ALiteral: self.visit_ALiteral,
            Call: self.visit_Call
        }

    def visit(self, ast_node: ASTNode):
        return self.ASTNodes[type(ast_node)](ast_node)

    @abstractmethod
    def visit_SLiteral(self, sliteral: SLiteral):
        pass

    @abstractmethod
    def visit_Program(self, program: Program):
        pass

    @abstractmethod
    def visit_ErrorStmt(self, errorstmt: ErrorStmt):
        pass

    @abstractmethod
    def visit_VarDecl(self, vardecl: VarDecl):
        pass

    @abstractmethod
    def visit_FunDecl(self, fundecl: FunDecl):
        pass

    @abstractmethod
    def visit_Assign(self, assign: Assign):
        pass

    @abstractmethod
    def visit_SetVector(self, setvector: SetVector):
        pass

    @abstractmethod
    def visit_ForLoop(self, forloop: ForLoop):
        pass

    @abstractmethod
    def visit_Return(self, returnn: Return):
        pass

    @abstractmethod
    def visit_WhileLoop(self, whileloop: WhileLoop):
        pass

    @abstractmethod
    def visit_Block(self, block: Block):
        pass

    @abstractmethod
    def visit_Print(self, printt: Print):
        pass

    @abstractmethod
    def visit_IfElse(self, ifelse: IfElse):
        pass

    @abstractmethod
    def visit_LBinary(self, lbinary: LBinary):
        pass

    @abstractmethod
    def visit_Comparison(self, comparison: Comparison):
        pass

    @abstractmethod
    def visit_LLiteral(self, lliteral: LLiteral):
        pass

    @abstractmethod
    def visit_LPrimary(self, lprimary: LPrimary):
        pass

    @abstractmethod
    def visit_GetVector(self, getvector: GetVector):
        pass

    @abstractmethod
    def visit_Variable(self, variable: Variable):
        pass

    @abstractmethod
    def visit_LNot(self, lnot: LNot):
        pass

    @abstractmethod
    def visit_ABinary(self, abinary: ABinary):
        pass

    @abstractmethod
    def visit_AUMinus(self, auminus: AUMinus):
        pass

    @abstractmethod
    def visit_ALiteral(self, aliteral: ALiteral):
        pass

    @abstractmethod
    def visit_Call(self, calll: Call):
        pass


class PrintVisitor(ASTNodeVisitor):
    def indent(self, strr):
        return '\n'.join(['    ' + elem for elem in strr.split('\n')])

    def visit_SLiteral(self, sliteral: SLiteral):
        return f'"{sliteral.value}"'

    def visit_Program(self, program: Program):
        return '\n'.join(["TOP_LVL VAR_DECLS:",
                          '\n'.join([self.visit(elem) for elem in program.var_decls]),
                          "TOP_LVL FUN_DECLS:",
                          '\n'.join([self.visit(elem) for elem in program.fun_decls]),
                          "TOP_LVL STMTS:",
                          '\n'.join([self.visit(elem) for elem in program.statements])])

    def visit_ErrorStmt(self, errorstmt: ErrorStmt):
        return 'ERROR_STMT;'

    def visit_VarDecl(self, vardecl: VarDecl):
        if vardecl.initializer is None:
            return f"var {vardecl.identifier.name};"
        elif type(vardecl.initializer) == list:
            return f"var {vardecl.identifier.name} = [{', '.join([self.visit(elem) for elem in vardecl.initializer])}];"
        else:
            return f"var {vardecl.identifier.name} = {self.visit(vardecl.initializer)};"

    def visit_FunDecl(self, fundecl: FunDecl):
        return f"fun {fundecl.identifier.name}({', '.join([elem.name for elem in fundecl.params])}){self.visit(fundecl.body)}"

    def visit_Assign(self, assign: Assign):
        return f"{assign.identifier.name} = {self.visit(assign.expr)};"

    def visit_SetVector(self, setvector: SetVector):
        return f"{setvector.identifier.name}[{self.visit(setvector.vector_index)}] = {self.visit(setvector.expr)};"

    def visit_ForLoop(self, forloop: ForLoop):
        initializer = '' if forloop.initializer is None else self.visit(forloop.initializer)[:-1]
        condition = '' if forloop.condition is None else self.visit(forloop.condition)
        increment = '' if forloop.increment is None else self.visit(forloop.increment)[:-1]
        return f"for ({initializer};{condition};{increment}) {self.visit(forloop.body)}"

    def visit_Return(self, returnn: Return):
        return f"return {self.visit(returnn.expr)};"

    def visit_WhileLoop(self, whileloop: WhileLoop):
        return f"while {self.visit(whileloop.condition)} {self.visit(whileloop.body)}"

    def visit_Block(self, block: Block):
        return '\n'.join(['{',
                          '  VAR_DECLS:',
                          '\n'.join(["    " + self.visit(elem) for elem in block.var_decls]),
                          '  STMTS:',
                          '\n'.join([self.indent(self.visit(elem)) for elem in block.statements]),
                          '}'])

    def visit_Print(self, printt: Print):
        return f"print {self.visit(printt.expr)};"

    def visit_IfElse(self, ifelse: IfElse):
        else_branch = '' if ifelse.else_branch is None else f" else {self.visit(ifelse.else_branch)}"
        return f"if {self.visit(ifelse.condition)} {self.visit(ifelse.if_branch)}{else_branch} endif"

    def visit_LBinary(self, lbinary: LBinary):
        return f"(L{lbinary.op} {self.visit(lbinary.left)} {self.visit(lbinary.right)})"

    def visit_Comparison(self, comparison: Comparison):
        return f"(Lc{comparison.op} {self.visit(comparison.left)} {self.visit(comparison.right)})"

    def visit_LLiteral(self, lliteral: LLiteral):
        return f"{lliteral.value}"

    def visit_LPrimary(self, lprimary: LPrimary):
        return f"#{self.visit(lprimary.primary)}"

    def visit_GetVector(self, getvector: GetVector):
        return f"{getvector.identifier.name}[{self.visit(getvector.vector_index)}]"

    def visit_Variable(self, variable: Variable):
        return f"{variable.identifier.name}"

    def visit_LNot(self, lnot: LNot):
        return f"!{self.visit(lnot.right)}"

    def visit_ABinary(self, abinary: ABinary):
        return f"(A{abinary.op} {self.visit(abinary.left)} {self.visit(abinary.right)})"

    def visit_AUMinus(self, auminus: AUMinus):
        return f"Au-{self.visit(auminus.right)}"

    def visit_ALiteral(self, aliteral: ALiteral):
        return f"{aliteral.value}"

    def visit_Call(self, call: Call):
        return f"{call.callee.name}({', '.join([self.visit(elem) for elem in call.arguments])})"


class Scope:
    # last symbol is the one in the current scope
    symbol_table: Dict[str, Symbol] = {}
    parent: Optional['Scope']

    def __init__(self, parent: Optional['Scope'] = None, symbols: Optional[List[Identifier]] = None):
        self.parent = parent
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

    def get(self, identifier: Identifier) -> Optional[Symbol]:
        if identifier.name in self.symbol_table:
            return self.symbol_table[identifier.name]
        elif self.parent is not None:
            return self.parent.get(identifier)
        else:
            return None

    def get_error_if_not_declared(self, identifier: Identifier) -> Optional[Symbol]:
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
    current_scope: Optional[Scope] = None

    def visit_SLiteral(self, sliteral: SLiteral):
        return []

    def visit_Program(self, program: Program):
        un_declared_vars = []
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
        self.current_scope.add(vardecl.identifier)
        if vardecl.initializer is not None:
            if type(vardecl.initializer) == list:
                for elem in vardecl.initializer:
                    un_declared_vars += self.visit(elem)
            else:
                un_declared_vars += self.visit(vardecl.initializer)

        return un_declared_vars

    def visit_FunDecl(self, fundecl: FunDecl):
        un_declared_vars = []
        self.current_scope.add(fundecl.identifier)

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
        if self.current_scope.get_error_if_not_declared(call.callee) is None:
            un_declared_vars.append(call.callee)
        for arg in call.arguments:
            un_declared_vars += self.visit(arg)
        return un_declared_vars


class MultiVarDeclVisitor(ASTNodeVisitor):
    @staticmethod
    def get_and_error_multiple_var_decls(var_decls: List[VarDecl]) -> List[Identifier]:
        decl_map = {}
        result = []
        for var_decl in var_decls:
            var_name = var_decl.identifier.name
            if var_name in decl_map:
                semantic_error(f'Identifier "{var_name}" already declared in scope at'
                               f' {get_location_str(decl_map[var_name].identifier.lineno)}.',
                               var_decl.identifier.lineno)
                result.append(var_decl.identifier)
            else:
                decl_map[var_name] = var_decl
        return result

    def visit_SLiteral(self, sliteral: SLiteral):
        pass

    def visit_Program(self, program: Program):
        multiple_var_decls = self.get_and_error_multiple_var_decls(program.var_decls)
        for fun_decl in program.fun_decls:
            multiple_var_decls += self.visit(fun_decl)
        for stmt in program.statements:
            visited_var_decls = self.visit(stmt)
            if visited_var_decls is not None:
                multiple_var_decls += visited_var_decls
        return multiple_var_decls

    def visit_ErrorStmt(self, errorstmt: ErrorStmt):
        pass

    def visit_VarDecl(self, vardecl: VarDecl):
        pass

    def visit_FunDecl(self, fundecl: FunDecl):
        return self.visit(fundecl.body)

    def visit_Assign(self, assign: Assign):
        pass

    def visit_SetVector(self, setvector: SetVector):
        pass

    def visit_ForLoop(self, forloop: ForLoop):
        return self.visit(forloop.body)

    def visit_Return(self, returnn: Return):
        pass

    def visit_WhileLoop(self, whileloop: WhileLoop):
        return self.visit(whileloop.body)

    def visit_Block(self, block: Block):
        multiple_var_decls = self.get_and_error_multiple_var_decls(block.var_decls)
        for stmt in block.statements:
            visited_var_decls = self.visit(stmt)
            if visited_var_decls is not None:
                multiple_var_decls += visited_var_decls
        return multiple_var_decls

    def visit_Print(self, printt: Print):
        pass

    def visit_IfElse(self, ifelse: IfElse):
        if ifelse.else_branch is None:
            return self.visit(ifelse.if_branch)
        else:
            return self.visit(ifelse.if_branch) + self.visit(ifelse.else_branch)

    def visit_LBinary(self, lbinary: LBinary):
        pass

    def visit_Comparison(self, comparison: Comparison):
        pass

    def visit_LLiteral(self, lliteral: LLiteral):
        pass

    def visit_LPrimary(self, lprimary: LPrimary):
        pass

    def visit_GetVector(self, getvector: GetVector):
        pass

    def visit_Variable(self, variable: Variable):
        pass

    def visit_LNot(self, lnot: LNot):
        pass

    def visit_ABinary(self, abinary: ABinary):
        pass

    def visit_AUMinus(self, auminus: AUMinus):
        pass

    def visit_ALiteral(self, aliteral: ALiteral):
        pass

    def visit_Call(self, call: Call):
        pass
