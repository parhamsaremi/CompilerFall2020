import sys, getopt
from lark import Lark
from Codegen import CG


def main():
    code = """
        int int int int
    """
    grammar = r"""
        s: INT s -> s_f
            | -> s_f
        INT: "int"
        DELIM: /[ \r\t\n\f]/
        WS: (DELIM)+
        %ignore WS
    """
    c = CG()
    parser = Lark(grammar,
                  start="s",
                  transformer=c,
                  parser='lalr',
                  debug=False)
    tree = parser.parse(code)
    print('***')

    print(tree)


main()