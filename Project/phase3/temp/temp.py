import sys, getopt
from lark import Lark
from Codegen import CG


def main():
    code = """
        i * i + i * i
    """
    grammar = r"""
        s: e "+" s -> s_f
            | e -> s_f
        e: INT "*" e -> e_f
            | INT -> e_f
        INT: "i"
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