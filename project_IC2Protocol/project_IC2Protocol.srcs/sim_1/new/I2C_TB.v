`timescale 1ns / 1ps

module i2c_master_tb(

    );
    reg main_clk = 0;
    reg rst = 1;
		 
    //clock gen
	always begin
	  main_clk = ~main_clk;
	end

    wire scl;
    wire sda;
	 
	pullup p1(scl); // pullup scl line
	pullup p2(sda); // pullup sda line
	
	reg enable = 0;
	reg rw = 0;
	reg [7:0] mosi = 0;
	reg [7:0] reg_addr = 0;
    reg [6:0] device_addr = 7'b001_0001;       
    reg [15:0] divider = 16'h0003;
    
    wire [7:0] miso;
    wire       busy;

	i2c_master #(.DATA_WIDTH(8),.REG_WIDTH(8),.ADDR_WIDTH(7)) 
        i2c_master_inst(
            .i_clk(main_clk),
            .i_rst(rst),
            .i_enable(enable),
            .i_rw(rw),
            .i_mosi_data(mosi),
            .i_reg_addr(reg_addr),
            .i_device_addr(device_addr),
            .i_divider(divider),
            .o_miso_data(miso),
            .o_busy(busy),
            .io_sda(sda),
            .io_scl(scl)
    );

    reg  [7:0] read_data = 0;
    wire [7:0] data_to_write = 8'h01;
    reg  [7:0] proc_cntr = 0;
    reg  [15:0] X_data = 0;
    reg  [15:0] Y_data = 0;

	always@(posedge main_clk)begin
        if(proc_cntr < 20 && proc_cntr > 5)begin
            proc_cntr <= proc_cntr + 1;
        end
        case (proc_cntr)
            0: begin
                rst <= 1;
                proc_cntr <= proc_cntr + 1;
            end
            1: begin
                rst <= 0;
                proc_cntr <= proc_cntr + 1;
            end
            //set configration first
            2: begin
                rw <= 0; //write operation
                reg_addr <= 8'h09; //writing to slave register 0
                mosi <= data_to_write; //data to be written
                device_addr = 7'b011_0000; //slave address
                divider = 16'h007C; //divider value for i2c serial clock
                proc_cntr <= proc_cntr + 1;
            end
            3: begin
                //if master is not busy set enable high
                if(busy == 0)begin
                    enable <= 1;
                    $display("Enabled write");
                    proc_cntr <= proc_cntr + 1;
                end
            end
            4: begin
                //once busy set enable low
                if(busy == 1)begin
                    enable <= 0;
                    proc_cntr <= proc_cntr + 1;
                end
            end
            5: begin
                //as soon as busy is low again an operation has been completed
                if(busy == 0) begin
                    proc_cntr <= proc_cntr + 1;
                    $display("Master done writing");
                end
            end
            20: begin
                rw <= 1; //read operation
                reg_addr <= 8'h08; //reading from slave register 00001000
                device_addr = 7'b011_0000; //slave address
                divider = 16'h007C; //divider value for i2c serial clock
                proc_cntr <= proc_cntr + 1;
            end
            21: begin
                if(busy == 0)begin
                    enable <= 1;
                    $display("Enabled read");
                    proc_cntr <= proc_cntr + 1;
                end
            end
            22: begin
                if(busy == 1)begin
                    enable <= 0;
                    proc_cntr <= proc_cntr + 1;
                end
            end
            23: begin
                if(busy == 0)begin
                    read_data <= miso;
                    proc_cntr <= proc_cntr + 1;
                    $display("Master done reading");
                end
            end
            24: begin
                if(read_data == 8'h01)begin
                    $display("Measurement is done!");
                    proc_cntr <= proc_cntr + 1;
                end
                else begin
                    $display("Still calculating measurement!");
                    proc_cntr <= 21;
                end
            end
            25: begin
                rw <= 1; //read operation
                reg_addr <= 8'h00; //reading from slave register 00000000
                device_addr = 7'b011_0000; //slave address
                divider = 16'h007C; //divider value for i2c serial clock
                proc_cntr <= proc_cntr + 1;
            end
            26: begin
                if(busy == 0)begin
                    enable <= 1;
                    $display("Enabled read");
                    proc_cntr <= proc_cntr + 1;
                end
            end
            27: begin
                if(busy == 1)begin
                    enable <= 0;
                    proc_cntr <= proc_cntr + 1;
                end
            end
            28: begin
                if(busy == 0)begin
                    X_data[15:8] <= miso;
                    proc_cntr <= proc_cntr + 1;
                    $display("Master done reading");
                end
            end
            29: begin
                rw <= 1; //read operation
                reg_addr <= 8'h01; //reading from slave register 00000001
                device_addr = 7'b011_0000; //slave address
                divider = 16'h007C; //divider value for i2c serial clock
                proc_cntr <= proc_cntr + 1;
            end
            30: begin
                if(busy == 0)begin
                    enable <= 1;
                    $display("Enabled read");
                    proc_cntr <= proc_cntr + 1;
                end
            end
            31: begin
                if(busy == 1)begin
                    enable <= 0;
                    proc_cntr <= proc_cntr + 1;
                end
            end
            32: begin
                if(busy == 0)begin
                    X_data[7:0] <= miso;
                    proc_cntr <= proc_cntr + 1;
                    $display("Master done reading");
                end
            end
            33: begin
                rw <= 1; //read operation
                reg_addr <= 8'h02; //reading from slave register 00000002
                device_addr = 7'b011_0000; //slave address
                divider = 16'h007C; //divider value for i2c serial clock
                proc_cntr <= proc_cntr + 1;
            end
            34: begin
                if(busy == 0)begin
                    enable <= 1;
                    $display("Enabled read");
                    proc_cntr <= proc_cntr + 1;
                end
            end
            35: begin
                if(busy == 1)begin
                    enable <= 0;
                    proc_cntr <= proc_cntr + 1;
                end
            end
            36: begin
                if(busy == 0)begin
                    Y_data[15:8] <= miso;
                    proc_cntr <= proc_cntr + 1;
                    $display("Master done reading");
                end
            end
            37: begin
                rw <= 1; //read operation
                reg_addr <= 8'h03; //reading from slave register 00000003
                device_addr = 7'b011_0000; //slave address
                divider = 16'h007C; //divider value for i2c serial clock
                proc_cntr <= proc_cntr + 1;
            end
            38: begin
                if(busy == 0)begin
                    enable <= 1;
                    $display("Enabled read");
                    proc_cntr <= proc_cntr + 1;
                end
            end
            39: begin
                if(busy == 1)begin
                    enable <= 0;
                    proc_cntr <= proc_cntr + 1;
                end
            end
            40: begin
                if(busy == 0)begin
                    Y_data[7:0] <= miso;
                    proc_cntr <= proc_cntr + 1;
                    $display("Master done reading");
                    $stop;
                end
            end
        endcase 
	end
endmodule
