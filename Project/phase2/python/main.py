import sys, getopt
from lark import Lark
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
        grammar = """
    start : (decl)+
    decl : variable_decl 
        | function_decl 
        | class_decl 
        | interface_decl
    variable_decl : variable ";"
    variable : type T_ID
    type : "int" 
        | "double" 
        | "bool" 
        | "string" 
        | T_ID 
        | type "[]"
    function_decl : type T_ID "("formals")" stmt_block 
        | "void" T_ID "("formals")" stmt_block
    formals : variable (","variable)* 
        | 
    class_decl : "class" T_ID ("extends" T_ID)? ("implements" T_ID("," T_ID)*)? "{"(field)*"}"
    field : access_mode variable_decl 
        | access_mode function_decl
    access_mode : "private" 
        | "protected" 
        | "public" 
        | 
    interface_decl : "interface" T_ID "{"(prototype)*"}"
    prototype : type T_ID "(" formals ")" ";" 
        | "void" T_ID "(" formals ")" ";"
    stmt_block : "{" (variable_decl)* (stmt)* "}"
    stmt : (expr)? ";" 
        | if_stmt 
        | while_stmt 
        | for_stmt 
        | break_stmt 
        | continue_stmt 
        | return_stmt 
        | print_stmt 
        | stmt_block
    if_stmt : "if" "(" expr ")" stmt ("else" stmt)?
    while_stmt : "while" "(" expr ")" stmt
    for_stmt : "for" "(" (expr)? ";" expr ";" (expr)? ")" stmt
    return_stmt : "return" (expr)? ";"
    break_stmt : "break" ";"
    continue_stmt : "continue" ";"
    print_stmt : "Print" "(" expr (","expr)* ")" ";"
    expr : lvalue "=" expr 
        | constant 
        | lvalue 
        | "this" 
        | call 
        | "(" expr ")" 
        | expr "+" expr 
        | expr "-" expr 
        | expr "*" expr 
        | expr "/" expr 
        | expr "%" expr 
        | "-" expr 
        | expr "<" expr 
        | expr "<=" expr 
        | expr ">" expr 
        | expr ">=" expr 
        | expr "==" expr 
        | expr "!=" expr 
        | expr "&&" expr 
        | expr "||" expr 
        | "!" expr 
        | "ReadInteger" "(" ")" 
        | "ReadLine" "(" ")" 
        | "new" T_ID 
        | "NewArray" "(" expr "," type ")" 
        | "itod" "(" expr ")" 
        | "dtoi" "(" expr ")" 
        | "itob" "(" expr ")" 
        | "btoi" "(" expr ")"
    lvalue : T_ID 
        | expr "." T_ID 
        | expr "[" expr "]"
    call : T_ID "(" actuals ")" 
        | expr "." T_ID "(" actuals ")"
    actuals : expr (","expr)* 
        | 
    constant : int_constant 
        | double_constant 
        | bool_constant 
        | string_constant 
        | "null"
    double_constant : /(\d+\.(\d*)?((e|E)(\+|-)?\d+)?)/ 
        | /(\d+(e|E)(\+|-)?\d+)/
    int_constant : /(0[x|X][0-9a-fA-F]+)/ 
        | /(\d+)/
    bool_constant : /(true)/ 
        | /(false)/
    string_constant : /"[^"\\n]*"/
    T_ID :  /(?!((true)|(false)|(void)|(int)|(double)|(bool)|(string)|(class)|(interface)|(null)|(this)|(extends)|(implements)|(for)|(while)|(if)|(else)|(return)|(break)|(continue)|(new)|(NewArray)|(Print)|(ReadInteger)|(ReadLine)|(dtoi)|(itod)|(btoi)|(itob)|(private)|(protected)|(public))([^_a-zA-Z0-9]|$))[a-zA-Z][_a-zA-Z0-9]*/
    INLINE_COMMENT : "//" /[^\\n]*/ "\\n"
    MULTILINE_COMMENT : "/*" /.*?/ "*/"
    %ignore INLINE_COMMENT 
    %ignore MULTILINE_COMMENT
    %import common.WS
    %ignore WS
    """

        code = """
            interface int {}
        """
        parser = Lark(grammar,start="start",parser='lalr', debug=False)
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