from lark import Transformer
from SymbolTable import SymbolTable
from Scope import Scope
from SemanticError import SemanticError as SemErr
from Type import Type

# TODO:
# check every thing during type checking, not just types,
#   because a class name might be 'bool' for example and it causes a bug (these are reserved no need to check :) )
# remember to pop 'assign' values from stack
# how to handle output of void function, write in the stack or not?
# remember to deal with scope stack
# fix auto return at the end of functions (it must return something in the stack unless it returns void)

def alert(text):
    print('\033[91m' + str(text) + '\033[0m')
    print('\033[91m' + '---------------------------------------------' +
          '\033[0m')


cur_loop_start_label = None
cur_loop_end_label = None

count_label = 0


def get_label(prefix=''):
    global count_label
    label = ''
    if prefix == '':
        label = f'label{count_label}'
        count_label += 1
    else:
        count_label += 1
        label = f'{prefix}_label{count_label}'
    return label


data_sec_count = 0
runtime_error_msg = None
next_line = None
space = None


def add_str_const_to_data_sec(second_traverse, string: str):
    global data_sec_count
    label = f'str_const_{data_sec_count}'
    second_traverse.data_sec += f'{label}:  .asciiz "{string}"\n'
    data_sec_count += 1
    return label


def add_global_variable_to_data_sec(second_traverse, variable_decl: dict):
    global data_sec_count
    label = f'global_variable_{data_sec_count}'
    second_traverse.data_sec += f'{label}: .word 0\n'
    data_sec_count += 1
    return label


