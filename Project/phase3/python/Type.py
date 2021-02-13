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

