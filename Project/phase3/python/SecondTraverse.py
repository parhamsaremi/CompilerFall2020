from lark import Transformer
from Scope import Scope
from SemanticError import SemanticError as SemErr
from Type import Type
from Class import Class

# TODO:
# remember to deal with scope stack
# fix auto return at the end of functions (it must return something in the stack unless it returns void)
# func label must be defined at the start, otherwise func calls might not be able to jal to desired label
# classes can be upcasted in func calls and assignments, they don't always have same type. handle this.
# continue, break and maybe return might have bug, becuase they don't pop declared vars of inner scopes.


def alert(text):
    print('\033[91m' + str(text) + '\033[0m')
    print('\033[91m' + '---------------------------------------------' +
          '\033[0m')


cur_loop_start_label_stack = []
cur_loop_end_label_stack = []
base_fp_offset_stack = []

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


runtime_error_msg = None
index_less_zero_error_msg = None
index_more_size_error_msg = None
arr_size_neg_error_msg = None
next_line = None
space = None
true_str = None
false_str = None
input_buffer = None

cur_function_decl = None

data_sec_count = 0


def add_str_const_to_data_sec(second_traverse, string: str):
    global data_sec_count
    label = f'str_const_{data_sec_count}'
    second_traverse.data_sec += f'{label}:  .asciiz "{string}"\n'
    data_sec_count += 1
    return label


space_count = 0


def add_space_to_data_sec(second_traverse, size: int):
    global space_count
    label = f'space_{space_count}'
    second_traverse.data_sec += f'{label}: .space {size}\n'
    space_count += 1
    return label


def add_global_variable_to_data_sec(second_traverse, variable_decl: dict):
    global data_sec_count
    label = f'global_variable_{data_sec_count}'
    second_traverse.data_sec += f'{label}: .word 0\n'
    data_sec_count += 1
    return label


