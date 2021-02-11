from lark import Transformer
from SymbolTable import SymbolTable
from Scope import Scope
from SemanticError import SemanticError as SemErr

# TODO:
# add '_f' to end of all functions
# may need to change if_stmt in grammar
# deleted wrong terminal rules, might need extra work

count_label = 0


def get_label(prefix=""):
    label = ""
    if prefix == "":
        label = f"label{count_label}"
        count_label += 1
    else:
        count_label += 1
        label = f"{prefix}_label{count_label}"
    return label


class SecondTraverse(Transformer):
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
        pass

    def variable_decl_prime_f(self, args):
        pass

    def function_decl_f(self, args):
        pass

    def interface_decl_f(self, args):
        pass

    def class_decl_f(self, args):
        pass

    def stmt_block_f(self, args):
        pass

    def exprs_f(self, args):
        pass

    def actuals_f(self, args):
        pass

    def variable_f(self, args):
        pass

    def variable_prime_f(self, args):
        pass

    def while_stmt_f(self, args):
        # TODO check if expr is bool or not
        # TODO check for break and continue
        start_label = get_label("while")
        end_label = get_label("end")
        code = '#### start while loop:\n'
        code = f'{start_label}:\n'
        code += args[0]['code']  # condition
        code += 'addi $sp, $sp, 4\n'
        code += 'lw $t0, 0($sp)\n'
        code += f'beqz $t0, {end_label}\n'
        code += args[1]['code']  # stmt
        code += f'j {start_label}'
        code += f'{end_label}:\n'
        return {'code': code}

    def for_stmt_f(self, args):
        # TODO check for break and continue
        start_label = get_label("for")
        end_label = get_label("for_end")
        code = ""
        code += args[0]['code']  # init code
        code += f'{start_label}:'
        code += args[1]['code']  # condition
        code += 'addi $sp, $sp, 4\n'
        code += 'lw $t0, 0($sp)\n'
        code += f'beqz $t0, {end_label}\n'
        code += args[3]['code']  #stmt
        code += args[2]['code']  #step # TODO i don't know if this is right
        code += f'j {start_label}:\n'

        return {'code': code}

    def formals_f(self, args):
        pass

    def prototype_f(self, args):
        pass

    def prototype_prime_f(self, args):
        pass

    def stmt_prime_f(self, args):
        pass

    def type_int_f(self, args):
        pass

    def type_double_f(self, args):
        pass

    def type_bool_f(self, args):
        pass

    def type_string_f(self, args):
        pass

    def type_id_f(self, args):
        pass

    def type_arr_f(self, args):
        pass

    def implements_f(self, args):
        pass

    def extends_f(self, args):
        pass

    def field_prime_f(self, args):
        pass

    def field_f(self, args):
        pass

    def access_mode_private(self, args):
        pass

    def access_mode_protected(self, args):
        pass

    def access_mode_public(self, args):
        pass

    def id_prime_f(self, args):
        pass

    def constant_int_f(self, args):
        pass

    def constant_double_f(self, args):
        pass

    def constant_bool_f(self, args):
        pass

    def constant_string_f(self, args):
        pass

    def constant_null(self, args):
        pass

    def identifier_f(self, args):
        pass
