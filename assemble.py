# This is the assembler for the Lambo Processor
# Usage: python assemble.py assembly_code.txt

import sys

def bStr(i, nine_bit=False, five_bit=False):
    if five_bit:
        s = ""
        s = bin(i & 0b11111)
        s = s.replace("0b", '')
        while len(s) != 5:
            s = '0' + s
        return s

    if nine_bit:
        s = bin(i)
        s = s.replace("0b", '')
        if len(s) > 9:
            exit("Invalid format: " + args[0] + " " + args[1] + " " + args[2] + '\n')
        while len(s) != 9:
            s = '0' + s
        return s

    if i == 1:
        return "000"
    elif i == 2:
        return "001"
    elif i == 3:
        return "010"
    elif i == 4:
        return "011"
    elif i == 5:
        return "100"
    elif i == 6:
        return "101"
    elif i == 7:
        return "110"
    elif i == 8:
        return "111"
    else:
        exit("Invalid register " + str(i) + " for operation " + args[0] + '\n')

# MAIN

if len(sys.argv) != 3:
    exit("Usage: python assemble.py assembly_code.txt machine_code.txt\n")

infile_name = sys.argv[1]
outfile_name = sys.argv[2]
print("Assembling", infile_name, "\nOutput: ", outfile_name)

inst = []
branch_dst = dict()

with open(infile_name, 'r') as infile:
    num_inst = 0

    line = infile.readline()
    while line:
        line = line.upper()
        for i in range(1, 9):
            line = line.replace("R" + str(i), str(i))
        line = line.replace("#", '')
        line = line.replace(",", '')
        line = line.replace("[", '')
        line = line.replace("]", '')
        line = line.split("//")[0]

        args = line.split()
        line = infile.readline()

        if len(args) == 0: # Empty line
            continue

        # Branch
        if ':' in args[0]: 
            branch_dst[args[0].upper().replace(":", "")] = num_inst 
            continue

        op = args[0]

        try:
            if op == "CMP":
                op1Str = bStr(int(args[1]))
                op2Str = bStr(int(args[2]))
                inst.append("000" + op1Str + op2Str + "\n")
            elif op == "BGE":
                inst.append("0011" + ":" + str(num_inst) + ":" + args[1])
            elif op == "B":
                inst.append("0010" + ":" + str(num_inst) + ":" + args[1])
            elif op == "LDR":
                op1Str = bStr(int(args[1]))
                op2Str = bStr(int(args[2]))
                inst.append("010" + op1Str + op2Str + "\n")
            elif op == "STR":
                op1Str = bStr(int(args[1]))
                op2Str = bStr(int(args[2]))
                inst.append("011" + op1Str + op2Str + "\n")
            elif op == "XOR":
                op1Str = bStr(int(args[1]))
                op2Str = bStr(int(args[2]))
                inst.append("100" + op1Str + op2Str + "\n")
            elif op == "ADD":
                op1Str = bStr(int(args[1]))
                op2Str = bStr(int(args[2]))
                inst.append("101" + op1Str + op2Str + "\n")
            elif op == "SUB":
                op1Str = bStr(int(args[1]))
                op2Str = bStr(int(args[2]))
                inst.append("110" + op1Str + op2Str + "\n")
            elif op == "LSL":
                op1Str = bStr(int(args[1]))
                op2Str = bStr(int(args[2]) + 1)
                inst.append("111" + op1Str + op2Str + "\n")
            elif op == "SHIFT":                          # Special Case "SHIFT"
                inst.append("001010000\n")
            elif op == "HALT":                           # Special Case "HALT"
                inst.append("001110000\n")                           
            elif op == "RDX":                            # Special Case "RDX"
                op1Str = bStr(int(args[1]))              
                inst.append("111110" + op1Str + "\n")
            elif op == "MOV":                            # Special operation "MOV"
                op1Str = bStr(int(args[1]))              
                inst.append("111111" + op1Str + "\n")
                inst.append(bStr(int(args[2]), True) + "\n")
                num_inst += 1
            elif op == "INC":
                op1Str = bStr(int(args[1])) 
                inst.append("000111" + op1Str + "\n")             
            else:
                exit("Invalid Operation: " + args[0] + '\n')
            
            num_inst += 1
        except(IndexError):
            exit("Invalid format for: " + args[0] + "at instruction " + num_inst + '\n')


print(branch_dst)

for i in range(0, len(inst)):
    if ':' in inst[i]:
        branch_args = inst[i].split(':')
        offset = branch_dst[branch_args[2]] - int(branch_args[1])
        offset_str = bStr(branch_dst[branch_args[2]] - int(branch_args[1]), False, True)
        inst[i] = branch_args[0] + offset_str + ("\n")


with open(outfile_name, 'w') as outfile:
    for i in range(0, len(inst)):
        outfile.write(inst[i])

print("Assembling complete with no error!")







