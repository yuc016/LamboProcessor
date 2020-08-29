// Date: 8/24/2020
// Module Name: Register File

module RegFile #(parameter W=8, D=4)(
    input Clk,
          Reset,
          RegSet,
          WriteEn,
    input [D-1:0] RaddrA,
                  RaddrB,
                  Waddr,
    input [W-1:0] DataIn,
    output IsLoadingReg,
    output [W-1:0] DataOutA,
    output [W-1:0] DataOutB
);

// W bits wide and 2**4 registers deep 	 
logic IsLoading;
logic [D-1:0] LoadingReg;
logic [W-1:0] Registers[2**D];

wire [D-1:0] Waddr_final;

assign IsLoadingReg = IsLoading;
assign DataOutA = Registers[RaddrA];
assign DataOutB = Registers[RaddrB];

assign Waddr_final = IsLoading ? LoadingReg : Waddr;

always_ff @ (posedge Clk) begin
    if(RegSet) begin
        IsLoading <= 1'b1;
        LoadingReg <= RaddrB;
    end
    if(IsLoading | WriteEn & ~Reset) begin
        Registers[Waddr_final] <= DataIn;
    end
    if(IsLoading | Reset) begin
        IsLoading <= 1'b0;
    end 
end

endmodule
