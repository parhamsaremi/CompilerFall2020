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
        grammar = r"""
            program: (decl)+
            decl: variable_decl 
                | function_decl 
                | class_decl 
                | interface_decl
            variable_decl: variable ";"
            variable: type T_ID
                    | new_type T_ID
            type: "int" 
                | "double" 
                | "bool" 
                | "string" 
                | type "[" "]"
            new_type: T_ID
            function_decl: type T_ID "(" formals ")" stmt_block
                        | "void" T_ID "(" formals ")" stmt_block
            formals: [variable ("," variable)*]
            class_decl: "class" T_ID ["extends" T_ID] ["implements" T_ID ("," T_ID)*] "{" (field)* "}"
            field: access_mode variable_decl
                 | access_mode function_decl
            access_mode: "private" 
                        | "public" 
                        | "protected" |
            interface_decl: "interface" T_ID "{" prototype* "}"
            prototype: type T_ID "(" formals ")" ";"
                    | "void" T_ID  "(" formals ")" ";"
            stmt_block: "{" (variable_decl)* (stmt)* "}"
            stmt: [expr] ";" 
                | if_stmt
                | while_stmt
                | for_stmt
                | break_stmt
                | return_stmt
                | continue_stmt
                | print_stmt
                | stmt_block
            if_stmt: "if" "(" expr ")" stmt ["else" stmt]
            while_stmt: "while" "(" expr ")" stmt
            for_stmt: "for" "(" [expr] ";" expr ";" [expr] ")" stmt
            return_stmt: "return" [expr] ";"
            break_stmt: "break" ";"
            continue_stmt: "continue" ";"
            print_stmt: "print" "(" expr ("," expr)* ")" ";"
            expr: lvalue "=" expr
                | constant
                | lvalue
                | "this"
                | call
                | "(" expr ")"
                | expr "\+" expr
                | expr "-" expr
                | expr "\*" expr
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
                | expr "\|\|" expr
                | "!" expr
                | "ReadInteger" "(" ")"
                | "ReadLine" "(" ")"
                | "new" T_ID
                | "NewArray" "(" expr "," type ")"
                | "itod" "(" expr ")"
                | "dtoi" "(" expr ")"
                | "itob" "(" expr ")"
                | "btoi" "(" expr ")"
            lvalue: T_ID
                | expr "." T_ID
                | expr "[" expr "]"
            call: T_ID "(" actuals ")"
                | expr "." T_ID "(" actuals ")"
            actuals: [expr ("," expr)*]
            constant: T_INT
                | T_DOUBLE
                | T_BOOL
                | T_STRING
                | "null"
            DIGIT: /[0-9]/
            DIGIT16: /[0-9a-f]/
            DELIM: /[ \r\t\n\f]/
            WS: (DELIM)+
            CHAR: /[a-zA-Z]/
            BASE10INT: (DIGIT)+
            BASE16INT: "0" ("x" | "X") (DIGIT16)+
            T_INT: (BASE10INT | BASE16INT)
            T_DOUBLE: (DIGIT)+ "." [(DIGIT)+] [("e" | "E")("-" | "+") (DIGIT)+]
            T_STRING: "\"" /[^\"\n]*/ "\""
            T_BOOL: "true" | "false"
            COMMENT: "//" /[^\n]*/
            COMMENTM: "/*" /[^(\*\/)]/ "*/"
            T_ID: /(?!"true"|"false"|"null"|"btoi"|"dtoi"|"itob"|"itod"|"ReadLine"|"ReadInteger"|"new"|"NewArray"|"print"|"continue"|"break"|"return"|"for"|"while"|"if"|"void"|"public"|"private"|"protected"|"int"|"double"|"string"|"class"|"bool")/ (CHAR (CHAR | DIGIT | "_")*)
            %ignore WS
            %ignore COMMENT
            %ignore COMMENTM
        """
        parser = Lark(grammar,start="program",parser='lalr', debug=True)
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