import sys
shell = ""
print "Process is begining.... in a while"
print "Welcome to XOR encoder"
encoded = []
for opcode in shell:
        new_opcode = (ord(opcode) ^ 0x01)
        encoded.append(new_opcode)
       
print "Encoding opcode process completed..."
print "".join(["\\x{0}".format(hex(abs(i)).replace("0x", "")) for i in encoded])
print "null"
