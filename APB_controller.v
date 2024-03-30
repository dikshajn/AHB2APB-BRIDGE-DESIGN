//we will write 3 logics 1)present state , next state 2)temporary logic 3)output logic
module APB_Controller (
  input hclk,hresetn,valid
  input[31:0] hwdata1,hwdata2,haddr1,haddr
  input hwritereg
  input[2:0] temp_selx,
  output reg penable,pwrite
  output[2:0]pselx
  output[31:0] paddr,pwdata,prdata
);

reg[31:0] paddr_temp,pwrite_temp;
reg[2:0] psel_temp;
reg[2:0]ps,ns;
reg penable_temp;
 
reg[2:0] ps,ns;

  //parameter
  parameter(
  ST_IDLE:3'b000
  ST_WWAIT:3'b001
  ST_WRITEP:3'b010
  ST_WENABLEP:3'b011
  ST_WRITE:3'b100
  ST_WENABLE:3'b101
  ST_READ:3'b110
  ST_RENABLE:3'b111	
)


  // present state logic , sequential
 always @(posedge hclk)
  begin
   if(!hrstn)
   ps<=ST_IDLE//ps<=1'b0;
   else
   ps<=ns;
  end

  // burst read transfer
 always @(*)
  begin
   case(ps)
   ns=ST_IDLE; //first state
   ST_IDLE: if(valid==1 && hwrite==1)
             ns=ST_WWAIT;
           else if(valid && ~hwrite)
             ns=ST_READ;
           else (valid)
             ns=ST_IDLE;

   ST_WWAIT: if(valid==1 )
             ns=ST_WRITEP;
           else (valid)
             ns=ST_WRITE;

   ST_WRITEP: ns=ST_WENABLEP;

   ST_WENABLEP: if(valid==1 && hwritereg==1)
             ns=ST_WRITEP;
           else if(~valid && hwritereg)
             ns=ST_WRITE;
           else (~hwritereg)
             ns=ST_READ;

    ST_WRITE: if(valid==1 )
             ns=ST_WENABLE;
           else(~valid )
             ns=ST_WENABLEP;
           

   ST_WENABLE: if(valid==1 && hwrite==1)
             ns=ST_WWAIT;
           else if(valid && ~hwrite)
             ns=ST_READ;
           else (valid)
             ns=ST_IDLE;

   ST_READ: ns=ST_RENABLE;
             
   ST_RENABLE: if(valid==1 && hwrite==1)
             ns=ST_WWAIT;
           else if(valid && ~hwrite)
             ns=ST_READ;
           else (valid)
             ns=ST_IDLE;

   end
///TEMPORARY LOGIC AS WE NEED 1 CYCLE DELAY FOR OUTPUT , USE 1 TEMPORARY VARIABLE WHICH STORES AND PRODUCE IN NEXT CYCLE
always @(hclk)
 begin
     if(!hrestn)
        paddr=0
        pwrite=0
        psel<=0
        penable<0
        pwdata<=0
        hready_out<=0

     else
       begin
        paddr=paddr_temp;
        psel<=psel_temp;
        hready_out<=hready_out_temp;


//for burst read operation
always @(*)
  begin
     case(present)
      ST_IDLE:	
        if(valid && hwrite==0)
           begin
            paddr_temp=haddr;
                   pwrite_temp=hwrite;
                   psel_temp=temp_selx;
                   penable_temp=0;
                   hr_readyout_temp=0;
            end
        else if (valid && hwrite==1) //valis==1
            begin
           
                   
                   psel_temp=0;
                   penable_temp=0;
                   hr_readyout_temp=1;
            end
        else
            begin
            
                   
                   psel_temp=0;
                   penable_temp=0;
                   hr_readyout_temp=1;
            end


      ST_READ:	
        begin
                   penable_temp=1;
                   hr_readyout_temp=1;
        end
      ST_RENABLE:	
        begin
               paddr_temp=haddr;
                   pwrite_temp=hwrite;
                   psel_temp=temp_selx;
                   penable_temp=0;
                   hr_readyout_temp=0;
         end
// for burst write 
always @(*)
  begin
     case(present)
      ST_IDLE:	
        if(valid && hwrite==0)
           begin
            paddr_temp=haddr;
                   pwrite_temp=hwrite;
                   psel_temp=temp_selx;
                   penable_temp=0;
                   hr_readyout_temp=0;
            end
        else if (valid && hwrite==1) //valis==1
            begin
           
                   
                   psel_temp=0;
                   penable_temp=0;
                   hr_readyout_temp=1;
            end
        else
            begin
            
                   
                   psel_temp=0;
                   penable_temp=0;
                   hr_readyout_temp=1;
            end


      ST_WWAIT:	
        begin
                paddr_temp=haddr1;
                   pwrite_temp=1;
                   psel_temp=1;
                   penable_temp=0;
                   hr_readyout_temp=0;
        end
      ST_WRITE:	
        begin
               paddr_temp=haddr;
                   pwrite_temp=hwrite;
                   psel_temp=temp_selx;
                   penable_temp=1;
                   hr_readyout_temp=1;
         end         
      ST_WENABLEP:	
        begin
               paddr_temp=haddr2;
                   pwrite_temp=hwrite;
                   psel_temp=temp_selx;
                   penable_temp=0;
                   hr_readyout_temp=0;
                   pwdata_temp=hwdata;	
         end                   
///OUTPUT LOGIC IS SEQUENTIAL
always @(posedge hclk)
 begin
  if(!hrestn)
   paddr<=0
   pwrite<=0
   pselx<=0
   penable<=0
   pwdata<=0
   h_ready_out<=0
  end

  else(!hrestn)
   begin
    paddr<=paddr_temp
    pwrite<=0
    pselx<=psel_temp
    penable<=0
    pwdata<=0
    h_ready_out<=h_ready_out_temp
   end



endmodule

