// Date: 8/24/2020
// Module Name: Arithematic Logic Unit
import definitions::*;

module ALU (
  input [7:0] InA, InB,
  input [2:0] Opcode,
  input RDX,
  input Shift,
  output logic [7:0] Out,
  output logic GE_Flag
);
  
  wire [7:0] LFSR_Out;
  LFSR_Acc lfsr_acc(InA, InB, LFSR_Out);

  logic [7:0] zero = 7'b0;

  always_comb begin
    Out = 0;       
    GE_Flag = 0;
    case(Opcode)
      _CMP : GE_Flag = (InA - InB >= 0) ? 1 : 0;
      _BRANCH: Out = Shift ? LFSR_Out : 0;
      _XOR : Out = InA ^ InB;
      _ADD : Out = InA + InB;
      _SUB : Out = InA - InB;
      _LSHIFT : Out = RDX ? ^(InB) : InA << InB;
    endcase
  end

endmodule

module LFSR_Acc(
  input [7:0] Pattern,
  input [7:0] LFSR,
  output [7:0] Result
);

assign Result = {LFSR[7:1], ^(Pattern&LFSR)};
  
op_mne op_mnemonic;	// type enum: used for convenient waveform viewing
always_comb op_mnemonic = op_mne'(Opcode); // displays operation name in waveform viewer


endmodule

