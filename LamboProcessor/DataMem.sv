// Date: 8/24/2020
// Module Name: Data Memory
//    (single address pointer for both read and write)

module DataMem(
  input Clk, Reset, WriteEn,
  input [7:0] DataAddress, DataIn,
  output logic [7:0] DataOut
);

logic [7:0] Core[256]; // Memory

assign DataOut = Core[DataAddress];    

/* optional way to plant constants into DataMem at startup
    initial 
      $readmemh("dataram_init.list", Core);
*/

always_ff @ (posedge Clk)
    if(Reset) begin
        for(int i=0;i<256;i++)
            Core[i] <= 0;
    end 
    else if(WriteEn) begin
        Core[DataAddress] <= DataIn;
    end
endmodule
