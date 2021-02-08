class Scope:
    def __init__(id: int, parent):
        self.parent = parent
        self.children = []
        self.variables = []
        self.functions = []
        self.classes = []
        self.interfaces = []
