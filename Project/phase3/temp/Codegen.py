from lark import Transformer


class CG(Transformer):
    def __init__(self):
        super().__init__()

    def s_f(self, args):
        print('s_f')

    def e_f(self, args):
        print('e_f')