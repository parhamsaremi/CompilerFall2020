class Scope:
    scope_count = 0
    scope_dict = {}

    def __init__(self):
        self.parent = None
        self.id = scope_count
        Scope.scope_dict[self.id] = scope
        Scope.scope_count += 1 
        self.children = []
        self.variables = []
        self.functions = []
        self.classes = []
        self.interfaces = []
