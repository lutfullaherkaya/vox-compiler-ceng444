from abc import ABC

import compiler_utils as cu
from ast_tools import *
from typing import Dict, Optional, Union, List, Tuple, TypedDict


class OptimizerVisitor(ASTNodeVisitor):
    """
    Does nothing. Only for being able to update the tree using the visitor pattern.
    Derived classes should only override neccesary methods and return nodes in overrided methods.
    """

    def __init__(self):
        super().__init__()
        self.changes_made = False

    def visit_SLiteral(self, sliteral: SLiteral) -> ASTNode:
        return sliteral

    def visit_Program(self, program: Program) -> ASTNode:
        for i in range(len(program.var_decls)):
            program.var_decls[i] = self.visit(program.var_decls[i])
        for i in range(len(program.fun_decls)):
            program.fun_decls[i] = self.visit(program.fun_decls[i])
        for i in range(len(program.statements)):
            program.statements[i] = self.visit(program.statements[i])
        return program

    def visit_ErrorStmt(self, errorstmt: ErrorStmt) -> ASTNode:
        return errorstmt

    def visit_VarDecl(self, vardecl: VarDecl) -> ASTNode:
        if vardecl.initializer is not None:
            if type(vardecl.initializer) == list:
                for i in range(len(vardecl.initializer)):
                    vardecl.initializer[i] = self.visit(vardecl.initializer[i])
            else:
                vardecl.initializer = self.visit(vardecl.initializer)
        return vardecl

    def visit_FunDecl(self, fundecl: FunDecl) -> ASTNode:
        fundecl.body = self.visit(fundecl.body)
        return fundecl

    def visit_Assign(self, assign: Assign) -> ASTNode:
        assign.expr = self.visit(assign.expr)
        return assign

    def visit_SetVector(self, setvector: SetVector) -> ASTNode:
        setvector.vector_index = self.visit(setvector.vector_index)
        setvector.expr = self.visit(setvector.expr)
        return setvector

    def visit_ForLoop(self, forloop: ForLoop) -> ASTNode:
        if forloop.initializer is not None:
            forloop.initializer = self.visit(forloop.initializer)
        if forloop.condition is not None:
            forloop.condition = self.visit(forloop.condition)
        if forloop.increment is not None:
            forloop.increment = self.visit(forloop.increment)
        forloop.body = self.visit(forloop.body)
        return forloop

    def visit_Return(self, returnn: Return) -> ASTNode:
        returnn.expr = self.visit(returnn.expr)
        return returnn

    def visit_WhileLoop(self, whileloop: WhileLoop) -> ASTNode:
        whileloop.condition = self.visit(whileloop.condition)
        whileloop.body = self.visit(whileloop.body)
        return whileloop

    def visit_Block(self, block: Block) -> ASTNode:
        for i in range(len(block.var_decls)):
            block.var_decls[i] = self.visit(block.var_decls[i])
        for i in range(len(block.statements)):
            block.statements[i] = self.visit(block.statements[i])
        return block

    def visit_Print(self, printt: Print) -> ASTNode:
        printt.expr = self.visit(printt.expr)
        return printt

    def visit_IfElse(self, ifelse: IfElse) -> ASTNode:
        ifelse.condition = self.visit(ifelse.condition)
        ifelse.if_branch = self.visit(ifelse.if_branch)
        if ifelse.else_branch is not None:
            ifelse.else_branch = self.visit(ifelse.else_branch)
        return ifelse

    def visit_LBinary(self, lbinary: LBinary) -> ASTNode:
        lbinary.left = self.visit(lbinary.left)
        lbinary.right = self.visit(lbinary.right)
        return lbinary

    def visit_Comparison(self, comparison: Comparison) -> ASTNode:
        comparison.left = self.visit(comparison.left)
        comparison.right = self.visit(comparison.right)
        return comparison

    def visit_LLiteral(self, lliteral: LLiteral) -> ASTNode:
        return lliteral

    def visit_LPrimary(self, lprimary: LPrimary) -> ASTNode:
        lprimary.primary = self.visit(lprimary.primary)
        return lprimary

    def visit_GetVector(self, getvector: GetVector) -> ASTNode:
        getvector.vector_index = self.visit(getvector.vector_index)
        return getvector

    def visit_Variable(self, variable: Variable) -> ASTNode:
        return variable

    def visit_LNot(self, lnot: LNot) -> ASTNode:
        lnot.right = self.visit(lnot.right)
        return lnot

    def visit_ABinary(self, abinary: ABinary) -> ASTNode:
        abinary.left = self.visit(abinary.left)
        abinary.right = self.visit(abinary.right)
        return abinary

    def visit_AUMinus(self, auminus: AUMinus) -> ASTNode:
        auminus.right = self.visit(auminus.right)
        return auminus

    def visit_ALiteral(self, aliteral: ALiteral) -> ASTNode:
        return aliteral

    def visit_Call(self, calll: Call) -> ASTNode:
        for i in range(len(calll.arguments)):
            calll.arguments[i] = self.visit(calll.arguments[i])
        return calll


