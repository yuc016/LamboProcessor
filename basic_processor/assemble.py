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
            elif op == "BGE" or op == "B":
                pass
            elif op == "LDR":
                pass
            elif op == "STR":
                pass
            elif op == "XOR":
                pass
            elif op == "ADD":
                pass
            elif op == "SUB":
                pass
            elif op == "LSL":
                pass
            elif op == "SHIFT":
                pass
            elif op == "HALT":
                pass
            elif op == "RDX":
                pass
            elif op == "MOV":
                pass
        except(IndexError):
            exit("Invalid format: " + args[0] + " " + args[1] + " " + args[2] + '\n')
        



print("Assembling complete with no error!")



