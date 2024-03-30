module APB_controller();

  // Declare input/output for testbench
  reg valid, hclk, hrstn, reset, hwrite;
  reg [31:0] hwdata_1, hwdata_2, haddr_1, haddr_2;
  wire penable, pwrite;
  wire [31:0] pwdata, paddr, prdata;
  
  // Instantiate APB_Controller module
  APB_controller DUT (
    .hclk(hclk),
    .hresetn(hrstn),
    .valid(valid),
    .hwdata1(hwdata_1),
    .hwdata2(hwdata_2),
    .haddr1(haddr_1),
    .haddr2(haddr_2),
    .hwritereg(hwrite),
    .temp_selx({3'b001, 3'b010, 3'b100}),
    .penable(penable),
    .pwrite(pwrite),
    .pselx({3'b000}),
    .paddr(paddr),
    .pwdata(pwdata),
    .prdata(prdata)
  );

  // Task to reset the module
  task task_res();
    begin
      @(negedge hclk)
        reset = 1'b0;
      @(negedge hclk)
        reset = 1'b1;
    end
  endtask

  // Initial block to apply stimuli
  initial begin
    task_res// Call the task to reset
    valid = 1'b1;
    hwrite = 1'b1;
    haddr=32'h8100_0000;
    haddr_1 = 32'h8200_0000;
    haddr_2 = 32'h8200_0004; // Assuming it's a 32-bit address
    hwdata = 'd32;
    hwdata_1= 'd45;
    hwdata_2='d52;
    prdata='d543
    temp_selx = 3'b001;

 

    #1000 $finish; // Finish the simulation after a delay
  end

  // Add any additional monitors or assertions here

endmodule

