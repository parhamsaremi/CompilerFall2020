from lark import Transformer
from SymbolTable import SymbolTable
from Scope import Scope
from SemanticError import SemanticError as SemErr

# TODO:
# check every thing during type checking, not just types,
#   because a class name might be 'bool' for example and it causes a bug

count_label = 0


def get_label(prefix=''):
    label = ''
    if prefix == '':
        label = f'label{count_label}'
        count_label += 1
    else:
        count_label += 1
        label = f'{prefix}_label{count_label}'
    return label


str_const_count = 0


def add_str_const_to_data_sec(string: str):
    label = f'str_const{str_const_count}'
    self.data_sec += f'{label}:  .asciiz "{string}"'
    str_const_count += 1
    return label


class Type:
    def __init__(self):
        pass

    @staticmethod
    def is_bool(type: dict):
        if type['class'] == 'Primitive' and type['type'] == 'bool':
            return True
        return False

    @staticmethod
    def is_int(type: dict):
        if type['class'] == 'Primitive' and type['type'] == 'int':
            return True
        return False

    @staticmethod
    def is_double(type: dict):
        if type['class'] == 'Primitive' and type['type'] == 'double':
            return True
        return False

    @staticmethod
    def is_string(type: dict):
        if type['class'] == 'Primitive' and type['type'] == 'string':
            return True
        return False

    @staticmethod
    def is_object(type: dict):
        if type['type'] == 'Object':
            return True
        return False

    @staticmethod
    def is_arr(type: dict):
        if type['is_arr']:
            return True
        return False