class SecondTraverse():
    def __init__(self, ast):
        global runtime_error_msg, next_line, space
        self.asm_start_label = 'main'  # TODO check that this does not cause any bugs
        self.asm_end_label = 'ASM_END'
        self.main_func_label = None
        self.ast = ast
        self.data_sec = ''
        runtime_error_msg = add_str_const_to_data_sec(self, 'Runtime Error')
        next_line = add_str_const_to_data_sec(self, '\\n')
        space = add_str_const_to_data_sec(self, ' ')
        self.code = ''
        self.program_f(self.ast)
        self.asm_code = '.text\n'
        self.asm_code += f'.globl {self.asm_start_label}\n\n'
        self.asm_code += f'{self.asm_start_label}:\n'
        self.asm_code += 'move $fp, $sp\n'
        self.asm_code += 'addi $sp, $sp, -4\n'
        self.asm_code += 'sw $ra, 0($sp)\n'
        self.asm_code += f'jal {self.main_func_label}\n'
        self.asm_code += 'lw $ra, 0($sp)\n'
        self.asm_code += 'addi $sp, $sp, 4\n'
        self.asm_code += f'jr $ra\n\n'
        self.asm_code += self.code
        # self.asm_code += f'{self.asm_end_label}:\n\n'
        self.asm_code += '.data\n'
        self.asm_code += self.data_sec

    def program_f(self, program):
        cur_scope = program['scopes'][0]
        Scope.scope_stack.append(cur_scope)
        for decl in program['decls']:
            if decl['decl_type'] == 'variable':
                global_var_label = add_global_variable_to_data_sec(self, decl)
                decl['data_sec_label'] = global_var_label
            self.decl_f(decl)
        Scope.scope_stack.pop()

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
        # TODO looks useless because it is predefined in stack and nothing more is needed
        pass
        # return {
        #     'scopes': [None],
        #     'decl_type': 'variable',
        #     'type': args[0]['type'],
        #     'id': args[0]['id']
        # }

    def function_decl_f(self, function_decl):
        cur_scope = function_decl['scopes'][0]
        Scope.scope_stack.append(cur_scope)
        func_label = get_label(function_decl['parent'] + '_' +
                               function_decl['id']['value'])
        if function_decl['parent'] == 'GLOBAL' and function_decl['id'][
                'value'] == 'main':
            self.main_func_label = func_label
        self.code += f'{func_label}:\n'
        # self.code += 'addi $fp, $sp, -4\n' # NOTE do it in call_f
        self.stmt_block_f(function_decl['stmt_block'])
        # TODO any thing else? like fp and ra (looks it is complete)
        self.code += 'jr $ra\n\n'
        Scope.scope_stack.pop()
        # scope = Scope()
        # scope.type = 'function'
        # children_scopes = get_scopes_of_children(args)
        # set_parent_of_children_scope(scope, children_scopes)
        # set_children_of_parent_scope(scope, children_scopes)
        # type_ = None
        # id_ = None
        # formal_variables = None
        # stmt_block = None
        # # if declared function returns type
        # if len(args) == 4:
        #     type_ = args[0]
        #     id_ = args[1]
        #     formal_variables = args[2]['variables']
        #     stmt_block = args[3]
        # # if declared function returns void
        # else:
        #     type_ = {'is_arr': False, 'class': 'primitive', 'type': 'void'}
        #     id_ = args[0]
        #     formal_variables = args[1]['variables']
        #     stmt_block = args[2]
        # fp_offset = 4
        # for variable in formal_variables:
        #     variable['decl_type'] = 'variable'
        #     variable['fp_offset'] = fp_offset
        #     fp_offset += 4
        #     if scope.does_decl_id_exist(variable['id']):
        #         raise SemErr(
        #             f'duplicate id \'{variable["id"]}\' in formals of function \'{args[1]["value"]}\''
        #         )
        # stmt_block['base_fp_offset'] = -8
        # return {
        #     'parent': '_global',
        #     'scopes': [scope],
        #     'decl_type': 'function',
        #     'type': type_,
        #     'id': id_,
        #     'formals': formal_variables,
        #     'stmt_block': stmt_block
        # }

    def interface_decl_f(self, args):
        # TODO looks useless
        pass
        # scope = Scope()
        # children_scopes = get_scopes_of_children(args)
        # set_parent_of_children_scope(scope, children_scopes)
        # set_children_of_parent_scope(scope, children_scopes)
        # for prototype in args[1]['prototypes']:
        #     # TODO is it an error?
        #     if scope.does_decl_id_exist(prototype['id']):
        #         raise SemErr(f'duplicate id for prototypes')
        #     scope.decls[prototype['id']] = prototype
        # return {
        #     'scopes': [scope],
        #     'id': args[0]['value'],
        #     'prototypes': args[1]['prototypes']
        # }

    def class_decl_f(self, class_decl):
        cur_scope = class_decl['scopes'][0]
        Scope.scope_stack.append(cur_scope)
        # TODO
        Scope.scope_stack.pop()
        # scope = Scope()
        # children_scopes = get_scopes_of_children(args)
        # set_parent_of_children_scope(scope, children_scopes)
        # set_children_of_parent_scope(scope, children_scopes)
        # fields = args[3]['fields']
        # for field in fields:
        #     decl = field['declaration']
        #     decl['access_mode'] = field_access_mode
        #     if decl['decl_type'] == 'function':
        #         scope.decls[decl['id']] = decl
        #         decl['scope'].parent = scope
        #     elif decl['decl_type'] == 'variable':
        #         if scope.does_decl_id_exist(decl['id']):
        #             raise SemErr(
        #                 f'duplicate id \'{decl["id"]}\' in class \'{args[0]["value"]}\''
        #             )
        #         scope.decls[decl['id']] = decl
        #     else:
        #         assert 1 == 2  # decl_type must be 'function' or 'variable', but it wasn't
        # return {
        #     'scopes': [scope],
        #     'id': args[0]['value'],
        #     'parent_class': args[1]['parent_class'],
        #     'interfaces': args[2]['interfaces'],
        #     'fields': args[3]['fields']
        # }

    def stmt_block_f(self, stmt_block):
        # TODO any thing more?
        cur_scope = stmt_block['scopes'][0]
        Scope.scope_stack.append(cur_scope)
        fp_offset = 0
        for variable_decl in stmt_block['variable_decls']:
            variable_decl[
                'fp_offset'] = stmt_block['base_fp_offset'] + fp_offset
            fp_offset -= 4
            self.variable_decl_f(variable_decl)
        used_fp_offset = len(stmt_block['variable_decls']) * 4
        self.code += '### pushing space to stack for declared vars ###\n'
        self.code += f'addi $sp, $sp, -{used_fp_offset}\n\n'
        for stmt in stmt_block['stmts']:
            # TODO just 'stmt_type'?
            if stmt['stmt_type'] == 'stmt_block':
                stmt['base_fp_offset'] = stmt_block[
                    'base_fp_offset'] - used_fp_offset
            self.stmt_f(stmt)
        self.code += '### poping declared vars from stack ###\n'
        self.code += f'addi $sp, $sp, {used_fp_offset}\n\n'
        Scope.scope_stack.pop()
        # scope = Scope()
        # children_scopes = get_scopes_of_children(args)
        # set_parent_of_children_scope(scope, children_scopes)
        # set_children_of_parent_scope(scope, children_scopes)
        # for variable_decl in args[0]['variable_decls']:
        #     if scope.does_decl_id_exist(variable_decl['id']):
        #         raise SemErr(
        #             f'duplicate id \'{variable_decl["id"]}\' declared many times as a variable'
        #         )
        #     scope.decls[variable_decl['id']] = variable_decl
        # return {
        #     'scopes': [scope],
        #     'variable_decls': args[0]['variable_decls'],
        #     'stmts': args[1]['stmts']
        # }

    # def stmt_expr_prime_f(self, args):
    #     scopes = get_scopes_of_children(args)
    #     return {'scopes': scopes, 'stmt_type': 'expr_prime', 'stmt': args[0]}

    def stmt_f(self, stmt):
        if stmt['stmt_type'] == 'expr_prime':
            if stmt['stmt'] is not None:
                self.expr_f(stmt['stmt'])
                self.code += '### CLOSING ASSIGN ON NEXT LINE ###\n'
                self.code += 'addi $sp, $sp, 4\n'
                self.code += '\n'
        elif stmt['stmt_type'] == 'stmt_block':
            self.stmt_block_f(stmt['stmt'])
        elif stmt['stmt_type'] == 'for_stmt':
            self.for_stmt_f(stmt)
        elif stmt['stmt_type'] == 'while_stmt':
            self.while_stmt_f(stmt)
        elif stmt['stmt_type'] == 'if_stmt':
            self.if_stmt_f(stmt)
        elif stmt['stmt_type'] == 'print':
            self.print_stmt_f(stmt)
        elif stmt['stmt_type'] == 'return':
            self.return_stmt_f(stmt)
        elif stmt['stmt_type'] == 'break':
            self.break_stmt_f(stmt)
        elif stmt['stmt_type'] == 'continue':
            self.continue_stmt_f(stmt)
        else:
            assert 1 == 2

    def stmt_stmt_block_f(self, args):
        # TODO
        pass
        # scopes = get_scopes_of_children(args)
        # return {'scopes': scopes, 'stmt_type': 'stmt_block', 'stmt': args[0]}

    def if_stmt_f(self, if_stmt):
        cond_false_label = get_label('cond_false')
        end_label = get_label('end_label')
        expr = self.expr_f(if_stmt['condition_expr'])
        # NOTE condition expr must be bool
        if not Type.is_bool(expr):
            raise SemErr('condition expr is not boolean')
        self.code += '#### IF ####\n'
        self.code += 'lw $t0, 0($sp)\n'
        self.code += 'addi $sp, $sp, 4\n'
        self.code += f'beq $t0, $zero, {cond_false_label}\n'
        self.stmt_f(if_stmt['if_stmt'])
        self.code += f'j {end_label}\n'
        self.code += f'{cond_false_label}:\n'
        if if_stmt['else_stmt'] is not None:
            self.stmt_f(if_stmt['else_stmt'])
        self.code += f'{end_label}:\n'
        self.code += '#### END OF IF ####\n'

    def expr_f(self, expr):
        return self.assign_f(expr)

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

    def variable_f(self, args):
        return {'scopes': [None], 'type': args[0], 'id': args[1]['value']}

    def print_stmt_f(self, print_stmt):
        global runtime_error_msg, next_line, space
        self.code += '### PRINT ###\n'
        for expr in print_stmt['exprs']:
            expr_info = self.expr_f(expr)
            # TODO maybe it's needed to calc expr_info['type'] for some cases, if it is, fix it
            type_ = expr_info
            if Type.is_arr(type_):
                raise Exception('expr inside Print is string')
            elif Type.is_object(type_):
                raise Exception('expr inside Print is Object')
            elif Type.is_string(type_):
                self.code += 'lw $t0, 0($sp)\n'
                self.code += 'li $v0, 4\n'
                self.code += 'move $a0, $t0\n'
                self.code += 'syscall\n'
                self.code += 'addi $sp, $sp, 4\n'
            elif Type.is_int(type_):
                self.code += 'lw $t0, 0($sp)\n'
                self.code += 'li $v0, 1\n'
                self.code += 'move $a0, $t0\n'
                self.code += 'syscall\n'
                self.code += 'addi $sp, $sp, 4\n'
            elif Type.is_double(type_):
                # TODO
                pass
            elif Type.is_bool(type_):
                self.code += 'lw $t0, 0($sp)\n'
                self.code += 'li $v0, 1\n'
                self.code += 'move $a0, $t0\n'
                self.code += 'syscall\n'
                self.code += 'addi $sp, $sp, 4\n'
            else:
                assert 1 == 2  # type wasn't correct
            self.code += f'la $a0, {space}\n'
            self.code += 'li $v0, 4\n'
            self.code += 'syscall\n'
        self.code += f'la $a0, {next_line}\n'
        self.code += 'li $v0, 4\n'
        self.code += 'syscall\n'
        self.code += '### END OF PRINT ###\n\n'

    def while_stmt_f(self, while_stmt):
        global cur_loop_start_label, cur_loop_end_label
        start_label = get_label('start')
        end_label = get_label('end')
        cur_loop_start_label = start_label
        cur_loop_end_label = end_label
        self.code += '#### WHILE ####\n'
        self.code += f'{start_label}:\n'
        self.expr_f(while_stmt['condition_expr'])
        self.code += 'lw $t0, 0($sp)\n'
        self.code += 'addi $sp, $sp, 4\n'
        self.code += f'beq $t0, $zero, {end_label}\n'
        # TODO I think I should add 4 to $sp, unless stmt_f does it itself (it seems it does)
        self.stmt_f(while_stmt['stmt'])
        self.code += f'j {start_label}\n'
        self.code += f'{end_label}:\n'
        self.code += '#### END OF WHILE ####\n\n'

    def for_stmt_f(self, for_stmt):
        global cur_loop_start_label, cur_loop_end_label
        start_label = get_label('start')
        end_label = get_label('end')
        cur_loop_start_label = start_label
        cur_loop_end_label = end_label
        self.code += '#### FOR ####\n'
        self.expr_f(for_stmt['init_expr'])
        self.code += 'addi $sp, $sp, 4\n'  # NOTE to remove init_expr result from stack (is it correct?) (looks it is)
        self.code += f'{start_label}:\n'
        self.expr_f(for_stmt['condition_expr'])
        self.code += 'lw $t0, 0($sp)\n'
        self.code += 'addi $sp, $sp, 4\n'
        self.code += f'beq $t0, $zero, {end_label}\n'
        self.stmt_f(for_stmt['stmt'])
        self.expr_f(for_stmt['step_expr'])
        self.code += 'addi $sp, $sp, 4\n'
        self.code += f'j {start_label}\n'
        self.code += f'{end_label}:\n'
        self.code += '#### END OF FOR ####\n\n'

    def return_stmt_f(self, return_stmt):
        # TODO check type of return
        self.code += '### RETURN ###\n'
        if return_stmt['expr'] is None:
            self.code += 'jr $ra\n'
        else:
            self.code += 'lw $t0, 0($sp)\n'
            self.code += 'addi $sp, $sp, 4\n'
            self.code += 'move $v0, $t0\n'
            self.code += 'jr $ra\n'
        self.code += '### END OF RETURN ###\n\n'

    def break_stmt_f(self, break_stmt):
        self.code += '### BREAK ###\n'
        self.code += f'j {cur_loop_end_label}\n'
        self.code += '### END OF BREAK ###\n\n'

    def continue_stmt_f(self, continue_stmt):
        self.code += '### CONTINUE ###\n'
        self.code += f'j {cur_loop_start_label}\n'
        self.code += '### END OF CONTINUE ###\n\n'

    def formals_f(self, args):
        # TODO look useless
        pass
        # scopes = get_scopes_of_children(args)
        # if len(args) == 0:
        #     return {'scopes': [None], 'variables': []}
        # else:
        #     variables_list = args[1]['variables']
        #     variables_list.append(args[0])
        #     return {'scopes': [None], 'variables': variables_list}

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

    def call_f(self, args):
        pass
        # TODO
        # # id()
        # if len(args) == 2:
        #     return {'scopes': [None], 'id': args[0]}
        # # obj.field()
        # else:
        #     return {'scopes': [None], 'obj_id': args}

    def l_value_f(self, l_value, option):
        if l_value['l_value_type'] == 'id':
            return self.l_value_id_f(l_value, option)
        elif l_value['l_value_type'] == 'obj_field':
            return self.l_value_obj_f(l_value, option)
        elif l_value['l_value_type'] == 'array':
            return self.l_value_arr_f(l_value, option)

    def l_value_id_f(self, l_value_id, option):
        id_ = l_value_id['l_value']['value']
        variable_decl = Scope.get_variable_decl_in_symbol_table(id_)
        type_ = variable_decl['type']
        if variable_decl.keys().__contains__('fp_offset'):
            fp_offset = variable_decl['fp_offset']
            if option == 'adrs':
                self.code += f'### LOCAL ID ADRS OF {id_} ###\n'
                self.code += 'move $t0, $fp\n'
                self.code += f'addi $t0, $t0, {fp_offset}\n'
                self.code += 'addi $sp, $sp, -4\n'
                self.code += 'sw $t0, 0($sp)\n'
                self.code += f'### END OF LOCAL ID ADRS OF {id_} ###\n\n'
            elif option == 'value':
                self.code += f'### LOCAL ID VALUE OF {id_} ###\n'
                self.code += 'move $t0, $fp\n'
                self.code += f'addi $t0, $t0, {fp_offset}\n'
                self.code += 'lw $t0, 0($t0)\n'
                self.code += 'addi $sp, $sp, -4\n'
                self.code += 'sw $t0, 0($sp)\n'
                self.code += f'### END OF LOCAL ID VALUE OF {id_} ###\n\n'
            else:
                assert 1==2
            return type_
        elif variable_decl.keys().__contains__['data_sec_label']:
            data_sec_label = variable_decl['data_sec_label']
            if option == 'adrs':
                self.code += f'### GLOB ID ADRS OF {id_} ###\n'
                self.code += f'la $t0, {data_sec_label}\n'
                self.code += 'addi $sp, $sp, -4\n'
                self.code += 'sw $t0, 0($sp)\n'
                self.code += f'### END OF GLOB ID ADRS {id_} ###\n\n'
            elif option == 'value':
                self.code += f'### GLOB ID VALUE OF {id_} ###\n'
                self.code += f'la $t0, {data_sec_label}\n'
                self.code += 'lw $t0, 0($t0)\n'
                self.code += 'addi $sp, $sp, -4\n'
                self.code += 'sw $t0, 0($sp)\n'
                self.code += f'### END OF GLOB ID VALUE {id_} ###\n\n'
            else:
                assert 1==2
            return type_
        else:
            assert 1 == 2
        # return {'scopes': [None], 'l_value_type': 'id', 'l_value': args[0]}

    def l_value_obj_f(self, args):
        # TODO
        pass
        # return {
        #     'scopes': [None],
        #     'l_value_type': 'obj_field',
        #     'obj': args[0],
        #     'obj_field': args[1]
        # }

    def l_value_arr_f(self, args):
        # TODO
        pass
        # return {
        #     'scopes': [None],
        #     'l_value_type': 'array',
        #     'arr_id': args[0],
        #     'index_expr': args[1]
        # }

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

    def field_f(self, args):
        scopes = get_scopes_of_children(args)
        return {
            'scopes': scopes,
            'access_mode': args[0]['value'],
            'declaration': args[1]
        }

    def assign_f(self, assign):
        if assign['expr_type'] == 'assign':
            l_value = self.l_value_f(assign['l_value'], 'adrs')
            r_value = self.assign_f(assign['r_value'])
            self.code += '### ASSIGN ###\n'
            self.code += 'lw $t0, 4($sp)\n'
            self.code += 'lw $t1, 0($sp)\n'
            self.code += 'sw $t1, 0($t0)\n'
            self.code += 'sw $t1, 4($sp)\n'
            self.code += 'addi $sp, $sp, 4\n'
            self.code += '### END OF ASSIGN ###\n\n'
            if not Type.are_types_equal(l_value, r_value):
                raise SemErr('l_value and r_value types are not same')
            return r_value
        else:
            return self.or_f(assign['expr'])
        # if len(args) == 1:
        #     return {'expr_type': args[0]['expr_type'], 'expr': args[0]}
        # else:
        #     return {
        #         'expr_type': 'assign',
        #         'l_value': args[0],
        #         'r_value': args[1]
        #     }

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
            self.code += 'lw $t0, 0($sp)\n'
            self.code += 'lw $t1, 4($sp)\n'
            self.code += 'or $t0, $t0, $t1\n'
            self.code += 'addi $sp, $sp, 4\n'
            self.code += 'sw $t0, 0($sp)\n'
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
            self.code += 'lw $t0, 0($sp)\n'
            self.code += 'lw $t1, 4($sp)\n'
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
                    self.code += 'lw $t0, 4($sp)\n'
                    self.code += 'lw $t1, 0($sp)\n'
                    self.code += 'sub $t0, $t0, $t1\n'
                    self.code += 'slt $t2, $t0, $zero\n'
                    self.code += 'slt $t3, $zero, $t0\n'
                    self.code += 'or $t2, $t2, $t3\n'
                    self.code += 'addi $t3, $zero, 1\n'
                    self.code += 'sub $t2, $t3, $t2\n'
                    self.code += 'addi $sp, $sp, 4\n'
                    self.code += 'sw $t2, 0($sp)\n'
                elif operator == '!=':
                    self.code += 'lw $t0, 4($sp)\n'
                    self.code += 'lw $t1, 0($sp)\n'
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
            add_sub_2 = self.add_sub_f(add_sub_2)
            if Type.is_int(add_sub_1) or Type.is_int(add_sub_1):
                if operator == '>':
                    self.code += '### > ###\n'
                    self.code += 'lw $t0, 4($sp)\n'
                    self.code += 'lw $t1, 0($sp)\n'
                    self.code += 'slt $t0, $t1, $t0\n'
                    self.code += 'addi $sp, $sp, 4\n'
                    self.code += 'sw $t0, 0($sp)\n'
                    self.code += '### END OF > ###\n\n'
                elif operator == '<':
                    self.code += '### < ###\n'
                    self.code += 'lw $t0, 4($sp)\n'
                    self.code += 'lw $t1, 0($sp)\n'
                    self.code += 'slt $t0, $t0, $t1\n'
                    self.code += 'addi $sp, $sp, 4\n'
                    self.code += 'sw $t0, 0($sp)\n'
                    self.code += '### END OF < ###\n\n'
                elif operator == '>=':
                    self.code += '### >= ###\n'
                    self.code += 'lw $t0, 4($sp)\n'
                    self.code += 'lw $t1, 0($sp)\n'
                    self.code += 'slt $t0, $t0, $t1\n'
                    self.code += 'addi $t1, $zero, 1\n'
                    self.code += 'sub $t0, $t1, $t0\n'
                    self.code += 'addi $sp, $sp, 4\n'
                    self.code += 'sw $t0, 0($sp)\n'
                    self.code += '### END OF >= ###\n\n'
                elif operator == '<=':
                    self.code += '### <= ###\n'
                    self.code += 'lw $t0, 4($sp)\n'
                    self.code += 'lw $t1, 0($sp)\n'
                    self.code += 'slt $t0, $t1, $t0\n'
                    self.code += 'addi $t1, $zero, 1\n'
                    self.code += 'sub $t0, $t1, $t0\n'
                    self.code += 'addi $sp, $sp, 4\n'
                    self.code += 'sw $t0, 0($sp)\n'
                    self.code += '### END OF <= ###\n\n'
                else:
                    assert 1 == 2
            elif Type.is_double(comp_1) and Type.is_int(comp_2):
                # TODO
                pass
            else:
                raise SemErr('operands are obj or arr or bool or string')
            add_sub_1 = add_sub_2
        return {'is_arr': False, 'type': 'bool', 'class': 'Primitive'}

    def add_sub_f(self, add_sub):
        if len(add_sub['mul_div_mod_list']) == 1:
            return self.mul_div_mod_f(add_sub['mul_div_mod_list'][0])
        mdm_1 = self.mul_div_mod_f(add_sub['mul_div_mod_list'][0])
        for i in range(1, len(add_sub['mul_div_mod_list'])):
            operator = add_sub['op_list'][i - 1]
            mdm_2 = add_sub['mul_div_mod_list'][i]
            mdm_2 = self.mul_div_mod_f(mdm_2)
            if Type.is_int(mdm_1) and Type.is_int(mdm_2):
                if operator == '+':
                    self.code += '## + ##\n'
                    self.code += 'lw $t0, 4($sp)\n'
                    self.code += 'lw $t1, 0($sp)\n'
                    self.code += 'add $t0, $t0, $t1\n'
                    self.code += 'addi $sp, $sp, 4\n'
                    self.code += 'sw $t0, 0($sp)\n'
                    self.code += '## END OF + ##\n\n'
                elif operator == '-':
                    self.code += '## - ##\n'
                    self.code += 'lw $t0, 4($sp)\n'
                    self.code += 'lw $t1, 0($sp)\n'
                    self.code += 'sub $t0, $t0, $t1\n'
                    self.code += 'addi $sp, $sp, 4\n'
                    self.code += 'sw $t0, 0($sp)\n'
                    self.code += '## END OF - ##\n\n'
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
        not_neg_1 = self.not_neg_f(mdm['not_neg_list'][0])
        for i in range(1, len(mdm['not_neg_list'])):
            operator = mdm['op_list'][i - 1]
            not_neg_2 = mdm['not_neg_list'][i]
            not_neg_2 = self.not_neg_f(not_neg_2)
            if Type.is_int(not_neg_1) and Type.is_int(not_neg_2):
                if operator == '*':
                    self.code += '## * ##\n'
                    self.code += 'lw $t0, 4($sp)\n'
                    self.code += 'lw $t1, 0($sp)\n'
                    self.code += 'mul $t0, $t0, $t1\n'
                    self.code += 'addi $sp, $sp, 4\n'
                    self.code += 'sw $t0, 0($sp)\n'
                    self.code += '## END OF * ##\n\n'
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
                    self.code += 'lw $t0, 0($sp)\n'
                    self.code += 'addi $t1, $zero, 1\n'
                    self.code += 'sub $t0, $t1, $t0\n'
                    self.code += 'sw $t0, 0($sp)\n'
                elif operator == '-':
                    raise SemErr('- behind bool operand')
            elif Type.is_int(others):
                if operator == '!':
                    raise SemErr('! behind int operand')
                elif operator == '-':
                    self.code += 'lw $t0, 0($sp)\n'
                    self.code += 'lw $t0, $zero, $t0\n'
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

    def others_f(self, others):
        # NOTE new function, it isn't in first traverse.
        if others['expr_type'] == 'constant':
            if others['type'] == 'int':
                return self.constant_int_f(others)
            elif others['type'] == 'double':
                return self.constant_double_f(others)
            elif others['type'] == 'bool':
                return self.constant_bool_f(others)
            elif others['type'] == 'string':
                return self.constant_string_f(others)
            elif others['type'] == 'null':
                return self.constant_null_f(others)
            else:
                assert 1 == 2
        elif others['expr_type'] == 'this':
            # 'this' is stored at $fp - 4 in the stack, because it's the first param of function
            self.code += 'move $t0, $fp\n'
            self.code += 'addi $t0, $t0, 4\n'
            self.code += 'addi $sp, $sp, -4\n'
            self.code += 'sw $t0, 0($sp)\n'
            # TODO return type of the obj 'this' is refering to
            return {}
        elif others['expr_type'] == 'lvalue':
            return self.l_value_f(others, 'value')
        elif others['expr_type'] == 'call':
            # TODO
            pass
        elif others['expr_type'] == '(expr)':
            del others['expr_type']
            return others
        elif others['expr_type'] == 'read_int':
            # TODO
            pass
        elif others['expr_type'] == 'read_line':
            # TODO
            pass
        elif others['expr_type'] == 'new_id':
            # TODO
            pass
        elif others['expr_type'] == 'new_arr':
            del others['expr_type']
            size = others['size']
            if not Type.is_int(size):
                raise SemErr('arr size cant be non-int')
            type_ = others['type']
            if Type.is_void(type_):
                raise SemErr('arr type cant be void')
            arr_size_ok_label = get_label('arr_size_ok')
            self.code += 'lw $t0, 0($sp)\n'
            self.code += f'bgt $t0, 0, {arr_size_ok_label}\n'
            self.code += f'la $a0, {runtime_error_msg}\n'
            self.code += 'li $v0, 4\n'
            self.code += 'syscall\n'
            self.code += f'j {end_label}\n'
            self.code += f'{arr_size_ok_label}:\n'
            self.code += 'move $t1, $t0\n'
            self.code += 'sll $t0, $t0, 2\n'
            self.code += 'addi $t0, $t0, 4\n'
            self.code += 'move $a0, $t0\n'
            self.code += 'li $v0, 9\n'
            self.code += 'syscall\n'
            self.code += 'sw $v0, 0($sp)\n'
            self.code += 'sw $t1, 0($v0)\n'
        elif others['expr_type'] == 'itod':
            # TODO
            pass
        elif others['expr_type'] == 'dtoi':
            # TODO
            pass
        elif others['expr_type'] == 'itob':
            # TODO
            pass
        elif others['expr_type'] == 'btoi':
            # TODO
            pass
        else:
            assert 1 == 2

    def constant_int_f(self, constant_int):
        value = constant_int['value']
        self.code += f'### CONSTANT INT {value} ###\n'
        self.code += 'addi $sp, $sp, -4\n'
        self.code += f'li $t0, {value}\n'
        self.code += 'sw $t0, 0($sp)\n'
        self.code += f'### END OF CONSTANT INT {value} ###\n\n'
        return {'is_arr': False, 'type': 'int', 'class': 'Primitive'}

    def constant_double_f(self, args):
        # TODO
        pass
        # return {'scopes': [None], 'type': 'double', 'value': args[0]}

    def constant_bool_f(self, constant_bool):
        value = constant_bool['value']
        self.code += f'\n### CONSTANT BOOL {value} ###\n'
        self.code += 'addi $sp, $sp, -4\n'
        if constant_bool['value']:
            self.code += 'addi $t0, $zero, 1\n'
        else:
            self.code += 'move $t0, $zero\n'
        self.code += 'sw $t0, 0($sp)\n'
        self.code += f'### END OF CONSTANT BOOL {value} ###\n\n'
        return {'is_arr': False, 'type': 'bool', 'class': 'Primitive'}

    def constant_string_f(self, constant_string):
        alert(constant_string)
        string_value = constant_string['value'][1:-1]
        self.code += f'\n### CONSTANT STRING {string_value} ###\n'
        self.code += 'addi $sp, $sp, -4\n'
        label = add_str_const_to_data_sec(self, string_value)
        self.code += f'la $t0, {label}\n'
        self.code += 'sw $t0, 0($sp)\n'
        self.code += f'### END OF CONSTANT STRING {string_value} ###\n\n'
        return {'is_arr': False, 'type': 'string', 'class': 'Primitive'}

    def constant_null_f(self, args):
        self.code += '\n### NULL ###\n'
        self.code += 'addi $sp, $sp, -4\n'
        self.code += '### END OF NULL ###\n\n'
        return {'is_arr': False, 'type': 'null', 'class': 'Primitive'}

    def identifier_f(self, identifier):
        id_ = identifier['value']
        decl = Scope.get_decl_with_id(id_)
        fp_offset = Scope.get_fp_offset_of_variable(id_)
        self.code += f'\n### ID {id_} ###\n'
        self.code += 'addi $sp, $sp, -4\n'
        self.code += f'lw $t0, {str(fp_offset)}($fp)\n'
        self.code += 'sw $t0, 0($sp)\n'
        self.code += f'### END OF ID {id_} ###\n\n'
        return decl['type']
