import re   
while True:
    s = input()
    if re.match("^(-|\+)?(0\d*)$",s):
        print(int(s,8), "octate")
    if re.match("^(-|\+)?0(x|X)([0-9a-fA-F]+)$",s):
        print((int(s,0)), "hex")
    if re.match("^(-|\+)?[1-9]\d+$",s):
        print((int(s)), "decimal")
