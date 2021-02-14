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
        if type_['is_arr']:
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
        if type_1['is_arr'] == type_2['is_arr'] and \
            type_1['type'] == type_2['type'] and type_1['class'] == type_2['class']:
            return True
        return False