from Scope import Scope
from Class import Class

class Type:
    def __init__(self):
        pass

    @staticmethod
    def is_bool(type_: dict):
        if type_['class'] == 'Primitive' and type_['type'] == 'bool':
            return True
        return False

    @staticmethod
    def is_int(type_: dict):
        if type_['class'] == 'Primitive' and type_['type'] == 'int':
            return True
        return False

    @staticmethod
    def is_double(type_: dict):
        if type_['class'] == 'Primitive' and type_['type'] == 'double':
            return True
        return False

    @staticmethod
    def is_string(type_: dict):
        if type_['class'] == 'Primitive' and type_['type'] == 'string':
            return True
        return False

    @staticmethod
    def is_object(type_: dict):
        if type_['type'] == 'Object':
            return True
        return False

    @staticmethod
    def is_arr(type_: dict):
        if type_['dim'] >= 1:
            return True
        return False

    @staticmethod
    def is_void(type_: dict):
        # TODO check that in every case, 'class' of 'void' is set to 'Primitive' (in 1st and 2nd traverse)
        if type_['class'] == 'Primitive' and type_['type'] == 'void':
            return True
        return False

    @staticmethod
    def are_types_equal(type_1: dict, type_2: dict):
        if type_1['dim'] == type_2['dim'] and \
            type_1['type'] == type_2['type'] and type_1['class'] == type_2['class']:
            return True
        return False

    @staticmethod
    def are_types_assignable(l_type: dict, r_type: dict):
        if Type.are_types_equal(l_type, r_type):
            return True
        if not Type.is_object(l_type) or not Type.is_object(r_type):
            return False
        r_class = Scope.get_class(r_type['class'])
        for interface in r_class['interfaces']:
            interface_id = interface['id']
            if l_type['class'] == interface_id:
                return True
        # TODO may be we should check interfaces of parent classes too. java has it, but i'm not sure decaf supports it too ...
        parent_id = r_class['parent_class']
        while True:
            if parent_id is None:
                break
            if parent_id == r_class['class']:
                return True
            parent = Scope.get_class(parent_id)
            parent_id = parent['parent_class']
        return False