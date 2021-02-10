from lark import Transformer
from SymbolTable import SymbolTable
from Scope import Scope
from SemanticError import SemanticError as SemErr

# TODO:
# add '_f' to end of all functions
# may need to change if_stmt in grammar
# deleted wrong terminal rules, might need extra work


def get_scopes_of_children(args):
    res = []
    for arg in args:
        if type(arg) != dict:
            continue
        for scope in arg['scopes']:
            if scope is not None:
                res.append(scope)
    return res


def set_parent_of_children_scope(parent_scope: Scope, children_scopes: list):
    for scope in children_scopes:
        scope.parent = parent_scope


def set_children_of_parent_scope(parent_scope: Scope, children_scopes: list):
    for scope in children_scopes:
        parent_scope.children.append(scope)


class FirstTraverse(Transformer):
    def __init__(self):
        super().__init__()
        # self.symbol_table = SymbolTable.get_symbol_table()

    def program_f(self, args):
        # TODO scope (more precisely global scope)
        scope = Scope()
        children_scopes = get_scopes_of_children(args)
        set_parent_of_children_scope(scope, children_scopes)
        set_children_of_parent_scope(scope, children_scopes)
        decls = [args[0]]
        for decl in args[1]['decls']:
            decls.append(decl)
        return {'scopes': [scope], 'decls': decls}

    def decl_prime_f(self, args):
        scopes = get_scopes_of_children(args)
        if len(args) == 0:
            return {'scopes': scopes, 'decls': []}
        else:
            decls = [args[0]]
            for decl in args[1]['decls']:
                decls.append(decl)
            return {'scopes': scopes, 'decls': decls}

    def decl_f(self, args):
        return args[0]

    def variable_decl_f(self, args):
        return {
            'scopes': [None],
            'decl_type': 'variable',
            'type': args[0]['type'],
            'id': args[0]['id']
        }

    def variable_decl_prime_f(self, args):
        if len(args) == 0:
            return {'scopes': [None], 'variable_decls': []}
        else:
            variable_decls = args[0]['variable_decls']
            variable_decls.append(args[1])
            return {'scopes': [None], 'variable_decls': variable_decls}

    def function_decl_f(self, args):
        # TODO function scope (it has bug now)
        scope = Scope()
        children_scopes = get_scopes_of_children(args)
        set_parent_of_children_scope(scope, children_scopes)
        set_children_of_parent_scope(scope, children_scopes)
        # if declared function returns type
        if len(args) == 4:
            return {
                'scopes': [scope],
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
                'scopes': [scope],
                'decl_type': 'function',
                'type': type_,
                'id': args[0]['value'],
                'formals': args[1]['variables'],
                'stmt_block': args[2]
            }

    def interface_decl_f(self, args):
        # TODO scope
        scope = Scope()
        children_scopes = get_scopes_of_children(args)
        set_parent_of_children_scope(scope, children_scopes)
        set_children_of_parent_scope(scope, children_scopes)
        return {
            'scopes': [scope],
            'id': args[0]['value'],
            'prototypes': args[1]['prototypes']
        }

    def class_decl_f(self, args):
        scope = Scope()
        children_scopes = get_scopes_of_children(args)
        set_parent_of_children_scope(scope, children_scopes)
        set_children_of_parent_scope(scope, children_scopes)
        fields = args[3]['fields']
        for field in fields:
            decl = field['declaration']
            decl['access_mode'] = field_access_mode
            if decl['decl_type'] == 'function':
                if scope.does_decl_id_exist(decl['id']):
                    raise SemErr(
                        f'duplicate id \'{decl["id"]}\' in class \'{args[0]["value"]}\''
                    )
                scope.decls[decl['id']] = decl
                # scope.children.append(decl['scope'])
                decl['scope'].parent = scope
            elif decl['decl_type'] == 'variable':
                scope.decls[decl['id']] = decl
            else:
                assert 1 == 2  # decl_type must be 'function' or 'variable', but it wasn't
        return {
            'scopes': [scope],
            'id': args[0]['value'],
            'parent_class': args[1]['parent_class'],
            'interfaces': args[2]['interfaces'],
            'fields': args[3]['fields']
        }

    def stmt_block_f(self, args):
        # TODO scope
        scope = Scope()
        children_scopes = get_scopes_of_children(args)
        set_parent_of_children_scope(scope, children_scopes)
        set_children_of_parent_scope(scope, children_scopes)
        return {
            'scopes': [scope],
            'variable_decls': args[0]['variable_decls'],
            'stmts': args[1]['stmts']
        }

    def stmt_expr_prime_f(self, args):
        scopes = get_scopes_of_children(args)
        return {'scopes': scopes, 'stmt_type': 'expr_prime', 'stmt': args[0]}

    def stmt_f(self, args):
        scopes = get_scopes_of_children(args)
        res = args[0]
        res['scopes'] = scopes
        return res

    def stmt_stmt_block_f(self, args):
        scopes = get_scopes_of_children(args)
        return {'scopes': scopes, 'stmt_type': 'stmt_block', 'stmt': args[0]}

    def if_stmt_f(self, args):
        scopes = get_scopes_of_children(args)
        return {
            'scopes': scopes,
            'stmt_type': 'if_else',
            'condition_expr': args[0],
            'if_stmt': args[1],
            'else_stmt': args[2]['stmt']
        }

    def else_prime_f(self, args):
        scopes = get_scopes_of_children(args)
        if len(args) == 0:
            return {'scopes': [None], 'stmt': None}
        else:
            return {'scopes': [None], 'stmt': args[0]}

    def expr_f(self, args):
        res = args[0]
        res['scopes'] = [None]
        return res

    def expr_prime_f(self, args):
        # TODO check it
        if len(args) == 0:
            return None
        else:
            return args[0]

    def exprs_f(self, args):
        scopes = get_scopes_of_children(args)
        if len(args) == 0:
            return {'scopes': [None], 'exprs': []}
        else:
            exprs = args[0]
            for expr in args[1]['exprs']:
                exprs.append(expr)
            return {'scopes': [None], 'exprs': exprs}

    def actuals_f(self, args):
        if len(args) == 0:
            return {'scopes': [None], 'exprs': []}
        else:
            exprs = args[0]
            for expr in args[1]['exprs']:
                exprs.append(expr)
            return {'scopes': [None], 'exprs': exprs}

    def return_stmt_f(self, args):
        return {'scopes': [None], 'stmt_type': 'return'}

    def break_stmt_f(self, args):
        return {'scopes': [None], 'stmt_type': 'break'}

    def continue_stmt_f(self, args):
        return {'scopes': [None], 'stmt_type': 'continue'}

    def variable_f(self, args):
        return {'scopes': [None], 'type': args[0], 'id': args[1]['value']}

    def print_stmt_f(self, args):
        exprs = args[0]
        for expr in args[1]['exprs']:
            exprs.append(expr)
        return {'scopes': [None], 'exprs': exprs}

    def variable_prime_f(self, args):
        scopes = get_scopes_of_children(args)
        if len(args) == 0:
            return {'scopes': [None], 'variables': []}
        else:
            variables_list = args[2]['variables']
            varialbes_list.append(args[1])
            return {'scopes': [None], 'variables': variables_list}

    def while_stmt_f(self, args):
        scopes = get_scopes_of_children(args)
        return {
            'scopes': scopes,
            'stmt_type': 'while',
            'condition_expr': args[0],
            'stmt': args[1]
        }

    def for_stmt_f(self, args):
        scopes = get_scopes_of_children(args)
        return {
            'scopes': scopes,
            'stmt_type': 'for',
            'init_expr': args[0]['stmt'],
            'condition_expr': args[1],
            'step_expr': args[2],
            'stmt': args[3]
        }

    def formals_f(self, args):
        scopes = get_scopes_of_children(args)
        if len(args) == 0:
            return {'scopes': [None], 'variables': []}
        else:
            variables_list = args[1]['variables']
            variables_list.append(args[0])
            return {'scopes': [None], 'variables': variables_list}

    def prototype_f(self, args):
        # if prototype returns type
        if len(args) == 3:
            return {
                'scopes': [None],
                'type': args[0],
                'id': args[1]['value'],
                'formals': args[3]['variables']
            }
        # if prototype returns void
        else:
            type_ = {'is_arr': False, 'class': 'primitive', 'type': 'void'}
            return {
                'scopes': [None],
                'type': type_,
                'id': args[1]['value'],
                'formals': args[3]['variables']
            }

    def prototype_prime_f(self, args):
        # TODO does prototype have scope
        if len(args) == 0:
            return {'scopes': [None], 'prototypes': []}
        else:
            prototypes = args[1]['prototypes']
            prototypes.append(args[0])
            return {'scopes': [None], 'prototype': prototypes}

    def call_f(self, args):
        # id()
        if len(args) == 2:
            return {'scopes': [None], 'id': args[0]}
        # obj.field()
        else:
            return {'scopes': [None], 'obj_id': args}

    def l_value_id_f(self, args):
        return {'scopes': [None], 'l_value_type': 'id', 'l_value': args[0]}

    def l_value_obj_f(self, args):
        return {
            'scopes': [None],
            'l_value_type': 'obj_field',
            'obj': args[0],
            'obj_field': args[1]
        }

    def l_value_arr_f(self, args):
        return {
            'scopes': [None],
            'l_value_type': 'array',
            'arr': args[0],
            'index': args[1]
        }

    def stmt_prime_f(self, args):
        scopes = get_scopes_of_children(args)
        if len(args) == 0:
            return {'scopes': [None], 'stmts': []}
        else:
            stmts = args[1]['stmts']
            stmts.append(args[0])
            return {'scopes': [None], 'stmts': stmts}

    def type_int_f(self, args):
        return {
            'scopes': [None],
            'is_arr': False,
            'type': 'int',
            'class': 'Primitive'
        }

    def type_double_f(self, args):
        return {
            'scopes': [None],
            'is_arr': False,
            'type': 'double',
            'class': 'Primitive'
        }

    def type_bool_f(self, args):
        return {
            'scopes': [None],
            'is_arr': False,
            'type': 'bool',
            'class': 'Primitive'
        }

    def type_string_f(self, args):
        return {
            'scopes': [None],
            'is_arr': False,
            'type': 'string',
            'class': 'Primitive'
        }

    def type_id_f(self, args):
        return {
            'scopes': [None],
            'is_arr': False,
            'type': 'Object',
            'class': args[0]['value']
        }

    def type_arr_f(self, args):
        return {
            'scopes': [None],
            'is_arr': True,
            'type': args[0]['type'],
            'class': args[0]['class']
        }

    def implements_f(self, args):
        if len(args) == 0:
            return {'scopes': [None], 'interfaces': None}
        else:
            ids = args[2]['ids']
            ids.append(args[1]['value'])
            return {'scopes': [None], 'interfaces': ids}

    def extends_f(self, args):
        # if class extends another class
        if len(args) == 2:
            return {'scopes': [None], 'parent_class': args[1]['value']}
        # if class doesn't extend any class
        else:
            return {'scopes': [None], 'parent_class': None}

    def field_prime_f(self, args):
        scopes = get_scopes_of_children(args)
        if len(args) == 0:
            return {'scopes': scopes, 'fields': []}
        else:
            fields = args[1]['fields']
            fields.append(args[0])
            return {'scopes': scopes, 'fields': fields}

    def field_f(self, args):
        scopes = get_scopes_of_children(args)
        return {
            'scopes': scopes,
            'access_mode': args[0]['value'],
            'declaration': args[1]
        }

    def access_mode_private(self, args):
        return {'scopes': [None], 'value': 'private'}

    def access_mode_protected(self, args):
        return {'scopes': [None], 'value': 'private'}

    def access_mode_public(self, args):
        return {'scopes': [None], 'value': 'private'}

    def assign_f(self, args):
        if len(args) == 1:
            return {'expr_type': args[0]['expr_type'], 'expr': args[0]}
        else:
            return {
                'expr_type': 'assign',
                'l_value': args[0],
                'r_value': args[1]
            }

    def or_f(self, args):
        if len(args) == 1:
            return {'expr_type': 'or', 'op_list': [], 'and_list': [args[0]]}
        else:
            and_list = args[0]['and_list']
            and_list.append(args[1])
            op_list = args[0]['op_list']
            op_list.append('||')
            return {
                'expr_type': 'or',
                'op_list': op_list,
                'and_list': and_list
            }

    def and_f(self, args):
        if len(args) == 1:
            return {
                'expr_type': 'and',
                'op_list': [],
                'eq_neq_list': [args[0]]
            }
        else:
            eq_neq_list = args[0]['eq_neq_list']
            eq_neq_list.append(args[1])
            op_list = args[0]['op_list']
            op_list.append('&&')
            return {
                'expr_type': 'and',
                'op_list': op_list,
                'eq_neq_list': eq_neq_list
            }

    def eq_neq_f(self, args):
        if len(args) == 1:
            return {
                'expr_type': 'eq_neq',
                'op_list': [],
                'comp_list': [args[0]]
            }
        else:
            comp_list = args[0]['comp_list']
            comp_list.append(args[1])
            op_list = args[0]['op_list']
            op_list.append(args[1].value)
            return {
                'expr_type': 'eq_neq',
                'op_list': op_list,
                'comp_list': comp_list
            }

    def comp_f(self, args):
        if len(args) == 1:
            return {
                'expr_type': 'comp',
                'op_list': [],
                'add_sub_list': [args[0]]
            }
        else:
            add_sub_list = args[0]['add_sub_list']
            add_sub_list.append(args[1])
            op_list = args[0]['op_list']
            op_list.append(args[1].value)
            return {
                'expr_type': 'comp',
                'op_list': op_list,
                'add_sub_list': add_sub_list
            }

    def add_sub_f(self, args):
        if len(args) == 1:
            return {
                'expr_type': 'add_sub',
                'op_list': [],
                'mul_div_mod_list': [args[0]]
            }
        else:
            mul_div_mod_list = args[0]['mul_div_mod_list']
            mul_div_mod_list.append(args[1])
            op_list = args[0]['op_list']
            op_list.append(args[1].value)
            return {
                'expr_type': 'add_sub',
                'op_list': op_list,
                'mul_div_mod_list': mul_div_mod_list
            }

    def mul_div_mod_f(self, args):
        if len(args) == 1:
            return {
                'expr_type': 'mul_div_mod',
                'op_list': [],
                'not_neg_list': [args[0]]
            }
        else:
            not_neg_list = args[0]['not_neg_list']
            not_neg_list.append(args[1])
            op_list = args[0]['op_list']
            op_list.append(args[1].value)
            return {
                'expr_type': 'mul_div_mod',
                'op_list': op_list,
                'not_neg_list': not_neg_list
            }

    def not_neg_f(self, args):
        if len(args) == 1:
            return {'expr_type': 'not_neg', 'op_list': [], 'others': args[0]}
        else:
            op_list = args[1]['op_list']
            op_list.append(args[0].value)
            return {
                'expr_type': 'not_neg',
                'op_list': op_list,
                'others': args[1]['others']
            }

    def others_constant_f(self, args):
        res = args[0]
        res['expr_type'] = 'constant'
        return res

    def others_this_f(self, args):
        return {'expr_type': 'this'}

    def others_lvalue_f(self, args):
        res = args[0]
        res['expr_type'] = 'lvalue'
        return res

    def others_call_f(self, args):
        res = args[0]
        res['expr_type'] = 'call'
        return res

    def others_p_expr_p_f(self, args):
        res = args[0]
        res['expr_type'] = '(expr)'
        return res

    def others_read_int_f(self, args):
        return {'expr_type': 'read_int'}

    def others_read_line_f(self, args):
        return {'expr_type': 'read_line'}

    def others_new_id_f(self, args):
        return {'expr_type': 'new_id', 'id': args[0]['value']}

    def others_new_arr_f(self, args):
        return {'expr_type': 'new_arr', 'size': args[0], 'type': args[1]}

    def others_itod_f(self, args):
        return {'expr_type': 'itod', 'expr': args[0]}

    def others_dtoi_f(self, args):
        return {'expr_type': 'dtoi', 'expr': args[0]}

    def others_itob_f(self, args):
        return {'expr_type': 'itob', 'expr': args[0]}

    def others_btoi_f(self, args):
        return {'expr_type': 'btoi', 'expr': args[0]}

    def id_prime_f(self, args):
        if len(args) == 0:
            return {'scopes': [None], 'ids': []}
        else:
            ids = args[2]['ids']
            ids.append(args[1]['value'])
            return {'scopes': [None], 'ids': ids}

    def constant_int_f(self, args):
        return {'scopes': [None], 'type': 'int', 'value': args[0]}

    def constant_double_f(self, args):
        return {'scopes': [None], 'type': 'double', 'value': args[0]}

    def constant_bool_f(self, args):
        return {'scopes': [None], 'type': 'bool', 'value': args[0]}

    def constant_string_f(self, args):
        return {'scopes': [None], 'type': 'string', 'value': args[0]}

    def constant_null_f(self, args):
        return {'scopes': [None], 'type': 'null', 'value': None}

    def identifier_f(self, args):
        return {'scopes': [None], 'value': args[0]}
