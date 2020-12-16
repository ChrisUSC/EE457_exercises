// EE457 RTL Exercises
// min_max_finder_part1.v (Part 1 uses two conparison units)
// Written by Nasir Mohyuddin, Gandhi Puvvada 
// June 5, 2010, 
// Given an array of 16 unsigned 8-bit numbers, we need to find the maximum and the minimum number

 
// Students: Please complete the code for the Data path and State transition operations in LOAD and COMPUTE states
`timescale 1 ns / 100 ps

module min_max_finder_part1 (Max, Min, Start, Clk, Reset, 
				           Qi, Ql, Qc, Qd);

input Start, Clk, Reset;
output [7:0] Max, Min;
output Qi, Ql, Qc, Qd;

reg [7:0] M [0:15]; 
//reg [7:0] X;
reg [3:0] state;
reg [7:0] Max;
reg [7:0] Min;
reg [3:0] I;

localparam 
INI  = 	4'b0001, // "Initial" state
LOAD = 	4'b0010, // "Load Max and Min with 1st Element" state
COMP = 	4'b0100, // "Compare each number with Min and Max and Update Min/Max if needed" state
DONE = 	4'b1000; // "Done finding Min and Max" state
         
         
assign {Qd, Qc, Ql, Qi} = state;

always @(posedge Clk, posedge Reset) 

  begin  : CU_n_DU
    if (Reset)
       begin
         state <= INI;
         I <= 4'bXXXX;
	      Max <= 8'bXXXXXXXX;
	      Min <= 8'bXXXXXXXX;
	//      X <= 8'bXXXXXXXX;	   // to avoid recirculating mux controlled by Reset 
	    end
    else
       begin
           case (state)
	        INI	: 
	          begin
		         // state transitions in the control unit
		         if (Start)
		           state <= LOAD;
		         // RTL operations in the Data Path            	              
		        I <= 0;
	          end
	        LOAD	:  	// complete the code for the Data path and State transition operations
	          begin
		        // RTL operations in the Data Path  
		        // Load M[I] into Max
			Max <= M[I];
		        // Load M[I] into Min
			Min <= M[I];
		        // Increment I
			I <= I + 1;
		        // state transitions in the control unit
		        // Transit unconditionally to the COMP state  
			state <= COMP;       
 	          end
	        
	        COMP :		// complete the code for the Data path and State transition operations
	          begin 
	             // RTL operations in the Data Path   		                  	                  
			if(M[I] > Max) // if M[I] is greater than Max
				begin          
					Max <= M[I];   // then load Max with M[I]
				end
			if(M[I] < Min) // if M[I] is less than Min
				begin
					Min <= M[I];   // then load Min with M[I]
				end
					// state transitions in the control unit       
			if(I == 15)                // If I reaches Max count (Terminal Count)
				begin 
					state <= DONE;      // then transit to the DONE state. 
				end
				  // We do not have to explicitly say that it should otherwise stay in the current state of COMP.
			 // Increment I outside the if statement (out side begin-end of the if statement if you used begin-end		
				I <= I + 1;		
	          end
	        
	        DONE	:
	          begin  
		         // state transitions in the control unit
		           state <= INI; // Transit to INI state unconditionally
		       end    
      endcase
    end 
  end 
endmodule  