class ConstantFoldingVisitor(OptimizerVisitor):
    """
    https://en.wikipedia.org/wiki/Constant_folding
    """

    def __init__(self):
        super().__init__()

    def visit_LBinary(self, lbinary: LBinary):
        lbinary.left = self.visit(lbinary.left)
        lbinary.right = self.visit(lbinary.right)
        if isinstance(lbinary.left, LLiteral) and isinstance(lbinary.right, LLiteral):
            self.changes_made = True
            if lbinary.op == 'and':
                return LLiteral(lbinary.left.value and lbinary.right.value)
            elif lbinary.op == 'or':
                return LLiteral(lbinary.left.value or lbinary.right.value)
        if isinstance(lbinary.left, LLiteral):
            if lbinary.op == 'and':
                if not lbinary.left.value:
                    self.changes_made = True
                    return LLiteral(False)
            elif lbinary.op == 'or':
                if lbinary.left.value:
                    self.changes_made = True
                    return LLiteral(True)
        if isinstance(lbinary.right, LLiteral):
            solda_yan_etki_var = YanEtkiVarMiVisitor().visit(lbinary.left)
            if not solda_yan_etki_var:
                if lbinary.op == 'and':
                    if not lbinary.right.value:
                        self.changes_made = True
                        return LLiteral(False)
                elif lbinary.op == 'or':
                    if lbinary.right.value:
                        self.changes_made = True
                        return LLiteral(True)
        return lbinary

    def visit_Comparison(self, comparison: Comparison):
        comparison.left = self.visit(comparison.left)
        comparison.right = self.visit(comparison.right)
        if isinstance(comparison.left, LLiteral) and isinstance(comparison.right, LLiteral):
            self.changes_made = True
            if comparison.op == '==':
                return LLiteral(comparison.left.value == comparison.right.value)
            elif comparison.op == '!=':
                return LLiteral(comparison.left.value != comparison.right.value)
            elif comparison.op == '<':
                return LLiteral(comparison.left.value < comparison.right.value)
            elif comparison.op == '<=':
                return LLiteral(comparison.left.value <= comparison.right.value)
            elif comparison.op == '>':
                return LLiteral(comparison.left.value > comparison.right.value)
            elif comparison.op == '>=':
                return LLiteral(comparison.left.value >= comparison.right.value)
        return comparison

    def visit_LNot(self, lnot: LNot):
        lnot.right = self.visit(lnot.right)
        if isinstance(lnot.right, LLiteral):
            self.changes_made = True
            return LLiteral(not lnot.right.value)
        return lnot

    def visit_ABinary(self, abinary: ABinary):
        abinary.left = self.visit(abinary.left)
        abinary.right = self.visit(abinary.right)
        if isinstance(abinary.left, ALiteral) and isinstance(abinary.right, ALiteral):
            self.changes_made = True
            if abinary.op == '+':
                return ALiteral(abinary.left.value + abinary.right.value)
            elif abinary.op == '-':
                return ALiteral(abinary.left.value - abinary.right.value)
            elif abinary.op == '*':
                return ALiteral(abinary.left.value * abinary.right.value)
            elif abinary.op == '/' and abinary.right.value != 0:
                # payda 0 ise ne hali varsa görsün runtimede
                return ALiteral(abinary.left.value / abinary.right.value)
        yan_etki_visitor = YanEtkiVarMiVisitor()
        if isinstance(abinary.left, ALiteral):
            if abinary.op == '+':
                if abinary.left.value == 0:
                    self.changes_made = True
                    return abinary.right
            elif abinary.op == '-':
                if abinary.left.value == 0:
                    self.changes_made = True
                    return AUMinus(abinary.right)
            elif abinary.op == '*':
                if abinary.left.value == 0 and not yan_etki_visitor.visit(abinary.right):
                    self.changes_made = True
                    return ALiteral(0)
                elif abinary.left.value == 1:
                    self.changes_made = True
                    return abinary.right
        if isinstance(abinary.right, ALiteral):
            if abinary.op == '+':
                if abinary.right.value == 0:
                    self.changes_made = True
                    return abinary.left
            elif abinary.op == '-':
                if abinary.right.value == 0:
                    self.changes_made = True
                    return abinary.left
            elif abinary.op == '*':
                if abinary.right.value == 0 and not yan_etki_visitor.visit(abinary.left):
                    self.changes_made = True
                    return ALiteral(0)
                elif abinary.right.value == 1:
                    self.changes_made = True
                    return abinary.left

        return abinary

    def visit_AUMinus(self, auminus: AUMinus):
        auminus.right = self.visit(auminus.right)
        if isinstance(auminus.right, ALiteral):
            self.changes_made = True
            return ALiteral(-auminus.right.value)
        return auminus


