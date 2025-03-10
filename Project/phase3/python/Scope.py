from SemanticError import SemanticError as SemErr


def alert(text):
    print('\033[91m' + str(text) + '\033[0m')
    print('\033[91m' + '-----------------------' + '\033[0m')


class Scope:
    scope_count = 0
    # current_scope_id = None
    scope_dict = {}
    scope_stack = []

    def __init__(self, type_: str):
        self.parent = None
        self.id = Scope.scope_count
        Scope.scope_dict[self.id] = self
        Scope.scope_count += 1
        self.type = type_
        self.children = []
        self.decls = {}

    def does_decl_id_exist(self, id: str):
        return self.decls.keys().__contains__(id)

    @staticmethod
    def get_decl_in_symbol_table(id_: str, decl_type: str):
        for i in range(len(Scope.scope_stack) - 1, -1, -1):
            scope = Scope.scope_stack[i]
            if scope.decls.keys().__contains__(id_):
                if scope.decls[id_]['decl_type'] == decl_type:
                    return scope.decls[id_]
        return None

    @staticmethod
    def get_global_scope():
        return Scope.scope_dict[Scope.scope_count - 1]

    @staticmethod
    def get_classes():
        global_scope = Scope.get_global_scope()
        res = []
        for decl in global_scope.decls:
            if decl['decl_type'] == 'class':
                res.append(decl)
        return res

    @staticmethod
    def get_global_functions():
        global_scope = Scope.get_global_scope()
        res = []
        for decl in global_scope.decls.values():
            if decl['decl_type'] == 'function':
                res.append(decl)
        return res

    @staticmethod
    def get_global_variables():
        global_scope = Scope.get_global_scope()
        res = []
        for decl in global_scope.decls.values():
            if decl['decl_type'] == 'variable':
                res.append(decl)
        return res

    @staticmethod
    def get_main_function():
        functions = Scope.get_global_functions()
        for function in functions:
            if function['id'] == main:
                return function
        return None

    @staticmethod
    def get_class(class_id: str):
        global_scope = Scope.get_global_scope()
        for decl in global_scope.decls.values():
            if decl['decl_type'] == 'class' and decl['id'] == class_id:
                return decl
        return None

    @staticmethod
    def get_variables_of_class(class_id: str):
        class_ = Scope.get_class(class_id)
        res = []
        for field in class_['fields']:
            decl = field['declaration']
            if decl['decl_type'] == 'variable':
                res.append(decl)
        return res

    @staticmethod
    def get_functions_of_class(class_id: str):
        class_ = Scope.get_class(class_id)
        res = []
        for field in class_['fields']:
            decl = field['declaration']
            if decl['decl_type'] == 'function':
                res.append(decl)
        return res

    @staticmethod
    def get_interface(interface_id: str):
        global_scope = Scope.get_global_scope()
        for decl in global_scope.decls.values():
            if decl['decl_type'] == 'interface' and decl['id'] == interface_id:
                return decl
        return None

    @staticmethod
    def get_interface_prototypes(interface_id: str):
        interface = Scope.get_interface(interface_id)
        return interface_id['prototypes']
