
from lark import Transformer
from SymbolTable import SymbolTable
from Scope import Scope

# TODO:
# add '_f' to end of all functions
# may need to change if_stmt in grammar
# deleted wrong terminal rules, might need extra work

class FirstTraverse(Transformer):
    def __init__(self):
        super().__init__()
        self.symbol_table = SymbolTable.get_symbol_table()

    def program_f(self, args):
        pass

    def decl_prime_f(self, args):
        pass

    def decl_variable_decl(self, args):
        pass

    def decl_function_decl(self, args):
        pass

    def decl_class_decl(self, args):
        pass

    def decl_interface_decl(self, args):
        pass

    def variable_decl_f(self, args):
        return {
            'decl_type': 'variable',
            'variable': args[0]
        }

    def variable_decl_prime_f(self, args):
        if len(args) == 0:
            return {
                'variable_decls': []
            }
        else:
            variable_decls = args[0]['variable_decls']
            variable_decls.append(args[1])
            return {
                'variable_decls': variable_decls
            }

    def function_decl_f(self, args):
        # TODO function scope
        # if declared function returns type
        if len(args) == 4:
            return {
                'decl_type': 'function',
                'type': args[0],
                'id': args[1]['value'],
                'formals': args[2]['variables'],
                'stmt_block': args[3]
            }
        # if declared function returns void
        else:
            type_ = {'is_arr': False, 'class': 'primitive', 'type': 'void'}
            return {
                'decl_type': 'function',
                'type': type_,
                'id': args[0]['value'],
                'formals': args[1]['variables'],
                'stmt_block': args[2]
            }

    def interface_decl_f(self, args):
        return {
            'id': args[0]['value'],
            'prototypes': args[1]['prototypes']
        }

    def class_decl_f(self, args):
        # TODO class scope
        return {
            'id': args[0]['value'],
            'parent_class': args[1]['parent_class'],
            'interfaces': args[2]['interfaces'],
        }

    def variable_f(self, args):
        return {
            'type': args[0],
            'id': args[1]['value']
        }

    def variable_prime_f(self, args):
        if len(args) == 0:
            return {
                'variables': []
            }
        else:
            variables_list = args[2]['variables']
            varialbes_list.append(args[1])
            return {
                'variables': variables_list
            }

    def formals_f(self, args):
        if len(args) == 0:
            return {
                'variables': []
            }
        else:
            variables_list = args[1]['variables']
            variables_list.append(args[0])
            return {
                'variables': variables_list
            }

    def prototype_f(self, args):
        # if prototype returns type
        if len(args) == 3:
            return {
                'type': args[0],
                'id': args[1]['value'],
                'formals': args[3]['variables']
            }
        # if prototype returns void
        else:
            type_ = {'is_arr': False, 'class': 'primitive', 'type': 'void'}
            return {
                'type': type_,
                'id': args[1]['value'],
                'formals': args[3]['variables']
            }

    def prototype_prime_f(self, args):
        if len(args) == 0:
            return {
                'prototypes': []
            }
        else:
            prototypes = args[1]['prototypes']
            prototypes.append(args[0])
            return {
                'prototype': prototypes
            }

    def type_int_f(self, args):
        return {
            'is_arr': False,
            'type': 'int',
            'class': 'Primitive'
        }

    def type_double_f(self, args):
        return {
            'is_arr': False,
            'type': 'double',
            'class': 'Primitive'
        }

    def type_bool_f(self, args):
        return {
            'is_arr': False,
            'type': 'bool',
            'class': 'Primitive'
        }

    def type_string_f(self, args):
        return {
            'is_arr': False,
            'type': 'string',
            'class': 'Primitive'
        }

    def type_id_f(self, args):
        return {
            'is_arr': False,
            'type': 'Object',
            'class': args[0]['value']
        }

    def type_arr_f(self, args):
        return {
            'is_arr': True,
            'type': args[0]['type'],
            'class': args[0]['class']
        }

    def implements_f(self, args):
        if len(args) == 0:
            return {
                'interfaces': None
            }
        else:
            ids = args[2]['ids']
            ids.append(args[1]['value'])
            return {
                'interfaces': ids
            }

    def extends_f(self, args):
        # if class extends another class
        if len(args) == 2:
            return {
                'parent_class': args[1]['value']
            }
        # if class doesn't extend any class
        else:
            return {
                'parent_class': None
            }

    def field_prime_f(self, args):
        if len(args) == 0:
            return {
                'fields': [] 
            }
        else:
            fields = args[1]['fields']
            fields.append(args[0])
            return {
                'fields': fields
            }

    def field_f(self, args):
        return {
            'access_mode': args[0]['value'],
            'declaration': args[1]
        }

    def access_mode_private(self, args):
        return {
            'value': 'private'
        }

    def access_mode_protected(self, args):
        return {
            'value': 'private'
        }

    def access_mode_public(self, args):
        return {
            'value': 'private'
        }

    def id_prime_f(self, args):
        if len(args) == 0:
            return {
                'ids': []
            }
        else:
            ids = args[2]['ids']
            ids.append(args[1]['value'])
            return {
                'ids': ids
            }

    def constant_int_f(self, args):
        return {
            'type': 'int',
            'value': args[0]
        }

    def constant_double_f(self, args):
        return {
            'type': 'double',
            'value': args[0]
        }

    def constant_bool_f(self, args):
        return {
            'type': 'bool',
            'value': args[0]
        }

    def constant_string_f(self, args):
        return {
            'type': 'string',
            'value': args[0]
        }

    def constant_null(self, args):
        return {
            'type': 'null',
            'value': None
        }

    def identifier_f(self, args):
        return {
            'value': args[0]
            }