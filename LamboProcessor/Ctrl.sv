// Date: 8/24/2020
// Module Name: Control

import definitions::*;

// control decoder (combinational, not clocked)
// inputs from instrROM, ALU flags
// outputs to program_counter (fetch unit)
module Ctrl (
  input [8:0] Instruction,	   // machine code
  input IsLoadingReg,
  output logic 
    Immediate,
    RegSet,
    BranchEn,
    ConditionBranch,
    Halt,
    Shift, // LFSR Shift
    RDX,
    MemToReg,
    RegWriteEn,
    MemWriteEn,
    Inc
);

wire [2:0] Opcode = Instruction[8:6];

assign Immediate = (Opcode == _LSHIFT) & ~(Instruction[5:3] == 3'b110);

assign RegSet = (Opcode == _LSHIFT) & (Instruction[5:3] == 3'b111) & !IsLoadingReg;

// Branch related control
assign ConditionBranch = Instruction[5];
assign BranchOpSpecial = ~|(Instruction[3:0]);
assign BranchEn = (Opcode == _BRANCH) & !BranchOpSpecial &!IsLoadingReg;

// Special op with abnormal opcode
assign Halt = (Opcode == _BRANCH) & ConditionBranch & BranchOpSpecial & !IsLoadingReg;
assign Shift = (Opcode == _BRANCH) & !ConditionBranch & BranchOpSpecial &!IsLoadingReg;
assign RDX = (Opcode == _LSHIFT) & (Instruction[5:3] == 3'b110);
assign Inc = (Opcode == _CMP) & (Instruction[5:3] == 3'b111);

assign MemToReg = (Opcode == _LOAD) & !IsLoadingReg;
assign RegWriteEn = ((Opcode == _LOAD) | (Opcode == _XOR) | 
                    (Opcode == _ADD) | (Opcode == _SUB) | 
                    (Opcode == _LSHIFT) | Inc | Shift) & !IsLoadingReg;
assign MemWriteEn = (Opcode == _STORE) & !IsLoadingReg;

endmodule

