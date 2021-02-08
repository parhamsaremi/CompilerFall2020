from lark import Transformer
from SymbolTable import SymbolTable
from Scope import Scope


class FirstTraverse(Transformer):
    def __init__(self):
        super().__init__()
        self.symbol_table = SymbolTable.get_symbol_table()

    def program(self, args):
        self.symbol_table.push_new_scope()

    def decl_prime(self, args):
        pass

    def decl_variable_decl(self, args):
        pass

    def decl_function_decl(self, args):
        pass

    def decl_class_decl(self, args):
        pass

    def decl_interface_decl(self, args):
        pass

    ####

    def t_double(self, args):
        return {value: float(args[0].value)}

    def t_int(self, args):
        return {value: int(args[0].value)}

    def t_bool(self, args):
        return {value: bool(args[0].value)}

    def t_string(self, args):
        return {value: args[0]}

    def identifier(self, args):
        return {value: args[0]}
