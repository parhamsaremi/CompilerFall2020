from lark import Transformer
from SymbolTable import SymbolTable
from Scope import Scope


class FirstTraverse(Transformer):
    def __init__(self):
        super().__init__()
        self.symbol_table = SymbolTable.get_symbol_table()

    def program(self, args):
        pass

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

    def variable_decl(self, args):
        return {
            'decl_type': 'variable_decl',
            'variable': args[0]
        }

    def function_decl(self, args):
        pass

    def variable(self, args):
        return {
            'type': args[0],
            'id': args[1]['value']
        }

    def type_primitive(self, args):
        return {
            'is_arr': False,
            'type': args[0].value,
            'class': 'primitive'
        }

    def type_id(self, args):
        return {
            'is_arr': False,
            'type': 'Object',
            'class': args[0].value
        }

    def type_arr(self, args):
        return {
            'is_arr': True,
            'type': args[0]['type']
            'class': args[0]['class']
        }


    ####


    def constant(self, args):
        return {
            'value': args[0]['value']
            
        }

    def constant_null(self, args):
        return {
            value: None,
            type: 'null'
        }

    def nn(self, args):
        return {
            'value': args[0].value
        }

    def as(self, args):
        return {
            'value': args[0].value
        }

    def mdm(self, args):
        return {
            'value': args[0].value
        }

    def equal(self, args):
        return {
            'value': args[0].value
        }

    def compare(self, args):
        return {
            'value': args[0].value
        }

    def t_double(self, args):
        return {
            'value': float(args[0].value),
            'type': 'double'
            }

    def t_int(self, args):
        return {
            'value': int(args[0].value),
            'type': 'int'
            }

    def t_bool(self, args):
        return {
            'value': bool(args[0].value),
            'type': 'bool'
            }

    def t_string(self, args):
        return {
            'value': args[0],
            'type': 'string'
            }

    def identifier(self, args):
        return {
            'value': args[0]
            }
