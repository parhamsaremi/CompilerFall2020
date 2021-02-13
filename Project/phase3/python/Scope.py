class Scope:
    scope_count = 0
    current_scope_id = None
    scope_dict = {}
    scope_stack = []

    def __init__(self):
        self.parent = None
        self.id = Scope.scope_count
        Scope.scope_dict[self.id] = self
        Scope.scope_count += 1
        self.children = []
        self.decls = {}

    def does_decl_id_exist(self, id: str):
        return self.decls.keys().__contains__(id)

    @staticmethod
    def get_decl_with_id(id: str):
        for i in range(len(Scope.scope_stack) - 1, -1, -1):
            scope = scope_stack[i]
            if scope.decls.keys().__contains__(id):
                return scope.decls[id]
        return None

    @staticmethod
    def get_fp_offset_of_variable(id: str):
        variable_decl = Scope.get_decl_with_id(id)
        if variable_decl is None:
            raise Exception('variable_decl wasnt found')
        if variable_decl['decl_type'] != 'variable':
            raise Exception('decl_type isnt variable')
        return variable_decl['fp_offset']
    raise Exception('variable id wasn\'t found in scope stack')

    @staticmethod
    def get_global_scope():
        return Scope.scope_dict[Scope.scope_count - 1]
