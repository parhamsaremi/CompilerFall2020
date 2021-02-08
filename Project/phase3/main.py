import sys, getopt
from lark import Lark
from FirstTraverse import FirstTraverse
import os

def main(argv):
    inputfile = ''
    outputfile = ''
    try:
        opts, args = getopt.getopt(argv,"hi:o:",["ifile=","ofile="])
    except getopt.GetoptError:
        print ('main.py -i <inputfile> -o <outputfile>')
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print ('test.py -i <inputfile> -o <outputfile>')
            sys.exit()
        elif opt in ("-i", "--ifile"):
            inputfile = arg
        elif opt in ("-o", "--ofile"):
            outputfile = arg

    parser = None
    has_error = False
    with open("/tests/" + inputfile, "r") as input_file:
        grammar = r"""
        program : decl decl_prime -> program
        decl_prime: decl decl_prime -> decl_prime
            | -> decl_prime
        decl : variable_decl -> decl_variable_decl
            | function_decl -> decl_function_decl
            | class_decl -> decl_class_decl
            | interface_decl -> decl_interface_decl
        variable_decl : variable ";" -> variable_decl_f
        variable : type identifier -> variable
        type : "int" -> type_primitive
            | "double" -> type_primitive
            | "bool" -> type_primitive
            | "string" -> type_primitive
            | identifier -> type_id
            | type "[]" -> type_arr
        function_decl : type identifier "("formals")" stmt_block -> function_decl_f
            | "void" identifier "("formals")" stmt_block -> function_decl_f
        formals : variable variable_prime -> formals_f
            | -> formals_f
        variable_prime: "," variable variable_prime -> variable_prime_f
            | -> variable_prime_f
        class_decl : "class" identifier extends implements "{" field_prime "}" -> class_decl_f
        extends: "extends" identifier -> extends_f
            | 
        implements: "implements" identifier id_prime -> implements_f
            | -> implements_f
        id_prime: "," identifier id_prime -> id_prime_f
            | -> id_prime_f
        field_prime: field field_prime -> field_prime_f
            | -> field_prime_f
        field : access_mode variable_decl -> field_f
            | access_mode function_decl -> field_f
        access_mode : "private" -> access_mode
            | "protected" -> access_mode
            | "public" -> access_mode
            | -> access_mode
        interface_decl : "interface" identifier "{" prototype_prime "}" -> interface_decl_f
        prototype_prime: prototype prototype_prime -> prototype_prime_f
            | prototype_prime_f
        prototype : type identifier "(" formals ")" ";" -> prototype_f
            | "void" identifier "(" formals ")" ";" -> prototype_f
        stmt_block : "{" variable_decl_prime stmt_prime "}" -> stmt_block
        variable_decl_prime : variable_decl_prime variable_decl -> variable_decl_prime_f
            | -> variable_decl_prime_f
        stmt_prime : stmt stmt_prime -> stmt_prime_f
            | -> stmt_prime_f
        stmt : expr_prime ";" -> stmt_expr_prime
            | if_stmt -> stmt_if
            | while_stmt -> stmt_while
            | for_stmt -> stmt_for
            | break_stmt -> stmt_break
            | continue_stmt -> stmt_continue
            | return_stmt -> stmt_return
            | print_stmt -> stmt_print
            | stmt_block -> stmt_stmt_block
        if_stmt : "if" "(" expr ")" stmt else_prime -> if_stmt    
        else_prime: "else" stmt -> else_prime
            |
        while_stmt : "while" "(" expr ")" stmt -> while_stmt
        for_stmt : "for" "(" expr_prime ";" expr ";" expr_prime ")" stmt -> for_stmt
        return_stmt : "return" expr_prime ";" -> return_stmt
        expr_prime: expr -> expr_prime_f
            | -> expr_prime_f
        break_stmt : "break" ";" break_stmt
        continue_stmt : "continue" ";" -> continue_stmt
        print_stmt : "Print" "(" expr exprs ")" ";" -> print_stmt
        expr: assign -> expr
        assign: l_value "=" assign -> assign_assign
            | or -> assign_or
        or: or "||" and -> or_or
            | and -> or_and
        and: and "&&" eq_neq -> and_and
            | eq_neq -> and_eq
        eq_neq: eq_neq EQUAL comp -> eq_neq_equal
            | comp -> eq_neq_comp
        comp: comp COMPARE add_sub -> comp_compare
            | add_sub -> comp_add_sub
        add_sub: add_sub AS mul_div_mod -> add_sub_as
            | mul_div_mod -> add_sub_muldivmod
        mul_div_mod: mul_div_mod MDM not_neg -> mul_div_mode_mdm
            | not_neg -> mul_div_mode_mdm
        not_neg: NN not_neg -> not_neg_nn
            | others -> not_neg_others
        others: constant -> others_constant
            | "this" -> others_this
            | l_value -> others_lvalue
            | call -> others_call
            | "(" expr ")" -> others_expr
            | "ReadInteger" "(" ")" -> others_readinteger
            | "ReadLine" "(" ")" -> others_readline
            | "new" identifier -> others_new_id
            | "NewArray" "(" expr "," type ")" -> others_newarray
            | "itod" "(" expr ")" -> others_itod
            | "dtoi" "(" expr ")" -> others_dtoi
            | "itob" "(" expr ")" -> others_itob
            | "btoi" "(" expr ")" -> others_btoi
        l_value : identifier -> lvalue_id
            | others "." identifier -> lvalue_others_id
            | others "[" expr "]" -> lvalue_others_expr
        call : identifier "(" actuals ")" -> call_id
            | others "." identifier "(" actuals ")" -> call_others
        actuals : expr exprs -> actuals_expr
            | 
        exprs: "," expr exprs -> exprs_expr
            |
        constant : T_INT -> constant
            | T_DOUBLE -> constant
            | T_BOOL -> constant
            | T_STRING -> constant
            | "null" -> constant_null
        NN: "-" -> nn 
            | "!" -> nn
        AS: "+" -> as
            | "-" -> as
        MDM: "/" -> mdm
            | "%" -> mdm
            | "*" -> mdm
        EQUAL: "==" -> equal
            | "!=" -> equal
        COMPARE:">=" -> compare
            | "<=" -> compare
            | "<" -> compare
            | ">" -> compare
        T_DOUBLE : /(\d+\.(\d*)?((e|E)(\+|-)?\d+)?)/ -> t_double
            | /(\d+(e|E)(\+|-)?\d+)/ -> t_double
        T_INT : /(0[x|X][0-9a-fA-F]+)/ -> t_int
            | /(\d+)/ -> t_int
        T_BOOL : /(true)/ -> t_bool
            | /(false)/ -> t_bool
        T_STRING : "\"" /[^\"\n]*/ "\"" -> t_string
        identifier :  /(?!((true)|(false)|(void)|(int)|(double)|(bool)|(string)|(class)|(interface)|(null)|(this)|(extends)|(implements)|(for)|(while)|(if)|(else)|(return)|(break)|(continue)|(new)|(NewArray)|(Print)|(ReadInteger)|(ReadLine)|(dtoi)|(itod)|(btoi)|(itob)|(private)|(protected)|(public))([^_a-zA-Z0-9]|$))[a-zA-Z][_a-zA-Z0-9]*/ -> identifier
        COMMENT: "//" /[^\n]*/
        COMMENTM: "/*" /[^(\*\/)]/ "*/"
        %ignore COMMENT 
        %ignore COMMENTM
        %import common.WS
        %ignore WS
        """

        code = """
            void main () {
                id.id = 999;
            }
        """

        parser = Lark(grammar,start="program", transformer=FirstTraverse(),parser='lalr', debug=False)
        # print(parser.parse(code))
        try:
            x = input_file.read()
            print(x)
            print(parser.parse(x))
            # parser.parse(x)
        except:
            has_error = True
    with open("out/" + outputfile, "w") as output_file:
        if has_error:
            output_file.write("Syntax Error")
        else:
            output_file.write("OK")

if __name__ == "__main__":
    main(sys.argv[1:])
    # main(None)