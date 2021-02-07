import sys, getopt
from lark import Lark
from Codegen import CG
def main():
    code = """
        10 * 36 + 2 + 5 * 4 + 3
    """
    grammar = r"""
        program: expr -> final
        expr: expr "+" expr_mul -> add
            | expr_mul -> add_pass
        expr_mul: expr_mul "*" INT -> mul
            | INT -> mul_const
        INT: /[0-9]+/
        DELIM: /[ \r\t\n\f]/
        WS: (DELIM)+
        %ignore WS
    """
    c = CG()
    parser = Lark(grammar,start="program",transformer=c,parser='lalr', debug=False)
    tree = parser.parse(code)
    print(tree)
main()