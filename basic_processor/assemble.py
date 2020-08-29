# This is the assembler for the Lambo Processor
# Usage: python assemble.py assembly_code.txt

import sys

def bStr(i):
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
        exit("Register not supported\n")

# MAIN

if len(sys.argv) != 3:
    exit("Usage: python assemble.py assembly_code.txt machine_code.txt\n")

infile_name = sys.argv[1]
outfile_name = sys.argv[2]
print("assemble.py: Assembling ", infile_name, " and outputting to ", outfile_name)

with open(infile_name, 'r') as infile, open(outfile_name, 'r') as outfile:
    num_inst = 0
    branch_dst = {}

    line = infile.readline()
    while line:
        line = line.replace("r", '')
        line = line.replace("#", '')
        line = line.replace(",", '')
        line = line.split("//")[0]

        args = line.split()
        line = infile.readline()

        if len(args) == 0: # Empty line
            continue

        # Branch
        if ':' in args[0]: 
            branch_dst[args[0]] = num_inst 
            continue

        op = args[0]

        try:
            if op == "CMP":
                op1Str = bStr(int(args[1]))
                op2Str = bStr(int(args[2]))
                outfile.write("000" + op1Str + op2Str)
            elif op == "BGE":
                op1Str = bStr(int(args[1]))
                outfile.write("0011" + op1Str)
            elif op == "B":
                op1Str = bStr(int(args[1]))
                outfile.write("0010" + op1Str)
            elif op == "LDR":
                op1Str = bStr(int(args[1]))
                op2Str = bStr(int(args[2]))
                outfile.write("010" + op1Str + op2Str)
            elif op == "STR":
                op1Str = bStr(int(args[1]))
                op2Str = bStr(int(args[2]))
                outfile.write("011" + op1Str + op2Str)
            elif op == "XOR":
                op1Str = bStr(int(args[1]))
                op2Str = bStr(int(args[2]))
                outfile.write("100" + op1Str + op2Str)
            elif op == "ADD":
                op1Str = bStr(int(args[1]))
                op2Str = bStr(int(args[2]))
                outfile.write("101" + op1Str + op2Str)
            elif op == "SUB":
                op1Str = bStr(int(args[1]))
                op2Str = bStr(int(args[2]))
                outfile.write("110" + op1Str + op2Str)
            elif op == "LSL":
                op1Str = bStr(int(args[1]))
                op2Str = bStr(int(args[2]))
                outfile.write("111" + op1Str + op2Str)
            elif op == "SHIFT":                          # Special Case "SHIFT"
                outfile.write("001010000")
            elif op == "HALT":                           # Special Case "HALT"
                outfile.write("001110000")                           
            elif op == "RDX":                            # Special Case "RDX"
                op1Str = bStr(int(args[1]))              
                outfile.write("111110" + op1Str)
            elif op == "MOV":                            # Special operation "MOV"
                op1Str = bStr(int(args[1]))              
                outfile.write("111111" + op1Str)
        except(IndexError):
            exit("Invalid format: " + args[0] + " " + args[1] + " " + args[2] + '\n')
        

print("Assembling complete with no error!")







