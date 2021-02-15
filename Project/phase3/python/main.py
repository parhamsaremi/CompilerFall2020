import sys, getopt
from lark import Lark
# import FirstTraverse as _ft
from FirstTraverse import FirstTraverse
# import SecondTraverse as _st
from SecondTraverse import SecondTraverse
import traceback

# TODO bug in l_value : others.identifier -> assign.identifier


def alert(text):
    print('\033[91m' + str(text) + '\033[0m')


def main(argv):
    inputfile = ''
    outputfile = ''
    try:
        opts, args = getopt.getopt(argv, "hi:o:", ["ifile=", "ofile="])
    except getopt.GetoptError:
        print('main.py -i <inputfile> -o <outputfile>')
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print('test.py -i <inputfile> -o <outputfile>')
            sys.exit()
        elif opt in ("-i", "--ifile"):
            inputfile = arg
        elif opt in ("-o", "--ofile"):
            outputfile = arg

    parser = None
    has_error = False
    postfix = '1'
    with open("tests" + postfix + "/" + inputfile, "r") as input_file:
        grammar = r"""
        program : decl decl_prime -> program_f
        decl_prime: decl decl_prime -> decl_prime_f
            | -> decl_prime_f
        decl : variable_decl -> decl_f
            | function_decl -> decl_f
            | class_decl -> decl_f
            | interface_decl -> decl_f
        variable_decl : variable ";" -> variable_decl_f
        variable : type identifier -> variable_f
        type : "int" -> type_int_f
            | "double" -> type_double_f
            | "bool" -> type_bool_f
            | "string" -> type_string_f
            | identifier -> type_id_f
            | type "[]" -> type_arr_f
        function_decl : type identifier "("formals")" stmt_block -> function_decl_f
            | "void" identifier "("formals")" stmt_block -> function_decl_f
        formals : variable variable_prime -> formals_f
            | -> formals_f
        variable_prime: "," variable variable_prime -> variable_prime_f
            | -> variable_prime_f
        class_decl : "class" identifier extends implements "{" field_prime "}" -> class_decl_f
        extends: "extends" identifier -> extends_f
            | -> extends_f
        implements: "implements" identifier id_prime -> implements_f
            | -> implements_f
        id_prime: "," identifier id_prime -> id_prime_f
            | -> id_prime_f
        field_prime: field field_prime -> field_prime_f
            | -> field_prime_f
        field : access_mode variable_decl -> field_f
            | access_mode function_decl -> field_f
        access_mode : "private" -> access_mode_private_f
            | "protected" -> access_mode_protected_f
            | "public" -> access_mode_public_f
            | -> access_mode_public_f
        interface_decl : "interface" identifier "{" prototype_prime "}" -> interface_decl_f
        prototype_prime: prototype prototype_prime -> prototype_prime_f
            | -> prototype_prime_f
        prototype : type identifier "(" formals ")" ";" -> prototype_f
            | "void" identifier "(" formals ")" ";" -> prototype_f
        stmt_block : "{" variable_decl_prime stmt_prime "}" -> stmt_block_f
        variable_decl_prime : variable_decl_prime variable_decl -> variable_decl_prime_f
            | -> variable_decl_prime_f
        stmt_prime : stmt stmt_prime -> stmt_prime_f
            | -> stmt_prime_f
        stmt : expr_prime ";" -> stmt_expr_prime_f
            | if_stmt -> stmt_f
            | while_stmt -> stmt_f
            | for_stmt -> stmt_f
            | break_stmt -> stmt_f
            | continue_stmt -> stmt_f
            | return_stmt -> stmt_f
            | print_stmt -> stmt_f
            | stmt_block -> stmt_stmt_block_f
        if_stmt : "if" "(" expr ")" stmt else_prime -> if_stmt_f
        else_prime: "else" stmt -> else_prime_f
            | -> else_prime_f
        while_stmt : "while" "(" expr ")" stmt -> while_stmt_f
        for_stmt : "for" "(" expr_prime ";" expr ";" expr_prime ")" stmt -> for_stmt_f
        return_stmt : "return" expr_prime ";" -> return_stmt_f
        expr_prime: expr -> expr_prime_f
            | -> expr_prime_f
        break_stmt : "break" ";" -> break_stmt_f
        continue_stmt : "continue" ";" -> continue_stmt_f
        print_stmt : "Print" "(" expr exprs ")" ";" -> print_stmt_f
        expr: assign -> expr_f
        assign: l_value "=" assign -> assign_f
            | or -> assign_f
        or: or "||" and -> or_f
            | and -> or_f
        and: and "&&" eq_neq -> and_f
            | eq_neq -> and_f
        eq_neq: eq_neq EQUAL comp -> eq_neq_f
            | comp -> eq_neq_f
        comp: comp COMPARE add_sub -> comp_f
            | add_sub -> comp_f
        add_sub: add_sub AS mul_div_mod -> add_sub_f
            | mul_div_mod -> add_sub_f
        mul_div_mod: mul_div_mod MDM not_neg -> mul_div_mod_f
            | not_neg -> mul_div_mod_f
        not_neg: NN not_neg -> not_neg_f
            | others -> not_neg_f
        others: constant -> others_constant_f
            | "this" -> others_this_f
            | l_value -> others_lvalue_f
            | call -> others_call_f
            | "(" expr ")" -> others_p_expr_p_f
            | "ReadInteger" "(" ")" -> others_read_int_f
            | "ReadLine" "(" ")" -> others_read_line_f
            | "new" identifier -> others_new_id_f
            | "NewArray" "(" expr "," type ")" -> others_new_arr_f
            | "itod" "(" expr ")" -> others_itod_f
            | "dtoi" "(" expr ")" -> others_dtoi_f
            | "itob" "(" expr ")" -> others_itob_f
            | "btoi" "(" expr ")" -> others_btoi_f
        l_value : identifier -> l_value_id_f
            | others "." identifier -> l_value_obj_f
            | others "[" expr "]" -> l_value_arr_f
        call : identifier "(" actuals ")" -> call_f
            | others "." identifier "(" actuals ")" -> call_f
        actuals : expr exprs -> actuals_f
            | -> actuals_f
        exprs: "," expr exprs -> exprs_f
            | -> exprs_f
        constant : T_INT -> constant_int_f
            | T_DOUBLE -> constant_double_f
            | T_BOOL -> constant_bool_f
            | T_STRING -> constant_string_f
            | "null" -> constant_null_f
        NN: "-"
            | "!"
        AS: "+"
            | "-"
        MDM: "/"
            | "%"
            | "*"
        EQUAL: "=="
            | "!="
        COMPARE:">="
            | "<="
            | "<"
            | ">"
        T_DOUBLE : /(\d+\.(\d*)?((e|E)(\+|-)?\d+)?)/ 
            | /(\d+(e|E)(\+|-)?\d+)/
        T_INT : /(0[x|X][0-9a-fA-F]+)/ 
            | /(\d+)/
        T_BOOL : /(true)/ 
            | /(false)/
        T_STRING : "\"" /[^\"\n]*/ "\""
        identifier :  /(?!((true)|(false)|(void)|(int)|(double)|(bool)|(string)|(class)|(interface)|(null)|(this)|(extends)|(implements)|(for)|(while)|(if)|(else)|(return)|(break)|(continue)|(new)|(NewArray)|(Print)|(ReadInteger)|(ReadLine)|(dtoi)|(itod)|(btoi)|(itob)|(private)|(protected)|(public))([^_a-zA-Z0-9]|$))[a-zA-Z][_a-zA-Z0-9]*/ -> identifier_f
        COMMENT: "//" /[^\n]*/
        COMMENTM: "/*" /[^(\*\/)]/ "*/"
        %ignore COMMENT 
        %ignore COMMENTM
        %import common.WS
        %ignore WS
        """

        first_traverse_dict = None
        parser = Lark(grammar,
                      start="program",
                      transformer=FirstTraverse(),
                      parser='lalr',
                      debug=False)
        # print(parser.parse(code))
        try:
            x = input_file.read()
            # alert('TEST_CODE--------------------')
            # print(x)
            # alert('-----------------------------')

            # print(parser.parse(x))
            first_traverse_dict = parser.parse(x)
        except Exception as e:
            traceback.print_exc()
            has_error = True
    with open('out' + postfix + '/' + outputfile, 'w') as output_file:
        if has_error:
            output_file.write('Syntax Error')
        else:
            second_traverse = None
            try:
                second_traverse = SecondTraverse(first_traverse_dict)
                output_file.write(second_traverse.asm_code)
                # alert('ASM_CODE-------------------------')
                # print(second_traverse.asm_code)
                # alert('---------------------------------')
            except Exception as e:
                traceback.print_exc()


if __name__ == "__main__":
    main(sys.argv[1:])
