from lark import Transformer
class CG(Transformer):
    def __init__(self):
        super().__init__()
    def final(self, args):
        print("final", args)
        print("result: ", args[0]['value'])
    def const(self, args):
        print("const: ", args)
        return{
            'value': int(args[0].value,0),
            'type': 'int'
        }
    def add(self, args):
        print("add: ", args)
        return {
            'value': args[0]['value'] + args[1]['value'],
            'type': 'int'
        }
    def mul(self, args):
        print("mul: ", args)
        return {
            "value": args[0]['value'] * int(args[1].value, 0),
            "type": "int",
            "code": "mmmmmmm" + args[0]['code']
        }
    def mul_const(self, args):
        print("mul_constant: ", args)
        return {
            'value': int(args[0].value, 0),
            'code': args[0].value
        }
    def add_pass(self, args):
        print('add_pass: ', args)
        return {
            'value': args[0]['value'],
            'type': args[0]['type'],
            'code': "aaaaaa"
        }