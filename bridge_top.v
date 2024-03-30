module bridge_top(input hclk,hresetn,hwrite,hreadyin
  input[31:0] hwdata,haddr,prdata
  input[1:0] htrans,
  output pwrite,penable,pwrite,hr_readyout,
  output[2:0]pselx
  output[31:0] paddr,pwdata,hrdata);
  wire valid;
  wire [31:0] hwdata_1, hwdata_2, haddr_1, haddr_2;
  wire [2:0] temp_selx;
  
  AHB_slave_interface AHB_s(hclk,hrstn,hwrite,hreadyin,htrans,hresp,hwdata,haddr,prdata
                            valid,hwrite_reg,hwrite_reg_1,
                            haddr_1, haddr_2,hwdata_1, hwdata_2,hrdata,temp_selx);

  APB_controller APB_c(hclk,hrstn,hwrite,hwrite_reg,valid,
                       haddr,haddr_1, haddr_2,hwdata,hwdata_1, hwdata_2,prdata,
                       temp_selx,penable,pwrite,hr_readyout,paddr,pwdata,pselx);

endmodule