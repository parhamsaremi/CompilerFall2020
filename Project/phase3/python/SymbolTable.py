from Scope import Scope


class SymbolTable:
    symbol_table = None

    def __init__():
        self.scope_count = 0
        self.scope_dict = {}
        self.scope_stack = []

    def get_symbol_table():
        if SymbolTable.symbol_table is None:
            SymbolTable.symbol_table = SymbolTable()
        return SymbolTable.symbol_table

    # returns scope on top of the self.scope_stack
    def get_cur_scope(self):
        return self.scope_stack[-1]

    def push_new_scope(self):
        parent = null
        if self.scope_stack.size != 0:
            parent = self.get_cur_scope()
        new_scope = Scope(self.scope_count, parent)
        self.scope_stack.append(new_scope)
        self.scope_count += 1

    def pop_scope(self):
        res = self.scope_stack.pop()
        return res
