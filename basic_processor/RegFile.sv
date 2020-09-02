// Date: 8/24/2020
// Module Name: Register File

module RegFile #(parameter W=8, D=4)(
    input Clk,
          Reset,
          Start,
          RegSet,
          WriteEn,
          Shift,
          GE_FlagSet,
    input [D-1:0] RaddrA,
                  RaddrB,
                  Waddr,
    input [W-1:0] DataIn,
    output IsLoadingReg,
            GE_Flag,
    output [W-1:0] DataOutA,
    output [W-1:0] DataOutB
);

// W bits wide and 2**4 registers deep 	 
logic IsLoading, GE_FlagReg;
logic [D-1:0] LoadingReg;
logic [W-1:0] Registers[2**D];

wire [D-1:0] Waddr_final;

assign IsLoadingReg = IsLoading;
assign DataOutA = Shift ? Registers[6] : Registers[RaddrA];
assign DataOutB = Shift ? Registers[7] :Registers[RaddrB];
assign GE_Flag = GE_FlagReg;

assign Waddr_final = Shift ? 'b111 : IsLoading ? LoadingReg : Waddr;

always_ff @ (posedge Clk) begin
    if(RegSet & !Reset & !Start) begin
        IsLoading <= 1'b1;
        LoadingReg <= RaddrB;
    end
    if((IsLoading | WriteEn) & !Reset & !Start) begin
        Registers[Waddr_final] <= DataIn;
    end
    if(IsLoading | Reset) begin
        IsLoading <= 1'b0;
        GE_FlagReg <= 1'b0;
    end 
    if(Reset) begin
        for(int i=0;i<2**D;i++)
            Registers[i] <= 0;
    end

    if(GE_FlagSet) 
        GE_FlagReg <= 1'b1;
    else 
        GE_FlagReg <= 1'b0;
end

endmodule