class SecondTraverse():
    def __init__(self, ast):
        self.ast = ast
        self.code = ''
        self.data_sec = ''
        self.program_f(self.ast)
        # TODO concat self.code and self.data_sec (and maybe other parts)
        return self.code

    def program_f(self, program):
        Scope.current_scope_id = Scope.scope_count - 1
        Scope.scope_stack.append(Scope.scope_dict[Scope.current_scope_id])
        for decl in program['decls']:
            self.decl_f(decl)

    # def decl_prime_f(self, args):
    #     scopes = get_scopes_of_children(args)
    #     if len(args) == 0:
    #         return {'scopes': scopes, 'decls': []}
    #     else:
    #         decls = [args[0]]
    #         for decl in args[1]['decls']:
    #             decls.append(decl)
    #         return {'scopes': scopes, 'decls': decls}

    def decl_f(self, decl):
        # TODO complete if bodies below
        if decl['decl_type'] == 'variable':
            # TODO maybe need to pass some args to variable_decl_f
            self.variable_decl_f(decl)
        elif decl['decl_type'] == 'function':
            self.function_decl_f(decl)
        elif decl['decl_type'] == 'class':
            self.class_decl_f(decl)
        elif decl['decl_type'] == 'interface':
            # TODO look useless
            pass
        else:
            assert 1 == 2  # decl_type wasn't in defined cases

    def variable_decl_f(self, args):
        pass

    def variable_decl_prime_f(self, args):
        if len(args) == 0:
            return {'scopes': [None], 'variable_decls': []}
        else:
            variable_decls = args[0]['variable_decls']
            variable_decls.append(args[1])
            return {'scopes': [None], 'variable_decls': variable_decls}

    def function_decl_f(self, function_decl):
        pass

    def interface_decl_f(self, args):
        # TODO scope
        scope = Scope()
        children_scopes = get_scopes_of_children(args)
        set_parent_of_children_scope(scope, children_scopes)
        set_children_of_parent_scope(scope, children_scopes)
        for prototype in args[1]['prototypes']:
            # TODO is it an error?
            if scope.does_decl_id_exist(prototype['id']):
                raise SemErr(f'duplicate id for prototypes')
            scope.decls[prototype['id']] = prototype
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
                scope.decls[decl['id']] = decl
                decl['scope'].parent = scope
            elif decl['decl_type'] == 'variable':
                if scope.does_decl_id_exist(decl['id']):
                    raise SemErr(
                        f'duplicate id \'{decl["id"]}\' in class \'{args[0]["value"]}\''
                    )
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
        for variable_decl in args[0]['variable_decls']:
            if scope.does_decl_id_exist(variable_decl['id']):
                raise SemErr(
                    f'duplicate id \'{variable_decl["id"]}\' declared many times as a variable'
                )
            scope.decls[variable_decl['id']] = variable_decl
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

    def expr_f(self, expr):
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

    def print_stmt_f(self, print_stmt):
        # TODO isn't implemeted by stack, fix it
        for expr in print_stmt['exprs']:
            expr_info = self.expr_f(expr)
            type_ = expr_info['type']
            if type_['is_arr']:
                raise Exception('expr inside Print is string')
            elif type_['type'] == 'Object':
                raise Exception('expr inside Print is Object')
            elif type['type'] == 'string':
                self.code += 'lw $t0, 0($sp)'
                self.code += 'li $v0, 4'
                self.code += 'move $a0, $t0'
                self.code += 'syscall'
                self.code += 'addi $sp, $sp, 4'
            elif type['type'] == 'int':
                self.code += 'lw $t0, 0($sp)'
                self.code += 'li $v0, 1'
                self.code += 'move $a0, $t0'
                self.code += 'syscall'
                self.code += 'addi $sp, $sp, 4'
            elif type['type'] == 'double':
                # TODO
                pass
            elif type['type'] == 'bool':
                self.code += 'lw $t0, 0($sp)'
                self.code += 'li $v0, 1'
                self.code += 'move $a0, $t0'
                self.code += 'syscall'
                self.code += 'addi $sp, $sp, 4'
            else:
                assert 1 == 2  # type wasn't in expected cases

    # def variable_prime_f(self, args):
    #     scopes = get_scopes_of_children(args)
    #     if len(args) == 0:
    #         return {'scopes': [None], 'variables': []}
    #     else:
    #         variables_list = args[2]['variables']
    #         varialbes_list.append(args[1])
    #         return {'scopes': [None], 'variables': variables_list}

    def while_stmt_f(self, while_stmt):
        start_label = get_label('start')
        end_label = get_label('end')
        self.code += f'{start_label}:'
        self.expr_f(while_stmt['condition_expr'])
        self.code += 'lw $t0, 0($sp)'
        self.code += f'beq $t0, $zero, {end_label}'
        # TODO I think I should add 4 to $sp, unless stmt_f does it itself
        self.stmt_f(while_stmt['stmt'])
        self.code += f'j {start_label}'
        self.code += f'{end_label}:'

    def for_stmt_f(self, for_stmt):
        start_label = get_label('start')
        end_label = get_label('end')
        self.expr_f(for_stmt['init_expr'])
        self.code += 'addi $sp, $sp, 4'  # NOTE to remove init_expr result from stack (is it correct?)
        self.code += f'{start_label}:'
        self.expr_f(for_stmt['condition_expr'])
        self.code += 'lw $t0, 0($sp)'
        self.code += 'addi $sp, $sp, 4'
        self.code += f'beq $t0, $zero, {end_label}'
        self.expr_f(for_stmt['step_expr'])
        self.code += 'addi $sp, $sp, 4'
        self.stmt_f(for_stmt['stmt'])
        self.code += f'j {start_label}'
        self.code += f'{end_label}:'

    def formals_f(self, args):
        scopes = get_scopes_of_children(args)
        if len(args) == 0:
            return {'scopes': [None], 'variables': []}
        else:
            variables_list = args[1]['variables']
            variables_list.append(args[0])
            return {'scopes': [None], 'variables': variables_list}

    def prototype_f(self, args):
        # TODO looks useless
        pass
        # # if prototype returns type
        # if len(args) == 3:
        #     return {
        #         'scopes': [None],
        #         'decl_type': 'prototype',
        #         'type': args[0],
        #         'id': args[1]['value'],
        #         'formals': args[3]['variables']
        #     }
        # # if prototype returns void
        # else:
        #     type_ = {'is_arr': False, 'class': 'primitive', 'type': 'void'}
        #     return {
        #         'scopes': [None],
        #         'type': type_,
        #         'id': args[1]['value'],
        #         'formals': args[3]['variables']
        #     }

    # def prototype_prime_f(self, args):
    #     # TODO does prototype have scope
    #     if len(args) == 0:
    #         return {'scopes': [None], 'prototypes': []}
    #     else:
    #         prototypes = args[1]['prototypes']
    #         prototypes.append(args[0])
    #         return {'scopes': [None], 'prototype': prototypes}

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

    # def stmt_prime_f(self, args):
    #     scopes = get_scopes_of_children(args)
    #     if len(args) == 0:
    #         return {'scopes': [None], 'stmts': []}
    #     else:
    #         stmts = args[1]['stmts']
    #         stmts.append(args[0])
    #         return {'scopes': [None], 'stmts': stmts}

    # def type_int_f(self, args):
    #     return {
    #         'scopes': [None],
    #         'is_arr': False,
    #         'type': 'int',
    #         'class': 'Primitive'
    #     }

    # def type_double_f(self, args):
    #     return {
    #         'scopes': [None],
    #         'is_arr': False,
    #         'type': 'double',
    #         'class': 'Primitive'
    #     }

    # def type_bool_f(self, args):
    #     return {
    #         'scopes': [None],
    #         'is_arr': False,
    #         'type': 'bool',
    #         'class': 'Primitive'
    #     }

    # def type_string_f(self, args):
    #     return {
    #         'scopes': [None],
    #         'is_arr': False,
    #         'type': 'string',
    #         'class': 'Primitive'
    #     }

    # def type_id_f(self, args):
    #     return {
    #         'scopes': [None],
    #         'is_arr': False,
    #         'type': 'Object',
    #         'class': args[0]['value']
    #     }

    # def type_arr_f(self, args):
    #     return {
    #         'scopes': [None],
    #         'is_arr': True,
    #         'type': args[0]['type'],
    #         'class': args[0]['class']
    #     }

    def implements_f(self, args):
        # TODO looks useless
        pass
        # if len(args) == 0:
        #     return {'scopes': [None], 'interfaces': None}
        # else:
        #     ids = args[2]['ids']
        #     ids.append(args[1]['value'])
        #     return {'scopes': [None], 'interfaces': ids}

    def extends_f(self, args):
        # TODO looks useless
        pass
        # # if class extends another class
        # if len(args) == 2:
        #     return {'scopes': [None], 'parent_class': args[1]['value']}
        # # if class doesn't extend any class
        # else:
        #     return {'scopes': [None], 'parent_class': None}

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

    def or_f(self, or_):
        if len(or_['and_list']) == 1:
            return self.and_f(or_['and_list'][0])
        and_ = self.and_f(or_['and_list'][0])
        if not Type.is_bool(and_):
            raise SemErr('operands are not bool')
        for i in range(1, len(or_['and_list'])):
            and_ = orـ['and_list'][i]
            and_ = self.and_f(and_)
            if not Type.is_bool(and_):
                raise SemErr('operands are not bool')
            self.code += 'move $t0, 0($sp)\n'
            self.code += 'move $t1, 4($sp)\n'
            self.code += 'or $t0, $t0, $t1\n'
            self.code += 'addi $sp, $sp, 4'
            self.code += 'sw $t0, 0($sp)'
        return {'is_arr': False, 'type': 'bool', 'class': 'Primitive'}

    def and_f(self, and_):
        if len(and_['eq_neq_list']) == 1:
            return self.eq_neq_f(and_['eq_neq_list'][0])
        eq_neq = self.eq_neq_f(and_['eq_neq_list'][0])
        if not Type.is_bool(eq_neq):
            raise SemErr('operands are not bool')
        for i in range(1, len(and_['eq_neq_list'])):
            eq_neq = and_['eq_neq_list'][i]
            eq_neq = self.eq_neq_f(eq_neq)
            if not Type.is_bool(eq_neq):
                raise SemErr('operands are not bool')
            self.code += 'move $t0, 0($sp)\n'
            self.code += 'move $t1, 4($sp)\n'
            self.code += 'and $t0, $t0, $t1\n'
            self.code += 'addi $sp, $sp, 4\n'
            self.code += 'sw $t0, 0($sp)\n'
        return {'is_arr': False, 'type': 'bool', 'class': 'Primitive'}

    def eq_neq_f(self, eq_neq):
        if len(eq_neq['comp_list']) == 1:
            return self.comp_f(eq_neq['comp_list'][0])
        comp_1 = self.comp_f(eq_neq['comp_list'][0])
        for i in range(1, len(eq_neq['comp_list'])):
            operator = eq_neq['op_list'][i - 1]
            comp_2 = eq_neq['comp_list'][i]
            comp_2 = self.comp_f(comp_2)
            if (Type.is_bool(comp_1)
                    and Type.is_bool(comp_2)) or (Type.is_int(comp_1)
                                                  and Type.is_int(comp_2)):
                if operator == '==':
                    self.code += 'move $t0, 4($sp)\n'
                    self.code += 'move $t1, 0($sp)\n'
                    self.code += 'sub $t0, $t0, $t1\n'
                    self.code += 'slt $t2, $t0, $zero\n'
                    self.code += 'slt $t3, $zero, $t0\n'
                    self.code += 'or $t2, $t2, $t3\n'
                    self.code += 'addi $t3, $zero, 1\n'
                    self.code += 'sub $t2, $t3, $t2\n'
                    self.code += 'addi $sp, $sp, 4\n'
                    self.code += 'sw $t2, 0($sp)\n'
                elif operator == '!=':
                    self.code += 'move $t0, 4($sp)\n'
                    self.code += 'move $t1, 0($sp)\n'
                    self.code += 'sub $t0, $t0, $t1\n'
                    self.code += 'slt $t2, $t0, $zero\n'
                    self.code += 'slt $t3, $zero, $t0\n'
                    self.code += 'or $t2, $t2, $t3\n'
                    self.code += 'addi $sp, $sp, 4\n'
                    self.code += 'sw $t2, 0($sp)\n'
                else:
                    assert 1 == 2
            elif Type.is_double(comp_1) and Type.is_int(comp_2):
                # TODO
                pass
            elif Type.is_string(comp_1) and Type.is_string(comp_2):
                # TODO
                pass
            else:
                raise SemErr('operands are obj or arr')
            comp_1 = comp_2
        return {'is_arr': False, 'type': 'bool', 'class': 'Primitive'}

    def comp_f(self, comp):
        if len(comp['add_sub_list']) == 1:
            return self.add_sub_f(comp['add_sub_list'][0])
        add_sub_1 = self.add_sub_f(comp['add_sub_list'][0])
        for i in range(1, len(comp['add_sub_list'])):
            operator = comp['op_list'][i - 1]
            add_sub_2 = comp['add_sub_list'][i]
            add_sub_2 = self.add_sub_f(comp_2)
            if Type.is_int(add_sub_1) or Type.is_int(add_sub_1):
                if operator == '>':
                    self.code += 'move $t0, 4($sp)\n'
                    self.code += 'move $t1, 0($sp)\n'
                    self.code += 'slt $t0, $t1, $t0\n'
                    self.code += 'addi $sp, $sp, 4\n'
                    self.code += 'sw $t0, 0($sp)\n'
                elif operator == '<':
                    self.code += 'move $t0, 4($sp)\n'
                    self.code += 'move $t1, 0($sp)\n'
                    self.code += 'slt $t0, $t0, $t1\n'
                    self.code += 'addi $sp, $sp, 4\n'
                    self.code += 'sw $t0, 0($sp)\n'
                elif operator == '>=':
                    self.code += 'move $t0, 4($sp)\n'
                    self.code += 'move $t1, 0($sp)\n'
                    self.code += 'slt $t0, $t0, $t1\n'
                    self.code += 'addi $t1, $zero, 1\n'
                    self.code += 'sub $t0, $t1, $t0\n'
                    self.code += 'addi $sp, $sp, 4\n'
                    self.code += 'sw $t0, 0($sp)\n'
                elif operator == '<=':
                    self.code += 'move $t0, 4($sp)\n'
                    self.code += 'move $t1, 0($sp)\n'
                    self.code += 'slt $t0, $t1, $t0\n'
                    self.code += 'addi $t1, $zero, 1\n'
                    self.code += 'sub $t0, $t1, $t0\n'
                    self.code += 'addi $sp, $sp, 4\n'
                    self.code += 'sw $t0, 0($sp)\n'
                else:
                    assert 1 == 2
            elif Type.is_double(comp_1) and Type.is_int(comp_2):
                # TODO
                pass
            else:
                raise SemErr('operands are obj or arr or bool or string')
            comp_1 = comp_2
        return {'is_arr': False, 'type': 'bool', 'class': 'Primitive'}

    def add_sub_f(self, add_sub):
        if len(add_sub['mul_div_mod_list']) == 1:
            return self.mul_div_mod_f(add_sub['mul_div_mod_list'][0])
        mdm_1 = self.mul_div_mod_f(add_sub['mul_div_mod_list'][0])
        for i in range(1, len(add_sub['add_sub_list'])):
            operator = add_sub['op_list'][i - 1]
            mdm_2 = add_sub['mul_div_mode_list'][i]
            mdm_2 = self.mul_div_mod_f(mdm_2)
            if Type.is_int(mdm_1) and Type.is_int(mdm_2):
                if operator == '+':
                    self.code += 'move $t0, 4($sp)\n'
                    self.code += 'move $t1, 0($sp)\n'
                    self.code += 'add $t0, $t0, $t1\n'
                    self.code += 'addi $sp, $sp, 4\n'
                    self.code += 'sw $t0, 0($sp)\n'
                elif operator == '-':
                    self.code += 'move $t0, 4($sp)\n'
                    self.code += 'move $t1, 0($sp)\n'
                    self.code += 'sub $t0, $t0, $t1\n'
                    self.code += 'addi $sp, $sp, 4\n'
                    self.code += 'sw $t0, 0($sp)\n'
            elif Type.is_string(mdm_1) and Type.is_string(mdm_2):
                if operator == '+':
                    # TODO concat strings
                    pass
                elif operator == '-':
                    raise SemErr('sub between strings')
            elif Type.is_double(mdm_1) and Type.is_double(mdm_2):
                if operator == '+':
                    # TODO
                    pass
                elif operator == '-':
                    # TODO
                    pass
            elif Type.is_arr(mdm_1) and Type.is_arr(mdm_2):
                if operator == '+':
                    # TODO append arrs
                    pass
                elif operator == '-':
                    raise SemErr('sub between arrs')
            else:
                raise SemErr('operand types are not correct')
            mdm_1 = mdm_2
        # TODO is returned value correct
        return mdm_1

    def mul_div_mod_f(self, mdm):
        if len(mdm['not_neg_list']) == 1:
            return self.not_neg_f(mdm['not_neg_list'][0])
        not_neg_1 = self.not_neg_f(mdm['not_neq_list'][0])
        for i in range(1, len(mdm['not_neg_list'])):
            operator = mdm['op_list'][i - 1]
            not_neg_2 = mdm['not_neg_list'][i]
            not_neg_2 = self.not_neg_f(not_neg_2)
            if Type.is_int(not_neg_1) and Type.is_int(not_neg_2):
                if operator == '*':
                    # TODO
                    pass
                elif operator == '/':
                    # TODO
                    pass
                elif operator == '%':
                    # TODO
                    pass
            elif Type.is_double(not_neg_1) and Type.is_double(not_neg_2):
                if operator == '*':
                    # TODO
                    pass
                elif operator == '/':
                    # TODO
                    pass
                elif operator == '%':
                    raise SemErr('mod between doubles')
            else:
                raise SemErr('operand types are not correct')
            not_neg_1 = not_neg_2
        # TODO is returned value correct
        return not_neg_1

    def not_neg_f(self, not_neg):
        if len(not_neg['op_list']) == 0:
            return self.others_f(not_neg['others'])
        others = self.others_f(not_neg['others'])
        for i in range(0, len(not_neg['op_list'])):
            operator = not_neg['op_list'][i]
            if Type.is_bool(others):
                if operator == '!':
                    self.code += 'move $t0, 0($sp)\n'
                    self.code += 'addi $t1, $zero, 1\n'
                    self.code += 'sub $t0, $t1, $t0\n'
                    self.code += 'sw $t0, 0($sp)\n'
                elif operator == '-':
                    raise SemErr('- behind bool operand')
            elif Type.is_int(others):
                if operator == '!':
                    raise SemErr('! behind int operand')
                elif operator == '-':
                    self.code += 'move $t0, 0($sp)\n'
                    self.code += 'move $t0, $zero, $t0\n'
                    self.code += 'sw $t0, 0($sp)\n'
            elif Type.is_double(others):
                if operator == '!':
                    raise SemErr('! behind double operand')
                elif operator == '-':
                    # TODO
                    pass
            else:
                raise SemErr('operand types are not correct')
            not_neg_1 = not_neg_2
        # TODO is returned value correct
        return not_neg_1
        # if len(args) == 1:
        #     return {'expr_type': 'not_neg', 'op_list': [], 'others': args[0]}
        # else:
        #     op_list = args[1]['op_list']
        #     op_list.append(args[0].value)
        #     return {
        #         'expr_type': 'not_neg',
        #         'op_list': op_list,
        #         'others': args[1]['others']
        #     }

    def others_f(self, others):
        # TODO new function, it isn't in first traverse. 
        pass

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

    def constant_int_f(self, constant_int):
        self.code += 'addi $sp, $sp, -4'
        self.code += f'move $t0, {constant_int["value"]}'
        self.code += 'sw $t0, 0($sp)'
        return {'is_arr': False, 'type': 'int', 'class': 'Primitive'}
        # return {'scopes': [None], 'type': 'int', 'value': args[0]}

    def constant_double_f(self, args):
        # TODO
        pass
        # return {'scopes': [None], 'type': 'double', 'value': args[0]}

    def constant_bool_f(self, constant_bool):
        self.code += 'addi $sp, $sp, -4'
        if constant_bool['value']:
            self.code += 'addi $t0, $zero, 1'
        else:
            self.code += 'move $t0, $zero'
        self.code += 'sw $t0, 0($sp)'
        return {'is_arr': False, 'type': 'bool', 'class': 'Primitive'}
        # return {'scopes': [None], 'type': 'bool', 'value': args[0]}

    def constant_string_f(self, constant_string):
        self.code += 'addi $sp, $sp, -4'
        label = add_str_const_to_data_sec(constant_string['value'])
        self.code += f'la $t0, {label}'
        self.code += 'sw $t0, 0($sp)'
        return {'is_arr': False, 'type': 'string', 'class': 'Primitive'}
        # return {'scopes': [None], 'type': 'string', 'value': args[0]}

    def constant_null_f(self, args):
        self.code += 'addi $sp, $sp, -4'
        return {'is_arr': False, 'type': 'null', 'class': 'Primitive'}
        # return {'scopes': [None], 'type': 'null', 'value': None}

    def identifier_f(self, identifier):
        decl = Scope.get_decl_with_id(identifier['value'])
        fp_offset = Scope.get_fp_offset_of_variable(identifier['value'])
        self.code += 'addi $sp, $sp, -4'
        self.code += f'lw $t0, {str(fp_offset)}($fp)'
        self.code += 'sw $t0, 0($sp)'
        return decl['type']
        # return {'scopes': [None], 'value': args[0]}
