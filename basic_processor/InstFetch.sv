// Date: 8/24/2020
// Module Name: Instruction Fetcher

module InstFetch(
    input              Reset,			   // reset, init, etc. -- force PC to 0 
                        Start,			   // begin next program in series (request issued by test bench)
                        Clk,			   // PC can change on pos. edges only
                        BranchEn,
                        ConditionBranch,
                        GE_Flag,        // Greater equal than branch flag
    input        [4:0] BranchOffset,
    output logic [9:0] ProgCtr           // the program counter register itself
);

wire [9:0] ExtendedOffset = {BranchOffset[4] * 4, BranchOffset[4:0]};
wire BranchTaken = BranchEn & (!ConditionBranch | GE_Flag);
	 
// program counter can clear to 0, increment, or jump
always_ff @(posedge Clk)	           // or just always; always_ff is a linting construct
	if(Reset)
	    ProgCtr <= 0;				       // for first program; want different value for 2nd or 3rd
	else if(Start)					   // hold while start asserted; commence when released
	    ProgCtr <= ProgCtr;
    else if (BranchTaken)
        ProgCtr <= ProgCtr + ExtendedOffset;
    else
	    ProgCtr <= ProgCtr+'b1; 	       // default increment (no need for ARM/MIPS +4 -- why?)
endmodule

/* Note about Start: if your programs are spread out, with a gap in your machine code listing, you will want 
to make Start cause an appropriate jump. If your programs are packed sequentially, such that program 2 begins 
right after Program 1 ends, then you won't need to do anything special here. 
*/