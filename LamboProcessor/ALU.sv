// Date: 8/24/2020
// Module Name: Arithematic Logic Unit
import definitions::*;

module ALU (
  input [7:0] InA, InB,
  input [2:0] Opcode,
  input RDX,
  input Shift,
  output logic [7:0] Out,
  output logic GE_FlagSet
);
  
  wire [7:0] LFSR_Out;
  LFSR_Acc lfsr_acc(InA, InB, LFSR_Out);

  logic [7:0] zero = 7'b0;

  wire [7:0] Sub = InA - InB;

  always_comb begin
    Out = 0;       
    GE_FlagSet = 0;
    case(Opcode)
      _CMP : begin
            GE_FlagSet = (Sub[7] == 0) ? 1 : 0;
            Out = InB + 1;
        end
      _BRANCH: Out = Shift ? LFSR_Out : 0;
      _XOR : Out = InA ^ InB;
      _ADD : Out = InA + InB;
      _SUB : Out = InA - InB;
      _LSHIFT : Out = RDX ? ^(InB) : InA << InB;
    endcase
    if (Shift)
        Out = LFSR_Out;
  end

op_mne op_mnemonic;	// type enum: used for convenient waveform viewing
always_comb op_mnemonic = op_mne'(Opcode); // displays operation name in waveform viewer


endmodule

module LFSR_Acc(
  input [6:0] Pattern,
  input [6:0] LFSR,
  output [7:0] Result
);

assign Result = {1'b0, LFSR[5:0], ^(Pattern&LFSR)};

endmodule

