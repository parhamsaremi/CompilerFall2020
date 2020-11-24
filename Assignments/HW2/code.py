def parseE():
    parseT()
    parseEp()
    if tokern == "\$":
        return "success"
    else:
        return "error"


def parseEp():
    if token == "+":
        token = nextToken()
        parseE()
    elif token == "-":
        token = nextToken()
        parseE()
    elif token == "\$":
        return
    else:
        return "error"
def pareT():
    parseB()
    parseT()
def parseB():
    if token == "1":
        token = nextToken()
        parseC()
    else:
        return "error"
def parseC():
    if token == "1" or token == "0":
        token = nextToken()
        return
    else:
        return "error"