class SecondTraverse():
    def __init__(self, ast):
        global runtime_error_msg, index_less_zero_error_msg, index_more_size_error_msg \
            , arr_size_neg_error_msg, next_line, space, true_str, false_str, input_buffer
        self.asm_start_label = 'main'  # TODO check that this does not cause any bugs
        self.asm_end_label = 'ASM_END'
        self.main_func_label = None
        self.ast = ast
        input_buffer = 'input_buffer__'
        self.data_sec = ''
        self.data_sec += f'{input_buffer}: .space 1000\n'
        input_buffer = add_str_const_to_data_sec(self, '')
        runtime_error_msg = add_str_const_to_data_sec(self, 'Runtime Error')
        index_less_zero_error_msg = add_str_const_to_data_sec(
            self, 'array index is less than zero')
        index_more_size_error_msg = add_str_const_to_data_sec(
            self, 'array index is more than arr.size-1')
        arr_size_neg_error_msg = add_str_const_to_data_sec(
            self, 'array size can\'t be negative')
        next_line = add_str_const_to_data_sec(self, '\\n')
        space = add_str_const_to_data_sec(self, ' ')
        true_str = add_str_const_to_data_sec(self, 'true')
        false_str = add_str_const_to_data_sec(self, 'false')
        self.code = ''
        self.class_code = ''
        self.program_f(self.ast)
        self.asm_code = '.text\n'
        self.asm_code += f'.globl {self.asm_start_label}\n\n'
        self.asm_code += f'{self.asm_start_label}:\n\n'
        self.asm_code += self.class_code
        self.asm_code += 'move $fp, $sp\n'
        self.asm_code += 'move $s0, $ra\n'  # save exiting #ra in $s0 for runtime error handling
        self.asm_code += 'addi $sp, $sp, -4\n'
        self.asm_code += 'sw $ra, 0($sp)\n'
        self.asm_code += f'jal {self.main_func_label}\n'
        self.asm_code += 'addi $sp, $sp, 4\n'
        self.asm_code += 'lw $ra, 0($sp)\n'
        self.asm_code += 'addi $sp, $sp, 4\n'
        self.asm_code += f'jr $ra\n\n'
        self.asm_code += self.code
        with open('mips_helper_functions/itob.s', 'r') as itob_s:
            code = itob_s.read()
            self.asm_code += code
        self.asm_code += '.data\n'
        self.asm_code += self.data_sec

    def program_f(self, program):
        cur_scope = program['scopes'][0]
        Scope.scope_stack.append(cur_scope)

        # setting starting labels of class functions
        for class_decl in Scope.get_classes():
            for func_decl in Scope.get_functions_of_class(class_decl['id']):
                func_label = get_label(class_decl['id'] + '_' +
                                       func_decl['id'])
                func_decl['func_label'] = func_label

        # classes
        for class_decl in Scope.get_classes():
            id_ = class_decl['id']
            class_ = Class(class_decl)
            obj_layout_heap_space = 0
            Class.classes[id_] = class_
            class_.object_layout['_main_vptr'] = {'offset': 0}
            obj_layout_heap_space += 4
            class_chain = []
            parent = id_
            while parent is not None:
                class_chain.append(parent)
                parent = Scope.get_parent_of_class(parent)
            class_chain = class_chain[::-1]

            # TODO copy dictionaries where a decl may be used in many situations, like prototypes of interfaces
            # function fields
            offset = 0
            for class_id in class_chain:
                for func_field in Class.get_function_fields(
                        Class.get_class(class_id)):
                    func_field = func_field
                    if class_.main_vtable.keys().__contains__(
                        (func_field['id'], 'function')):
                        pass
                    else:
                        offset += 4
                        func_field.update({'offset': offset})
                    # TODO can add other stuff too, like function label
                    class_.main_vtable[(func_field['id'],
                                        'function')] = func_field
            main_vtable_heap_label = add_space_to_data_sec(self, offset + 4)
            class_.object_layout['_main_vptr'][
                'heap_label'] = main_vtable_heap_label

            # variable fields
            offset = 0
            for class_id in class_chain:
                for var_field in Class.get_variable_fields(
                        Class.get_class(class_id)):
                    var_field = var_field.copy()
                    if class_.object_layout.keys().__contains__(
                        (var_field['id'], 'variable')):
                        pass
                    else:
                        offset += 4
                        var_field.update({'offset': offset})
                    # TODO can add other stuff too
                    class_.object_layout[(var_field['id'],
                                          'variable')] = var_field

            # interfaces
            for interface_id in class_.decl['interfaces']:
                interface_decl = Scope.get_interface(interface_id)
                interface_class_vtable = {}
                class_.object_layout[(interface_id,
                                      'interface')] = interface_class_vtable
                offset += 4
                interface_class_vtable['_this_offset'] = offset
                vtable_offset = 0
                for prototype_decl in interface_decl['prototypes']:
                    prototype_id = prototype_decl['id']
                    prototype_decl = prototype_decl.copy()
                    prototype_decl.update({'_offset': vtable_offset})
                    vtable_offset += 4
                    interface_class_vtable[(prototype_id,
                                            'function')] = prototype_decl
                    # TODO can add other stuff too
            class_.object_layout['heap_size'] = offset + 4

        # global functions
        for function_decl in Scope.get_global_functions():
            id_ = function_decl['id']
            func_label = get_label(function_decl['parent'] + '_' + id_)
            function_decl['func_label'] = func_label

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

    def function_decl_f(self, function_decl):
        global cur_function_decl, base_fp_offset_stack
        cur_function_decl = function_decl
        cur_scope = function_decl['scopes'][0]
        Scope.scope_stack.append(cur_scope)
        base_fp_offset_stack.append(-8)
        id_ = function_decl['id']
        func_label = function_decl['func_label']
        function_decl['func_label'] = func_label
        if function_decl['parent'] == 'GLOBAL' and id_ == 'main':
            self.main_func_label = func_label
        formals_count = len(function_decl['formals'])
        self.code += f'{func_label}:\n'
        self.stmt_block_f(function_decl['stmt_block'])
        self.code += f'### auto return of func {id_} ###\n'
        self.code += 'addi $sp, $sp, -4\n'
        self.code += 'li $t0, -1000\n'
        self.code += 'sw $t0, 0($sp)\n'
        self.code += f'### end of auto return of func {id_} ###\n\n'
        self.code += 'jr $ra\n\n'
        base_fp_offset_stack.pop()
        Scope.scope_stack.pop()

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

    def variable_decl_f(self, args):
        pass
        # TODO looks it is useless, but becareful that it is used is some places

    def stmt_block_f(self, stmt_block):
        # TODO any thing more?
        global base_fp_offset_stack
        base_fp_offset = base_fp_offset_stack[-1]
        cur_scope = stmt_block['scopes'][0]
        Scope.scope_stack.append(cur_scope)
        fp_offset = 0
        for variable_decl in stmt_block['variable_decls']:
            variable_decl['fp_offset'] = base_fp_offset + fp_offset
            fp_offset -= 4
            self.variable_decl_f(variable_decl)
        base_fp_offset_stack.append(base_fp_offset + fp_offset)
        self.code += '### pushing space to stack for declared vars ###\n'
        self.code += f'addi $sp, $sp, {fp_offset}\n\n'
        for stmt in stmt_block['stmts']:
            # TODO just 'stmt_type'?
            self.stmt_f(stmt)
        self.code += '### popping declared vars from stack ###\n'
        self.code += f'addi $sp, $sp, {-fp_offset}\n\n'
        base_fp_offset_stack.pop()
        Scope.scope_stack.pop()

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
        elif stmt['stmt_type'] == 'if_else':
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

    def if_stmt_f(self, if_stmt):
        cond_false_label = get_label('cond_false')
        end_label = get_label('end_label')
        expr = self.expr_f(if_stmt['condition_expr'])
        # # NOTE condition expr must be bool
        # if not Type.is_bool(expr):
        #     raise SemErr('condition expr is not boolean')
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
        if expr is None:
            return None
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
                raise Exception('expr inside Print is array')
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
                self.code += 'l.s $f12, 0($sp)\n'
                self.code += 'li $v0, 2\n'
                self.code += 'syscall\n'
                self.code += 'addi $sp, $sp, 4\n'
            elif Type.is_bool(type_):
                global true_str, false_str
                false_label = get_label('print_false')
                end_label = get_label('print_end')
                self.code += 'lw $t0, 0($sp)\n'
                self.code += f'beq $t0, $zero, {false_label}\n'
                self.code += f'la $a0, {true_str}\n'
                self.code += 'li $v0, 4\n'
                self.code += 'syscall\n'
                self.code += f'j {end_label}\n'
                self.code += f'{false_label}:\n'
                self.code += f'la $a0, {false_str}\n'
                self.code += 'li $v0, 4\n'
                self.code += 'syscall\n'
                self.code += f'{end_label}:\n'
                self.code += 'addi $sp, $sp, 4\n'
            else:
                assert 1 == 2  # type wasn't correct
            # TODO space was printed here before ...
        self.code += f'la $a0, {next_line}\n'
        self.code += 'li $v0, 4\n'
        self.code += 'syscall\n'
        self.code += '### END OF PRINT ###\n\n'

    def while_stmt_f(self, while_stmt):
        global cur_loop_start_label_stack, cur_loop_end_label_stack
        start_label = get_label('start')
        end_label = get_label('end')
        cur_loop_start_label_stack.append(start_label)
        cur_loop_end_label_stack.append(end_label)
        self.code += '#### WHILE ####\n'
        self.code += f'{start_label}:\n'
        self.expr_f(while_stmt['condition_expr'])
        self.code += 'lw $t0, 0($sp)\n'
        self.code += 'addi $sp, $sp, 4\n'
        self.code += f'beq $t0, $zero, {end_label}\n'
        self.stmt_f(while_stmt['stmt'])
        self.code += f'j {start_label}\n'
        self.code += f'{end_label}:\n'
        self.code += '#### END OF WHILE ####\n\n'
        cur_loop_start_label_stack.pop()
        cur_loop_end_label_stack.pop()

    def for_stmt_f(self, for_stmt):
        global cur_loop_start_label_stack, cur_loop_end_label_stack
        start_label = get_label('start')
        end_label = get_label('end')
        cur_loop_start_label_stack.append(start_label)
        cur_loop_end_label_stack.append(end_label)
        self.code += '#### FOR ####\n'
        init_expr = self.expr_f(for_stmt['init_expr'])
        if init_expr is not None:
            self.code += 'addi $sp, $sp, 4\n'  # to remove init_expr result from stack
        self.code += f'{start_label}:\n'
        self.expr_f(for_stmt['condition_expr'])
        self.code += 'lw $t0, 0($sp)\n'
        self.code += 'addi $sp, $sp, 4\n'
        self.code += f'beq $t0, $zero, {end_label}\n'
        self.stmt_f(for_stmt['stmt'])
        step_expr = self.expr_f(for_stmt['step_expr'])
        if step_expr is not None:
            self.code += 'addi $sp, $sp, 4\n'
        self.code += f'j {start_label}\n'
        self.code += f'{end_label}:\n'
        self.code += '#### END OF FOR ####\n\n'
        cur_loop_start_label_stack.pop()
        cur_loop_end_label_stack.pop()

    def return_stmt_f(self, return_stmt):
        # TODO check type of return
        global cur_function_decl
        self.code += '### RETURN ###\n'
        if return_stmt['expr'] is None:
            if not Type.is_void(cur_function_decl['type']):
                raise SemErr('returning void but function type is not void')
            self.code += 'jr $ra\n'
        else:
            expr_type = self.expr_f(return_stmt['expr'])
            if not Type.are_types_equal(cur_function_decl['type'], expr_type):
                raise SemErr(
                    'returned value type is not compatible with function type')
            self.code += 'lw $t0, 0($sp)\n'
            self.code += 'addi $sp, $fp, -8\n'  # place of returned value
            self.code += 'sw $t0, 0($sp)\n'
            self.code += 'jr $ra\n'
        self.code += '### END OF RETURN ###\n\n'

    def break_stmt_f(self, break_stmt):
        global cur_loop_end_label_stack
        cur_loop_end_label = cur_loop_end_label_stack[-1]
        self.code += '### BREAK ###\n'
        self.code += f'j {cur_loop_end_label}\n'
        self.code += '### END OF BREAK ###\n\n'

    def continue_stmt_f(self, continue_stmt):
        global cur_loop_start_label_stack
        cur_loop_start_label = cur_loop_start_label_stack[-1]
        self.code += '### CONTINUE ###\n'
        self.code += f'j {cur_loop_start_label}\n'
        self.code += '### END OF CONTINUE ###\n\n'

    def call_f(self, call):
        if call.keys().__contains__('id'):
            id_ = call['id']
            function_decl = Scope.get_decl_in_symbol_table(id_, 'function')
            if function_decl is None:
                raise SemErr('function not declared')
            self.code += f'#### func call {id_} ####\n'
            actual_count = len(call['actuals']['exprs'])
            formal_count = len(function_decl['formals'])
            if actual_count != formal_count:
                raise SemErr(
                    'actual count and formals count not equal in function call'
                )
            for i in range(len(call['actuals']['exprs']) - 1, -1, -1):
                actual_type = self.expr_f(call['actuals']['exprs'][i])
                formal_type = function_decl['formals'][i]['type']
                if not Type.are_types_assignable(
                        actual_type,
                        formal_type):  # TODO this has to handle upcasting too
                    raise SemErr('formal and actual types are not same')
            self.code += 'addi $sp, $sp, -4\n'
            self.code += 'sw $fp, 0($sp)\n'
            self.code += 'addi $sp, $sp, -4\n'
            self.code += 'sw $ra, 0($sp)\n'
            self.code += 'addi $fp, $sp, 4\n'
            self.code += f'jal {function_decl["func_label"]}\n'
            self.code += 'lw $fp, 8($sp)\n'
            self.code += 'lw $ra, 4($sp)\n'
            self.code += 'lw $t0, 0($sp)\n'
            self.code += f'sw $t0, {actual_count * 4 + 8}($sp)\n'
            self.code += f'addi $sp, $sp, {actual_count * 4 + 8}\n'
            self.code += f'#### end of func call {id_} ####\n\n'
            return function_decl['type']
        # obj.field()
        else:
            obj_field = self.others_f(call['others'])
            field_id = call['field']['value']
            if Type.is_arr(obj_field):
                if not field_id == 'length':
                    raise SemErr('array type only supports "length" function')
                self.code += 'lw $t0, 0($sp)\n'
                self.code += 'addi $s0, $s0, 4\n'  # popping 'others' value from stack
                self.code += 'lw $t0, 0($t0)\n'
                self.code += 'sw $t0, 0($sp)\n'
                return {'dim': 0, 'type': 'int', 'class': 'Primitive'}
            else:
                others_type = self.others_f(call['others'])
                if not Type.is_object(others_type):
                    raise SemErr('calling field func of non-object type')
                func_info = Class.get_func_info(others_type['class'], field_id)
                vptr_offset = func_info['vptr_offset']
                func_offset = func_info['func_offset']
                self.code += '#### OBJ FUNC CALL ####\n'
                actual_count = len(call['actuals']['exprs']) + 1
                formal_count = len(func_info['formals'])
                if actual_count != formal_count:
                    raise SemErr(
                        'actual count and formal count not equal in obj.func call'
                    )
                for i in range(len(call['actuals']['exprs']) - 1, -1, -1):
                    actual_type = self.expr_f(call['actuals']['exprs'][i])
                    formal_type = func_info['formals'][i]['type']
                    alert(actual_type)
                    alert(formal_type)
                    if not Type.are_types_assignable(actual_type, formal_type):
                        raise SemErr('formal and actual types are not same')
                self.code += 'lw $t0, 0($sp)\n'
                self.code += 'move $t1, t0\n'
                self.code += f'addi $t1, $t1, {vptr_offset}\n'
                self.code += 'lw $t1, 0($t1)\n'
                self.code += 'lw $t2, 0($t1)\n'  # loading delta to $t2
                self.code += 'addi $t0, $t0, $t2\n'  # adding delta to $t0 ('this' pointer)
                self.code += 'addi $sp, $sp, -4\n'
                self.code += 'sw $t0, 0($sp)\n'  # pushing 'this' to stack
                self.code += f'addi $t1, $t1, {func_offset}\n'
                self.code += 'lw $t1, 0($t1)\n'  # func label adrs in $t1
                self.code += 'addi $sp, $sp, -4\n'
                self.code += 'sw $fp, 0($sp)\n'
                self.code += 'addi $sp, $sp, -4\n'
                self.code += 'sw $ra, 0($sp)\n'
                self.code += 'addi $fp, $sp, 4\n'
                self.code += 'jr $t1\n'
                return_label = get_label('return')
                self.code += f'{return_label}:\n'
                self.code += 'lw $fp, 8($sp)\n'
                self.code += 'lw $ra, 4($sp)\n'
                self.code += 'lw $t0, 0($sp)\n'
                self.code += f'sw $t0, {actual_count * 4 + 8}($sp)\n'
                self.code += f'addi $sp, $sp, {actual_count * 4 + 8}\n'
                self.code += '#### END OF OBJ FUNC CALL ####\n\n'

    def l_value_f(self, l_value, option):
        if l_value['l_value_type'] == 'id':
            return self.l_value_id_f(l_value, option)
        elif l_value['l_value_type'] == 'obj_field':
            return self.l_value_obj_f(l_value, option)
        elif l_value['l_value_type'] == 'array':
            return self.l_value_arr_f(l_value, option)

    def l_value_id_f(self, l_value_id, option):
        id_ = l_value_id['l_value']['value']
        variable_decl = Scope.get_decl_in_symbol_table(id_, 'variable')
        if variable_decl is None:
            raise SemErr(f'variable "{id_}" not found')
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
                assert 1 == 2
            return type_
        elif variable_decl.keys().__contains__('data_sec_label'):
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
                assert 1 == 2
            return type_
        else:
            assert 1 == 2

    def l_value_obj_f(self, l_value_obj, option):
        obj_others_type = self.others_f(l_value_obj['obj_others'])
        if not Type.is_object(obj_others_type):
            raise SemErr('pinter is not object type')
        class_id = obj_others_type['class']
        field_id = l_value_obj['obj_field_id']['value']
        var_field_info = Class.get_var_field(class_id, field_id)
        if var_field_info is None:
            raise SemErr(f'field \'{field_id}\'is not accessible or declared')
        if option == 'adrs':
            self.code += '### OBJ FIELD ADRS ###\n'
        elif option == 'value':
            self.code += '### OBJ FIELD VALUE ###\n'
        self.code += 'lw $t0, 0($sp)\n'
        self.code += f'addi $t0, $t0, {var_field_info["offset"]}\n'
        if option == 'value':
            self.code += 'lw $t0, 0($t0)\n'
        self.code += 'sw $t0, 0($sp)\n'
        if option == 'adrs':
            self.code += '### OBJ FIELD ADRS ###\n'
        elif option == 'value':
            self.code += '### OBJ FIELD VALUE ###\n'
        return var_field_info['type']

    def l_value_arr_f(self, l_value_arr, option):
        global index_less_zero_error_msg, index_more_size_error_msg, runtime_error_msg
        arr_type = self.others_f(l_value_arr['arr'])  # calc arr expr
        index_type = self.expr_f(l_value_arr['index_expr'])  # calc index expr
        if not Type.is_arr(arr_type):
            raise SemErr('indexed variable is not array')
        if not Type.is_int(index_type):
            raise SemErr('index type is not int')
        index_less_zero = get_label('index_less_zero')
        index_more_size = get_label('index_more_size')
        no_runtime_error = get_label('no_runtime_error')
        if option == 'adrs':
            self.code += f'### LOCAL ARR ADRS ###\n'
        elif option == 'value':
            self.code += f'### LOCAL ARR VALUE OF ###\n'
        self.code += 'lw $t0, 4($sp)\n'  # arr.size adrs
        self.code += 'lw $t1, 0($t0)\n'  # arr.size value
        self.code += 'lw $t2, 0($sp)\n'  # expr value
        self.code += f'blt $t2, $zero, {index_less_zero}\n'
        self.code += f'bge $t2, $t1, {index_more_size}\n'
        self.code += 'addi $t2, $t2, 1\n'
        self.code += 'sll $t2, $t2, 2\n'
        self.code += 'add $t0, $t0, $t2\n'
        if option == 'value':
            self.code += 'lw $t0, 0($t0)\n'
        self.code += 'addi $sp, $sp, 4\n'
        self.code += 'sw $t0, 0($sp)\n'
        self.code += f'j {no_runtime_error}\n'
        self.code += f'{index_less_zero}:\n'
        self.code += f'la $a0, {runtime_error_msg}\n'
        self.code += 'li $v0, 4\n'
        self.code += 'syscall\n'
        self.code += 'move $ra, $s0\n'
        self.code += 'jr $ra\n'
        self.code += f'{index_more_size}:\n'
        self.code += f'la $a0, {runtime_error_msg}\n'
        self.code += 'li $v0, 4\n'
        self.code += 'syscall\n'
        self.code += 'move $ra, $s0\n'
        self.code += 'jr $ra\n'
        self.code += f'{no_runtime_error}:\n'
        if option == 'adrs':
            self.code += f'### END OF LOCAL ARR ADRS ###\n'
        elif option == 'value':
            self.code += f'### END OF LOCAL ARR VALUE ###\n'
        return {
            'dim': arr_type['dim'] - 1,
            'type': arr_type['type'],
            'class': arr_type['class']
        }

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
            if not Type.are_types_assignable(l_value, r_value):
                raise SemErr('l_value and r_value types are not assignable')
            return r_value
        else:
            return self.or_f(assign['expr'])

    def or_f(self, or_):
        if len(or_['and_list']) == 1:
            return self.and_f(or_['and_list'][0])
        and_ = self.and_f(or_['and_list'][0])
        if not Type.is_bool(and_):
            raise SemErr('operands are not bool')
        for i in range(1, len(or_['and_list'])):
            and_ = or_['and_list'][i]
            and_ = self.and_f(and_)
            if not Type.is_bool(and_):
                raise SemErr('operands are not bool')
            self.code += 'lw $t0, 0($sp)\n'
            self.code += 'lw $t1, 4($sp)\n'
            self.code += 'or $t0, $t0, $t1\n'
            self.code += 'addi $sp, $sp, 4\n'
            self.code += 'sw $t0, 0($sp)\n'
        return {'dim': 0, 'type': 'bool', 'class': 'Primitive'}

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
        return {'dim': 0, 'type': 'bool', 'class': 'Primitive'}

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
            elif Type.is_double(comp_1) and Type.is_double(comp_2):
                # TODO
                if operator == '==':
                    eq_label = get_label("eq")
                    end_label = get_label("neq")
                    self.code += '### Starting calculation for double equality ###\n'
                    self.code += 'l.s $f0, 4($sp)\n'
                    self.code += 'l.s $f1, 0($sp)\n'
                    self.code += 'c.eq.s $f0, $f1\n'
                    self.code += f'bc1t {eq_label}\n'
                    self.code += 'li $t0, 0\n'
                    self.code += 'add $sp,$sp,4\n'
                    self.code += 'sw $t0, 0($sp)\n'
                    self.code += f'j {end_label}\n'
                    self.code += f'{eq_label}:\n'
                    self.code += 'li $t0, 1\n'
                    self.code += 'add $sp,$sp,4\n'
                    self.code += 'sw $t0, 0($sp)\n'
                    self.code += f'{end_label}:\n'
                elif operator == '!=':
                    eq_label = get_label("eq")
                    end_label = get_label("neq")
                    self.code += '### Starting calculation for double non-equality\n'
                    self.code += 'l.s $f0, 4($sp)\n'
                    self.code += 'l.s $f1, 0($sp)\n'
                    self.code += 'c.eq.s $f0, $f1\n'
                    self.code += f'bc1t {eq_label}\n'
                    self.code += 'li $t0, 1\n'
                    self.code += 'add $sp,$sp,4\n'
                    self.code += 'sw $t0, 0($sp)\n'
                    self.code += f'j {end_label}\n'
                    self.code += f'{eq_label}:\n'
                    self.code += 'li $t0, 0\n'
                    self.code += 'add $sp,$sp,4\n'
                    self.code += 'sw $t0, 0($sp)\n'
                    self.code += f'{end_label}:\n'
                else:
                    assert 1 == 2
            elif Type.is_string(comp_1) and Type.is_string(comp_2):
                # TODO
                if operator == '==':
                    pass
                elif operator == '!=':
                    pass
                else:
                    assert 1 == 2
            else:
                raise SemErr('operands\' types are not correct')
            comp_1 = comp_2
        return {'dim': 0, 'type': 'bool', 'class': 'Primitive'}

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
            elif Type.is_double(add_sub_1) and Type.is_double(add_sub_1):
                if operator == '>':
                    false_label = get_label('false_label')
                    end_label = get_label('end_label')
                    self.code += 'l.s $f0, 4($sp)\n'
                    self.code += 'l.s $f1, 0($sp)\n'
                    self.code += 'addi $sp, $sp, 4\n'
                    self.code += 'c.lt.s $f1, $f0\n'
                    self.code += f'bc1f {false_label}\n'
                    self.code += 'li $t0, 1\n'
                    self.code += 'sw $t0, 0($sp)\n'
                    self.code += f'j {end_label}\n'
                    self.code += f'{false_label}:\n'
                    self.code += 'li $t0, 0\n'
                    self.code += 'sw $t0, 0($sp)\n'
                    self.code += f'{end_label}:\n'
                elif operator == '<':
                    false_label = get_label('false_label')
                    end_label = get_label('end_label')
                    self.code += 'l.s $f0, 4($sp)\n'
                    self.code += 'l.s $f1, 0($sp)\n'
                    self.code += 'addi $sp, $sp, 4\n'
                    self.code += 'c.lt.s $f0, $f1\n'
                    self.code += f'bc1f {false_label}\n'
                    self.code += 'li $t0, 1\n'
                    self.code += 'sw $t0, 0($sp)\n'
                    self.code += f'j {end_label}\n'
                    self.code += f'{false_label}:\n'
                    self.code += 'li $t0, 0\n'
                    self.code += 'sw $t0, 0($sp)\n'
                    self.code += f'{end_label}:\n'
                elif operator == '>=':
                    false_label = get_label('false_label')
                    end_label = get_label('end_label')
                    self.code += 'l.s $f0, 4($sp)\n'
                    self.code += 'l.s $f1, 0($sp)\n'
                    self.code += 'addi $sp, $sp, 4\n'
                    self.code += 'c.le.s $f1, $f0\n'
                    self.code += f'bc1f {false_label}\n'
                    self.code += 'li $t0, 1\n'
                    self.code += 'sw $t0, 0($sp)\n'
                    self.code += f'j {end_label}\n'
                    self.code += f'{false_label}:\n'
                    self.code += 'li $t0, 0\n'
                    self.code += 'sw $t0, 0($sp)\n'
                    self.code += f'{end_label}:\n'
                elif operator == '<=':
                    false_label = get_label('false_label')
                    end_label = get_label('end_label')
                    self.code += 'l.s $f0, 4($sp)\n'
                    self.code += 'l.s $f1, 0($sp)\n'
                    self.code += 'addi $sp, $sp, 4\n'
                    self.code += 'c.le.s $f0, $f1\n'
                    self.code += f'bc1f {false_label}\n'
                    self.code += 'li $t0, 1\n'
                    self.code += 'sw $t0, 0($sp)\n'
                    self.code += f'j {end_label}\n'
                    self.code += f'{false_label}:\n'
                    self.code += 'li $t0, 0\n'
                    self.code += 'sw $t0, 0($sp)\n'
                    self.code += f'{end_label}:\n'
                else:
                    assert 1 == 2
            else:
                raise SemErr('operands are obj or arr or bool or string')
            add_sub_1 = add_sub_2
        return {'dim': 0, 'type': 'bool', 'class': 'Primitive'}

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
                    self.code += '## + ##\n'
                    self.code += "l.s $f0 , 4($sp)\n"
                    self.code += "l.s $f1 , 0($sp)\n"
                    self.code += "add.s $f0 , $f0 , $f1\n"
                    self.code += "s.s $f0 , 4($sp)\n"
                    self.code += '## END OF + ##\n\n'
                elif operator == '-':
                    self.code += '## - ##\n'
                    self.code += "l.s $f0 , 4($sp)\n"
                    self.code += "l.s $f1 , 0($sp)\n"
                    self.code += "sub.s $f0 , $f0 , $f1\n"
                    self.code += "s.s $f0 , 4($sp)\n"
                    self.code += '## END OF - ##\n\n'
            elif Type.is_arr(mdm_1) and Type.is_arr(mdm_2):
                if operator == '+':
                    # TODO append arrs
                    pass
                elif operator == '-':
                    raise SemErr('sub between arrs')
            else:
                raise SemErr('operand types are not correct')
            mdm_1 = mdm_2
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
                elif operator == '/':
                    self.code += '## / ##\n'
                    self.code += 'lw $t0, 4($sp)\n'
                    self.code += 'lw $t1, 0($sp)\n'
                    self.code += 'div $t0, $t0, $t1\n'
                    self.code += 'addi $sp, $sp, 4\n'
                    self.code += 'mflo $t0\n'
                    self.code += 'sw $t0, 0($sp)\n'
                    self.code += '## END OF / ##\n\n'
                elif operator == '%':
                    self.code += '## / ##\n'
                    self.code += 'lw $t0, 4($sp)\n'
                    self.code += 'lw $t1, 0($sp)\n'
                    self.code += 'div $t0, $t0, $t1\n'
                    self.code += 'addi $sp, $sp, 4\n'
                    self.code += 'mfhi $t0\n'
                    self.code += 'sw $t0, 0($sp)\n'
                    self.code += '## END OF / ##\n\n'
                    pass
            elif Type.is_double(not_neg_1) and Type.is_double(not_neg_2):
                if operator == '*':
                    self.code += '## * ##\n'
                    self.code += "l.s $f0 , 4($sp)\n"
                    self.code += "l.s $f1 , 0($sp)\n"
                    self.code += "mul.s $f0 , $f0 , $f1\n"
                    self.code += "s.s $f0 , 4($sp)\n"
                    self.code += '## END OF * ##\n\n'
                elif operator == '/':
                    self.code += '## / ##\n'
                    self.code += "l.s $f0 , 4($sp)\n"
                    self.code += "l.s $f1 , 0($sp)\n"
                    self.code += "div.s $f0 , $f0 , $f1\n"
                    self.code += "s.s $f0 , 4($sp)\n"
                    self.code += "addi $sp , $sp , 4\n"
                    self.code += '## END OF / ##\n\n'
                elif operator == '%':
                    raise SemErr('mod between doubles')
            else:
                raise SemErr('operand types are not correct')
            not_neg_1 = not_neg_2
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
                    self.code += 'sub $t0, $zero, $t0\n'
                    self.code += 'sw $t0, 0($sp)\n'
            elif Type.is_double(others):
                if operator == '!':
                    raise SemErr('! behind double operand')
                elif operator == '-':
                    self.code += '## - ##\n'
                    self.code += "l.s $f0 , 0($sp)\n"
                    self.code += "neg.s $f0, $f0 \n"
                    self.code += "s.s $f0 , 0($sp)\n"
                    self.code += '## END OF - ##\n\n'
            else:
                raise SemErr('operand types are not correct')
        return others

    def others_f(self, others):
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
            return self.call_f(others)
        elif others['expr_type'] == '(expr)':
            return self.expr_f(others)
        elif others['expr_type'] == 'read_int':
            self.code += 'li $v0, 5\n'
            self.code += 'syscall\n'
            self.code += 'addi $sp, $sp, -4\n'
            self.code += 'sw $v0, 0($sp)\n'
            return {'dim': 0, 'type': 'int', 'class': 'Primitive'}
        elif others['expr_type'] == 'read_line':
            global input_buffer
            self.code += f'la $a0, {input_buffer}\n'
            self.code += 'la $a1, 1000\n'
            self.code += 'li $v0, 8\n'
            self.code += 'syscall\n'
            self.code += 'addi $sp, $sp, -4\n'
            self.code += 'sw $a0, 0($sp)\n'
            return {'dim': 0, 'type': 'string', 'class': 'Primitive'}
        elif others['expr_type'] == 'new_id':
            class_ = Class.get_class(others['id'])
            needed_heap_space = class_.object_layout['heap_size']
            self.code += f'### ALLOC NEW ID {class_.id} ###\n'
            # space_label = add_space_to_data_sec(self, needed_heap_space)
            self.code += f'li $a0, {needed_heap_space}\n'
            self.code += 'li $v0, 9\n'
            self.code += 'syscall\n'
            self.code += 'move $t0, $v0\n'
            main_vtable_heap_label = class_.object_layout['_main_vptr'][
                'heap_label']
            self.code += f'la $t1, {main_vtable_heap_label}\n'
            self.code += 'sw $t1, 0($t0)\n'
            variable_count = len(Class.get_variable_fields_with_id(class_.id))
            interface_offset = variable_count * 4 + 4
            for interface in class_.decl['interfaces']:
                obj_interface = class_.object_layout[(interface['id'],
                                                      'interface')]
                vtable_heap_label = obj_interface['heap_label']
                self.code += f'la $t1, {vtable_heap_label}\n'
                self.code += f'sw $t1, {interface_offset}($t0)\n'
                interface_offset += 4
            self.code += 'addi $sp, $sp, -4\n'
            self.code += 'sw $t0, 0($sp)\n'
            self.code += f'### END OF ALLOC NEW ID {class_.id} ###\n\n'
            return {'dim': 0, 'type': 'Object', 'class': class_.id}
        elif others['expr_type'] == 'new_arr':
            global arr_size_neg_error_msg, runtime_error_msg
            # del others['expr_type']
            size_type = self.expr_f(others['size'])
            if not Type.is_int(size_type):
                raise SemErr('arr size can\'t be non-int')
            type_ = others['type']
            if Type.is_void(type_):
                raise SemErr('arr type can\'t be void')
            arr_size_ok_label = get_label('arr_size_ok')
            self.code += 'lw $t0, 0($sp)\n'
            self.code += f'bgt $t0, 0, {arr_size_ok_label}\n'
            self.code += f'la $a0, {runtime_error_msg}\n'
            self.code += 'li $v0, 4\n'
            self.code += 'syscall\n'
            self.code += f'move $ra, $s0\n'
            self.code += 'jr $ra\n'
            self.code += f'{arr_size_ok_label}:\n'
            self.code += 'move $t1, $t0\n'
            self.code += 'sll $t0, $t0, 2\n'
            self.code += 'addi $t0, $t0, 4\n'
            self.code += 'move $a0, $t0\n'
            self.code += 'li $v0, 9\n'
            self.code += 'syscall\n'
            self.code += 'sw $v0, 0($sp)\n'
            self.code += 'sw $t1, 0($v0)\n'
            return {
                'dim': type_['dim'] + 1,
                'type': type_['type'],
                'class': type_['class']
            }
        elif others['expr_type'] == 'itod':
            # TODO
            pass
        elif others['expr_type'] == 'dtoi':
            # TODO
            pass
        elif others['expr_type'] == 'itob':
            expr_type = self.expr_f(others['expr'])
            if not Type.is_int(expr_type):
                raise SemErr('itob arg is not int')
            self.code += 'addi $sp, $sp, -4\n'
            self.code += 'sw $ra, 0($sp)\n'
            self.code += 'jal itob\n'  # itob func label
            self.code += 'lw $ra, 0($sp)\n'
            self.code += 'addi $sp, $sp, 4\n'
            return {'dim': 0, 'type': 'bool', 'class': 'Primitive'}
        elif others['expr_type'] == 'btoi':
            expr_type = self.expr_f(others['expr'])
            if not Type.is_bool(expr_type):
                raise SemErr('btoi arg is not bool')
            return {'dim': 0, 'type': 'int', 'class': 'Primitive'}
        else:
            assert 1 == 2

    def constant_int_f(self, constant_int):
        value = constant_int['value']
        self.code += f'### CONSTANT INT {value} ###\n'
        self.code += 'addi $sp, $sp, -4\n'
        self.code += f'li $t0, {value}\n'
        self.code += 'sw $t0, 0($sp)\n'
        self.code += f'### END OF CONSTANT INT {value} ###\n\n'
        return {'dim': 0, 'type': 'int', 'class': 'Primitive'}

    def constant_double_f(self, constant_double):
        value = constant_double['value']
        self.code += f'### CONSTANT FLOAT {value} ###\n'
        self.code += 'addi $sp, $sp, -4\n'
        self.code += f'li.s $f0, {value}\n'
        self.code += 's.s $f0, 0($sp)\n'
        self.code += f'### END OF CONSTANT FLOAT {value} ###\n\n'
        return {'dim': 0, 'type': 'double', 'class': 'Primitive'}

    def constant_bool_f(self, constant_bool):
        value = constant_bool['value']
        self.code += f'\n### CONSTANT BOOL {value} ###\n'
        self.code += 'addi $sp, $sp, -4\n'
        if constant_bool['value'] == 'true':
            self.code += 'addi $t0, $zero, 1\n'
        else:
            self.code += 'move $t0, $zero\n'
        self.code += 'sw $t0, 0($sp)\n'
        self.code += f'### END OF CONSTANT BOOL {value} ###\n\n'
        return {'dim': 0, 'type': 'bool', 'class': 'Primitive'}

    def constant_string_f(self, constant_string):
        string_value = constant_string['value'][1:-1]
        self.code += f'\n### CONSTANT STRING {string_value} ###\n'
        self.code += 'addi $sp, $sp, -4\n'
        label = add_str_const_to_data_sec(self, string_value)
        self.code += f'la $t0, {label}\n'
        self.code += 'sw $t0, 0($sp)\n'
        self.code += f'### END OF CONSTANT STRING {string_value} ###\n\n'
        return {'dim': 0, 'type': 'string', 'class': 'Primitive'}

    def constant_null_f(self, args):
        self.code += '\n### NULL ###\n'
        self.code += 'addi $sp, $sp, -4\n'
        self.code += '### END OF NULL ###\n\n'
        return {'dim': 0, 'type': 'null', 'class': 'Primitive'}
