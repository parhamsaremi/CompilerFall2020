class Scope:
    scope_count = 0
    scope_dict = {}

    def __init__(self):
        self.parent = None
        self.id = Scope.scope_count
        Scope.scope_dict[self.id] = self
        Scope.scope_count += 1 
        self.children = []
        self.decls= {}

    def does_decl_id_exist(self, id: str):
        return self.decls.keys().__contains__(id)
