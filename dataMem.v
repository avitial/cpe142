module dataMem(clk, rst, address, readData, writeData, MemRead, MemWrite);
  // Variables
  parameter addressSize = 16;
  parameter dataSize = 16;
  parameter Countloc = (1 << addrSize);
  integer m;
  // Input ports
  input clk, rst;
  input [dataSize-1:0]writeData;
  input [addressSize-1:0]address;
  input MemRead, MemWrite;
  // Output ports
  output [dataSize-1:0]readData;

  reg[dataSize-1:0]
  always@(posedge clk or negedge rst)
    begin
      if(!rst)
        begin
        for(m=0; m<Countloc; m++)
          begin
            Location[m] <=m== 0?16'h2bc:{dataSize{1'b0}};
          end
        end
      else
        begin
        if(MemWrite)
          begin
            Location[address] <=writeData;
          end
        end
      end

  assign readData = (MemRead)?
         Location[address]:{dataSize{1'bz}};
endmodule
