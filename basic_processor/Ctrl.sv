// Date: 8/24/2020
// Module Name: Control

import definitions::*;

// control decoder (combinational, not clocked)
// inputs from instrROM, ALU flags
// outputs to program_counter (fetch unit)
module Ctrl (
  input [8:0] Instruction,	   // machine code
  output logic 
    Immediate,
    RegSet,
    BranchEn,
    ConditionBranch,
    Halt,
    Shift,
    RDX,
    MemToReg,
    RegWriteEn,
    MemWriteEn
);

wire [2:0] Opcode = Instruction[8:6];

assign Immediate = (Opcode == _LSHIFT);

assign RegSet = (Opcode == _LSHIFT) & (Instruction[5:3] == 3'b111);

// Branch related control
assign ConditionBranch = Instruction[5];
assign BranchOpSpecial = |(Instruction[3:0]);
assign BranchEn = (Opcode == _BRANCH) & !BranchOpSpecial;

// Special op with abnormal opcode
assign Halt = (Opcode == _CMP) & ConditionBranch & BranchOpSpecial;
assign Shift = (Opcode == _CMP) & !ConditionBranch & BranchOpSpecial;
assign RDX = (Opcode == _LSHIFT) & (Instruction[5:3] == 3'b110);

assign MemToReg = (Opcode == _LOAD);
assign RegWriteEn = (Opcode == _LOAD) | (Opcode == _XOR) | (Opcode == _ADD) | (Opcode == _SUB) | (Opcode == _LSHIFT);
assign MemWriteEn = (Opcode == _STORE);

endmodule

