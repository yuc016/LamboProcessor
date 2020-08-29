// Date: 8/24/2020
// Design Name: LamboProcessor
// Module Name: Top Level
// Credit: John Eldon -- CSE141L Intro to Computer Architecture starter code

module TopLevel(   // you will have the same 3 ports
	input Reset,   // init/reset, active high
          Start,   // start next program
          Clk,	   // clock -- posedge used inside design
	output logic Ack	   // done flag from DUT
);

wire [9:0] PgmCtr, PCTarg;
wire [8:0] Instruction;
wire [7:0] ReadA, ReadB;    // reg_file outputs
wire [7:0] InA, InB, 	    // ALU operand inputs
           ALU_out;         // ALU result
wire [7:0] RegWriteValue,   // data in to reg file
           MemWriteValue,   // data in to data_memory
           MemReadValue;    // data out from data_memory
wire [2:0] Waddr;
wire Immediate,
     RegSet,
     IsLoadingReg,
     Halt,
     Shift,
     RDX,
     MemToReg,
     MemWriteEn,
     RegWriteEn,
     BranchEn,
     ConditionBranch;

logic[15:0] CycleCt;

assign Ack = !Reset & Halt;

// Instruction ROM -- holds the machine code pointed to by program counter
InstROM #(.W(9)) IR (
    .InstAddress  (PgmCtr), 
    .InstOut      (Instruction)
);

// Instruction Fetcher -- determines the program counter value
InstFetch IF (
    .Reset           (Reset),
    .Start           (Start),
    .Clk             (Clk),
    .BranchEn        (BranchEn),
    .ConditionBranch (ConditionBranch),
    .GE_Flag         (GE_Flag),             // Is Greater&equal branch flag
    .BranchOffset    (Instruction[4:0]),
    .ProgCtr         (PgmCtr)
);					  

// Instruction Decoder -- decodes instructions and set control logic
Ctrl Ctrl (
    .Instruction  (Instruction),
    .Immediate    (Immediate),
    .RegSet       (RegSet),
    .BranchEn     (BranchEn),
    .ConditionBranch (ConditionBranch),
    .Halt		  (Halt),
    .Shift        (Shift),
    .RDX          (RDX),
    .MemToReg     (MemToReg),
    .RegWriteEn   (RegWriteEn),
    .MemWriteEn   (MemWriteEn)
);

assign Waddr = (RDX | RegSet) ? Instruction[2:0] : Instruction[5:3];

// Register file -- holds processor's registers
RegFile #(.W(8),.D(3)) RF (	// D(3) makes this 8 elements deep
    .Clk,
    .Reset        (Reset),
    .RegSet       (RegSet),
    .WriteEn      (RegWriteEn), 
    .RaddrA       (Instruction[5:3]),
    .RaddrB       (Instruction[2:0]), 
    .Waddr        (Waddr),
    .DataIn       (RegWriteValue), 
    .IsLoadingReg (IsLoadingReg),
    .DataOutA     (ReadA), 
    .DataOutB     (ReadB)
);

assign InA = ReadA;
assign InConstant = {5'b0, Instruction[2:0]};
assign InB = Immediate ? InConstant : ReadB;
assign RegWriteValue = IsLoadingReg ? Instruction : 
                       MemToReg ? MemReadValue : ALU_out;
// Arithematic Logic Unit -- performs operations on operands and spits out result
ALU ALU  (
    .InA     (InA),
    .InB     (InB), 
    .Opcode  (Instruction[8:6]),
    .RDX     (RDX),
    .Shift   (Shift),
    .Out     (ALU_out),
    .GE_Flag (GE_Flag)
);

// Data memory -- holds memory registers
DataMem DM(
    .DataAddress  (ReadA), 
    .WriteEn      (MemWrite), 
    .DataIn       (MemWriteValue), 
    .DataOut      (MemReadValue), 
    .Clk,
    .Reset        (Reset)
);
	
/* count number of instructions executed
	  not part of main design, potentially useful
	  This one halts when Ack is high  
*/
always_ff @(posedge Clk)
  if (Reset == 1)	   // if(start)
  	CycleCt <= 0;
  else if(Ack == 0)   // if(!halt)
  	CycleCt <= CycleCt+16'b1;

endmodule