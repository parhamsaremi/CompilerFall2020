import re   
while True:
    s = input()
    for i in re.finditer("((-|\+)?0(x|X)([0-9a-fA-F]+))|((-|\+)?(0\d*))|((-|\+)?[1-9]\d+)",s):
        a = i.group(0)
        if re.match("^(-|\+)?(0\d*)$",a):
            print(int(a,8), "octate")
        if re.match("^(-|\+)?0(x|X)([0-9a-fA-F]+)$",a):
            print((int(a,0)), "hex")
        if re.match("^(-|\+)?[1-9]\d+$",a):
            print((int(a)), "decimal")