class ConstantPropogationVisitor(OptimizerVisitor):
    def __init__(self):
        super().__init__()


class YanEtkiVarMiVisitor(ASTNodeVisitor):
    def __init__(self):
        super().__init__()

    def visit_SLiteral(self, sliteral: SLiteral):
        return False

    def visit_Program(self, program: Program):
        return True

    def visit_ErrorStmt(self, errorstmt: ErrorStmt):
        return True

    def visit_VarDecl(self, vardecl: VarDecl):
        return True

    def visit_FunDecl(self, fundecl: FunDecl):
        return True

    def visit_Assign(self, assign: Assign):
        return True

    def visit_SetVector(self, setvector: SetVector):
        return True

    def visit_ForLoop(self, forloop: ForLoop):
        return True

    def visit_Return(self, returnn: Return):
        return True

    def visit_WhileLoop(self, whileloop: WhileLoop):
        return True

    def visit_Block(self, block: Block):
        if any(self.visit(var_decl) for var_decl in block.var_decls):
            return True
        if any(self.visit(stmt) for stmt in block.statements):
            return True
        return False

    def visit_Print(self, printt: Print):
        return True

    def visit_IfElse(self, ifelse: IfElse):
        if self.visit(ifelse.condition) or self.visit(ifelse.if_branch):
            return True
        if ifelse.else_branch is not None:
            return self.visit(ifelse.else_branch)
        return False

    def visit_LBinary(self, lbinary: LBinary):
        return self.visit(lbinary.left) or self.visit(lbinary.right)

    def visit_Comparison(self, comparison: Comparison):
        return self.visit(comparison.left) or self.visit(comparison.right)

    def visit_LLiteral(self, lliteral: LLiteral):
        return False

    def visit_LPrimary(self, lprimary: LPrimary):
        return self.visit(lprimary.primary)

    def visit_GetVector(self, getvector: GetVector):
        return self.visit(getvector.vector_index)

    def visit_Variable(self, variable: Variable):
        return False

    def visit_LNot(self, lnot: LNot):
        return self.visit(lnot.right)

    def visit_ABinary(self, abinary: ABinary):
        return self.visit(abinary.left) or self.visit(abinary.right)

    def visit_AUMinus(self, auminus: AUMinus):
        return self.visit(auminus.right)

    def visit_ALiteral(self, aliteral: ALiteral):
        return False

    def visit_Call(self, calll: Call):
        return True  # asıl önemli kısım. fonksiyon çağrısı varsa yan etki vardır, ölü kod saymamalıyız o kodu.


class OluKodOldurucuVisitor(OptimizerVisitor):
    """
    Removes statements after return
    Removes if true/false, while false, for ;false;
    """

    def __init__(self):
        super().__init__()

    def visit_ForLoop(self, forloop: ForLoop):
        if forloop.initializer is not None:
            forloop.initializer = self.visit(forloop.initializer)
        if forloop.condition is not None:
            forloop.condition = self.visit(forloop.condition)
            if isinstance(forloop.condition, LLiteral) and not forloop.condition.value:
                self.changes_made = True
                return Block([], [])
        if forloop.increment is not None:
            forloop.increment = self.visit(forloop.increment)
        forloop.body = self.visit(forloop.body)
        return forloop

    def visit_WhileLoop(self, whileloop: WhileLoop):
        whileloop.condition = self.visit(whileloop.condition)
        if isinstance(whileloop.condition, LLiteral) and not whileloop.condition.value:
            self.changes_made = True
            return Block([], [])
        whileloop.body = self.visit(whileloop.body)
        return whileloop

    def visit_Block(self, block: Block):
        for i in range(len(block.var_decls)):
            block.var_decls[i] = self.visit(block.var_decls[i])
        for i in range(len(block.statements)):
            block.statements[i] = self.visit(block.statements[i])
            if isinstance(block.statements[i], Return):
                self.changes_made = True
                del block.statements[i + 1:]
                break
        return block

    def visit_IfElse(self, ifelse: IfElse):
        ifelse.condition = self.visit(ifelse.condition)
        ifelse.if_branch = self.visit(ifelse.if_branch)
        if isinstance(ifelse.condition, LLiteral):
            self.changes_made = True
            if ifelse.condition.value:
                return ifelse.if_branch
            else:
                if ifelse.else_branch is not None:
                    ifelse.else_branch = self.visit(ifelse.else_branch)
                    return ifelse.else_branch
                else:
                    return Block([], [])

        return ifelse