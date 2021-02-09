import sys, getopt
from lark import Lark
from FirstTraverse import FirstTraverse
import traceback

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
    with open("tests/" + inputfile, "r") as input_file:
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
        stmt_block : "{" variable_decl_prime stmt_prime "}"
        variable_decl_prime : variable_decl_prime variable_decl -> variable_decl_prime_f
            | -> variable_decl_prime_f
        stmt_prime : stmt stmt_prime
            | 
        stmt : expr_prime ";" 
            | if_stmt 
            | while_stmt 
            | for_stmt 
            | break_stmt 
            | continue_stmt 
            | return_stmt 
            | print_stmt 
            | stmt_block
        if_stmt : "if" "(" expr ")" stmt else_prime    
        else_prime: "else" stmt
            |
        while_stmt : "while" "(" expr ")" stmt
        for_stmt : "for" "(" expr_prime ";" expr ";" expr_prime ")" stmt
        return_stmt : "return" expr_prime ";"
        expr_prime: expr 
            |
        break_stmt : "break" ";"
        continue_stmt : "continue" ";"
        print_stmt : "Print" "(" expr exprs ")" ";"
        expr: assign
        assign: l_value "=" assign
            | or
        or: or "||" and
            | and
        and: and "&&" eq_neq
            | eq_neq
        eq_neq: eq_neq EQUAL comp
            | comp
        comp: comp COMPARE add_sub
            | add_sub
        add_sub: add_sub AS mul_div_mod
            | mul_div_mod
        mul_div_mod: mul_div_mod MDM not_neg
            | not_neg
        not_neg: NN not_neg
            | others
        others: constant
            | "this"
            | l_value
            | call
            | "(" expr ")"
            | "ReadInteger" "(" ")"
            | "ReadLine" "(" ")" 
            | "new" identifier 
            | "NewArray" "(" expr "," type ")" 
            | "itod" "(" expr ")" 
            | "dtoi" "(" expr ")" 
            | "itob" "(" expr ")" 
            | "btoi" "(" expr ")"
        l_value : identifier 
            | others "." identifier 
            | others "[" expr "]"
        call : identifier "(" actuals ")" 
            | others "." identifier "(" actuals ")"
        actuals : expr exprs
            | 
        exprs: "," expr exprs
            |
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

        # code = """
        #     void main () {
        #         id.id = 999;
        #     }
        # """

        parser = Lark(grammar,start="program", transformer=FirstTraverse(),parser='lalr', debug=False)
        # print(parser.parse(code))
        try:
            x = input_file.read()
            print(x)
            print(parser.parse(x))
            # parser.parse(x)
        except Exception as e:
            traceback.print_exc()
            has_error = True
    with open("out/" + outputfile, "w") as output_file:
        if has_error:
            output_file.write("Syntax Error")
        else:
            output_file.write("OK")

if __name__ == "__main__":
    main(sys.argv[1:])
    # main(None)