def alert(text):
    print('\033[91m' + str(text) + '\033[0m')
    print('\033[91m' + '---------------------------------------------' +
          '\033[0m')


class Class:
    classes = {}

    def __init__(self, class_decl: dict):
        self.id = class_decl['id']
        self.decl = class_decl.copy()
        self.object_layout = {}
        self.main_vtable = {}
        self.interface_vtables = {}

    @staticmethod
    def get_variable_fields(class_: dict):
        return [
            field for field in class_.decl['fields']
            if field['decl_type'] == 'variable'
        ]

    @staticmethod
    def get_variable_fields_with_id(class_id: str):

        class_ = Class.get_class(class_id)
        return [
            field for field in class_.decl['fields']
            if field['decl_type'] == 'variable'
        ]

    @staticmethod
    def get_function_fields(class_: dict):
        return [
            field for field in class_.decl['fields']
            if field['decl_type'] == 'function'
        ]

    @staticmethod
    def get_interfaces_with_id(class_id: str):
        class_ = Class.get_class(class_id)
        # TODO

    @staticmethod
    def get_class(id_: str):
        return Class.classes[id_]

    @staticmethod
    def get_func_info(class_id: str, id_: str):
        class_ = Class.classes[class_id]
        # TODO

    @staticmethod
    def get_variable_info(class_id: str, var_id: str):
        class_ = classes[class_id]
        return class_.object_layout[(
            var_id, 'variable')]  # TODO offset and access mode

    @staticmethod
    def get_var_field(class_id: str, field_id: str):
        # TODO access mode not handled yet
        class_ = Class.get_class(class_id)
        if class_.object_layout.keys().__contains__((field_id, 'variable')):
            return class_.object_layout[(field_id, 'variable')]
        return None