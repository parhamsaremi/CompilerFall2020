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
        decl_prime: decl decl_prime
            | 
        decl : variable_decl 
            | function_decl 
            | class_decl 
            | interface_decl
        variable_decl : variable ";"
        variable : type identifier
        type : "int" 
            | "double" 
            | "bool" 
            | "string" 
            | identifier 
            | type "[]"
        function_decl : type identifier "("formals")" stmt_block 
            | "void" identifier "("formals")" stmt_block
        formals : variable variable_prime 
            | 
        variable_prime: "," variable variable_prime
            | 
        class_decl : "class" identifier extends implements "{" field_prime "}"
        extends: "extends" identifier
            | 
        implements: "implements" identifier id_prime
            |
        id_prime: "," identifier id_prime
            |
        field_prime: field field_prime
            | 
        field : access_mode variable_decl 
            | access_mode function_decl
        access_mode : "private" 
            | "protected" 
            | "public" 
            | 
        interface_decl : "interface" identifier "{" prototype_prime "}"
        prototype_prime: prototype prototype_prime
            |
        prototype : type identifier "(" formals ")" ";" 
            | "void" identifier "(" formals ")" ";"
        stmt_block : "{" variable_decl_prime stmt_prime "}"
        variable_decl_prime : variable_decl_prime variable_decl
            | 
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
        identifier :  /(?!((true)|(false)|(void)|(int)|(double)|(bool)|(string)|(class)|(interface)|(null)|(this)|(extends)|(implements)|(for)|(while)|(if)|(else)|(return)|(break)|(continue)|(new)|(NewArray)|(Print)|(ReadInteger)|(ReadLine)|(dtoi)|(itod)|(btoi)|(itob)|(private)|(protected)|(public))([^_a-zA-Z0-9]|$))[a-zA-Z][_a-zA-Z0-9]*/
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