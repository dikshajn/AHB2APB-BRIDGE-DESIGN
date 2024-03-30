module AHB_slve_interface(input hclk,hresetn,hwrite,hreadyin,
                          input[1:0]htrans,hresp,
                          input[31:0]hwdat,haddr,prdata
                          output reg valid,hwrite_reg,hwrite_reg_1,
                          output reg [31:0]haddr_1,haddr_2,hwdata_1,hwdata_2,
                          output reg [2:0]temp_selx,
                          output reg [31:0]hrdata);




 always@(posedge hclk) //posedge becoz for positive edge we are getting output 
  begin
   if(!hresetn) //active low reset
        begin 
         haddr_1<=0;     //pipelining 2 state temporary logic
         haddr_2<=0;
        end 
   else //if hresetn is high keep the data sent by ahb master
    begin 
      haddr_1<=haddr;
      haddr_2<=haddr_1;
     end 
    end

//pipeline logic
//for hwdata
 always@(posedge hclk) //posedge becoz for positive edge we are getting output 
  begin
   if(!hresetn) //active low reset
        begin 
         hwdata_1<=0;
         hwdata_2<=0;
        end 
   else //if hresetn is high keep the data sent by ahb master
    begin 
      hwdata_1<=hwdata;
      hwdata_2<=hwdata_1;
     end 
    end


//pipeline logic
// using reg for hwrite_reg
always@(posedge hclk) //posedge becoz for positive edge we are getting output 
  begin
   if(!hresetn) //active low reset
        begin 
         hwrite_reg<=0;
         hwrite_reg_1<=0;
        end 
   else //if hresetn is high keep the data sent by ahb master
    begin 
      hwrite_reg<=hwrite;
      hwrite_reg_1<=hwrite_reg;
     end 
    end


//valid logic 
//valid to check from peripheral memory map 
// valid can be tell using Haddr and Hreadyin and Htrans 
always@(*) //combinational logic 
  begin
   valid=1'b0;
    if(hreadyin==1&&haddr>=32'h8000_0000&&haddr<32h'8c00_0000&&htrans==2'b10||htrans==2'b11)
        begin 
         valid=1;
        end 
    else //if hresetn is high keep the data sent by ahb master
     begin 
      valid=0;
     end 
    end


//temp select with the help of peripheral map
//temp selct will be 3 bit data 3'b001 , 3'b010 ,3'b100
always@(*) //combinational logic 
  begin
   temp_selx=3'b000;
    if(haddr>=32'h8000_0000&&haddr<32'h8400_0000)
     begin 
   temp_selx=3'b001;
     end 
    else if(haddr>=32'h8400_0000&&haddr<32'h8800_0000)
     begin 
      temp_selx=3'b010;
     end 
    else
     begin 
      temp_selx=3'b000;
     end 
    end
 assign hrdata=prdata;
endmodule 


