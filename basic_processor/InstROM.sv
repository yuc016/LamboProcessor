// Date: 8/24/2020
// Design Name: 
// Module Name:    InstROM 
// Project Name:   CSE141L
// Tool versions: 
// Description: Verilog module -- instruction ROM template	
//	 preprogrammed with instruction values (see case statement)
//
// Revision: 2020.08.08
//
module InstROM #(parameter A=10, W=10) (
  input       [A-1:0] InstAddress,
  output logic [W-1:0] InstOut
);
	 
logic[W-1:0] inst_rom[2**A];
always_comb InstOut = inst_rom[InstAddress];

// assign inst_rom = {
//     // r1 = 1
//     // r2 = 2
//     // r3 = -1
//     // r4 = -2
//     'b111111000, 
//     'b000000001, 
//     'b111111001, 
//     'b000000010, 
//     'b111111011, 
//     'b111111111, 
//     'b111111100, 
//     'b111111110, 
//     'b101000001,
//     'b110001010
// };


// another (usually recommended) alternative expression
//   need $readmemh or $readmemb to initialize all of the elements
// declare 2-dimensional array, W bits wide, 2**A words deep
// logic[W-1:0] inst_rom[2**A];
// always_comb InstOut = inst_rom[InstAddress];

// initial begin		                  // load from external text file
//     $readmemb("program1_exe.txt", inst_rom);
// end 
  
endmodule
