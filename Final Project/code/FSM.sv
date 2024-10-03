module FSM #(parameter DATA_WIDTH=32)(
	
	input RST,CLK,start,

	input signed [DATA_WIDTH-1:0] x_vict,theta_vict,
	input valid_vict,
	input signed [DATA_WIDTH-1:0] x_rot,y_rot,
	input valid_rot,
	input signed [DATA_WIDTH-1:0] sin_rot,cos_rot,
	input valid_angle,
	input signed [DATA_WIDTH-1:0]  ip_matrix [0:2] [0:2],


	output reg signed [DATA_WIDTH-1:0]  op_matrix [0:2] [0:2],
	output reg done,
	output reg signed [DATA_WIDTH-1:0] x0_vict,y0_vict,
	output reg start_vict,
	output reg signed [DATA_WIDTH-1:0] x0_rot,y0_rot,theta_rot,
	output reg start_rot,
	output reg signed [DATA_WIDTH-1:0] theta_q,
	output reg start_q
);

	////////////// signals  declaration ///////////

	reg signed [DATA_WIDTH-1:0] theta1,cos_th1,sin_th1;
	reg signed [DATA_WIDTH-1:0] theta2,cos_th2,sin_th2;
	reg signed [DATA_WIDTH-1:0] theta3,cos_th3,sin_th3;


	////////////// matrices declaration ///////////
	reg signed [DATA_WIDTH-1:0] Q_t   [0:2] [0:2];
	reg signed [DATA_WIDTH-1:0] R     [0:2] [0:2];
	reg signed [DATA_WIDTH-1:0] R_inv [0:2] [0:2];

	reg signed [DATA_WIDTH-1:0] tmp1, tmp2;


	typedef enum logic [3:0] {
		IDLE 		= 4'b0000,
		START 		= 4'b0001,
		eliminate_d = 4'b0010,
		calc_be 	= 4'b0011,
		get_be      = 4'b0100,
		calc_cf 	= 4'b0101,
		eliminate_g = 4'b0110,
		calc_bh 	= 4'b0111,
		get_bh		= 4'b1000,
		calc_ci 	= 4'b1001,
		eliminate_h = 4'b1010,
		calc_fi  	= 4'b1011,
		get_fi		= 4'b1100,
		calc_Qt 	= 4'b1101,
		calc_Rinv   = 4'b1110,
		calc_res 	= 4'b1111
	} state_t;


	state_t next_state , curr_state ;

	always@(posedge CLK or negedge RST) begin
		if(!RST)
		begin
			for (integer i=0; i<3; ++i) begin
				op_matrix[0][i] <= 0;
				op_matrix[1][i] <= 0;
				op_matrix[2][i] <= 0;
			end
			done <=0;
			x0_vict <= 0;
			y0_vict <= 0;
			start_vict <= 0;
			x0_rot <= 0;
			y0_rot <= 0;
			theta_rot <= 0;
			start_rot <= 0;
			theta_q <= 0;
			start_q <= 0;
			next_state<= IDLE;
		end
		else
			curr_state <= next_state;
	end

	
	always@(*) begin
		case(curr_state)
		IDLE: begin
			done = 1'b0;
			if(start)
			begin
				for (integer i=0; i<3; ++i) begin
					R[0][i]= ip_matrix[0][i];
					R[1][i]= ip_matrix[1][i];
					R[2][i]= ip_matrix[2][i];
				end
				next_state= START;
			end
			else next_state= IDLE;
		end
		
		START: begin
		
			next_state= eliminate_d ;
			start_vict= 1'b1;
			x0_vict= R[0][0];  //a
			y0_vict= R[1][0];  //d
			start_rot = 0;
			start_q = 0;

		end
		
		eliminate_d: begin
		
			if(valid_vict)
			begin
				R[0][0]= x_vict;  //new a
				R[1][0]= 0;  //new d
				theta1=theta_vict;
				start_vict = 0;
				start_rot = 0;
				start_q = 0;
				
				next_state= calc_be ;
			end
			else next_state= eliminate_d ;
		end
		
		calc_be: begin
		
				start_rot= 1'b1;
				x0_rot= R[0][1]; //b
				y0_rot= R[1][1]; //e
				theta_rot= theta1;
				
				start_q= 1'b1;
				theta_q= theta1;
				next_state=get_be;
		end
		
		get_be: begin // calculate sin,cos using vict and b,e using rotationa
		
			if(valid_angle && valid_rot)
			begin
			
				sin_th1= sin_rot;
				cos_th1= cos_rot;
				start_vict = 0;
				start_q = 0;
				
				R[0][1]=x_rot ; //b
				R[1][1]=y_rot ; //e
				
				start_rot= 1'b1;
				x0_rot= R[0][2]; //c
				y0_rot= R[1][2]; //f
				theta_rot= theta1;

				next_state= calc_cf;
			end
			
			else
				next_state=get_be;
		end
		
		calc_cf: begin 
		
			if(valid_rot)
			begin
			
				R[0][2]= x_rot; //c
				R[1][2]= y_rot; //f
				start_rot = 0;
				start_q = 0;
				next_state= eliminate_g;
				start_vict=1'b1;
				x0_vict=R[0][0]; //a
				y0_vict=R[2][0]; //g
			end
			
			else 
				next_state= calc_cf;
		end
		

		eliminate_g: begin 
		
			if(valid_vict)
			begin
			
				R[0][0]=x_vict; //a
				R[2][0]=1'b0; //g
				theta2=theta_vict;
				
				start_vict = 0;
				start_rot = 0;
				start_q = 0;
				next_state= calc_bh;
			end
			
			else 
				next_state= eliminate_g;
		end
		
		calc_bh: begin
		
				start_q=1'b1;
				theta_q=theta2;  
				start_vict = 0;
				start_rot=1'b1;
				x0_rot=R[0][1]; //b
				y0_rot=R[2][1]; //h
				theta_rot=theta2;	

				next_state= get_bh;
		end
		
		get_bh: begin // calculate sin,cos using vict and b,e using rotationa
		

			if(valid_angle && valid_rot)
			begin
			
				sin_th2= sin_rot;
				cos_th2= cos_rot;
				
				R[0][1]=x_rot ; //b
				R[2][1]=y_rot ; //h
				start_vict = 0;
				start_q = 0;
				
				next_state= calc_ci;
				start_rot= 1'b1;
				x0_rot= R[0][2]; //c
				y0_rot= R[2][2]; //i
				theta_rot= theta2;
			end
			
			else
				next_state=get_bh;
		end
		
		calc_ci: begin
		
			if(valid_rot)
			begin
			
				R[0][2]=x_rot; //c
				R[2][2]=-y_rot; //i

				next_state= eliminate_h;
				start_vict=1'b1;
				start_rot = 0;
				start_q = 0;
				x0_vict=R[1][1]; //e
				y0_vict=R[2][1]; //h
			end
			else
				next_state= calc_ci;
		end
		
		eliminate_h : begin
			if(valid_vict)
			begin
			
				R[1][1]=x_vict; //e
				R[2][1]=1'b0; //h
				theta3 = theta_vict;
				start_vict = 0;
				start_rot = 0;
				start_q = 0;
				
				next_state= calc_fi;
			end
			else
				next_state=eliminate_h;
		end
		
		calc_fi: begin

			start_rot=1'b1;
			x0_rot=R[1][2]; //f
			y0_rot=R[2][2]; //i
			theta_rot= theta3;
			start_vict = 0;
			
			start_q=1'b1;
			theta_q=theta3;
			next_state=get_fi;
		end
		
		get_fi: begin // calculate sin,cos using vict and b,e using rotationa
		
			if(valid_angle && valid_rot)
			begin
			
				sin_th3= sin_rot;
				cos_th3= cos_rot;
				start_vict = 0;
				start_rot = 0;
				start_q = 0;
				
				R[1][2]=x_rot ; //f
				R[2][2]=y_rot ; //i
				
				next_state=calc_Qt;
			end
			else
				next_state=get_fi;
		end
		
		calc_Qt: begin
		
			Qt();
			next_state= calc_Rinv;
		end
		
		calc_Rinv: begin
		
			c_Rinv();
			next_state= calc_res;
		end
		
		calc_res: begin
			done = 1;
			Result();
			next_state= IDLE;
			
		end
	
		endcase
	end
	function Qt();

		Q_t[0][0] =     (cos_th1*cos_th2) >>> 8;
		Q_t[1][0] = 	((sin_th1*cos_th3) >>> 8) - ((((cos_th1*sin_th2) >>> 8)*sin_th3) >>> 8);
		Q_t[2][0] = 	((sin_th1*sin_th3) >>> 8) - ((((cos_th1*sin_th2) >>> 8)*cos_th3) >>> 8);
		Q_t[0][1] = 	((-sin_th1*cos_th2) >>> 8);
		Q_t[1][1] = 	((cos_th1*cos_th3) >>> 8) + ((((sin_th1*sin_th2) >>> 8)*sin_th3) >>> 8);
		Q_t[2][1] = 	((cos_th1*sin_th3) >>> 8) - ((((sin_th1*sin_th3) >>> 8)*cos_th3) >>> 8);
		Q_t[0][2] = 	-sin_th2;
		Q_t[1][2] = 	((-cos_th2*sin_th3) >>> 8);
		Q_t[2][2] = 	((-cos_th2*cos_th3) >>> 8);
		
	endfunction
	
	function c_Rinv();
		
		R_inv[1][0] = 	'd0;
		R_inv[2][0] = 	'd0;
		R_inv[2][1] = 	'd0;
		
		R_inv[0][0] =   ((1 <<< 16) /R[0][0]) ;
		R_inv[0][1] = 	(-R[0][1] <<< 8) / ((R[0][0]*R[1][1]) >>> 8);
		R_inv[0][2] = 	((((R[0][1]*R[1][2]) >>> 8)-((R[0][2]*R[1][1]) >>> 8)) <<< 8) / ((R[0][0]*R[1][1]*R[2][2]) >>> 16);
		R_inv[1][1] = 	((1 <<< 16 )/R[1][1]);
		R_inv[1][2] = 	(-R[1][2] <<< 16)/((R[1][1]*R[2][2]));
		R_inv[2][2] = 	((1 <<< 16)/R[2][2]);
		
	endfunction
	
	function Result();
		
		// A[0][0] (Full calculation since no zeros)
		op_matrix[0][0] = ((R_inv[0][0] * Q_t[0][0]) >>> 8) + ((R_inv[0][1] * Q_t[1][0]) >>> 8) + ((R_inv[0][2] * Q_t[2][0]) >>> 8);

		// A[0][1] (Full calculation since no zeros)
		op_matrix[0][1] = ((R_inv[0][0] * Q_t[0][1]) >>> 8) + ((R_inv[0][1] * Q_t[1][1]) >>> 8) + ((R_inv[0][2] * Q_t[2][1]) >>> 8);

		// A[0][2] (Full calculation since no zeros)
		op_matrix[0][2] = ((R_inv[0][0] * Q_t[0][2]) >>> 8) + ((R_inv[0][1] * Q_t[1][2]) >>> 8) + ((R_inv[0][2] * Q_t[2][2]) >>> 8);

		// A[1][0] (Full calculation since no zeros)
		op_matrix[1][0] = ((R_inv[1][0] * Q_t[0][0]) >>> 8) + ((R_inv[1][1] * Q_t[1][0]) >>> 8) + ((R_inv[1][2] * Q_t[2][0]) >>> 8);

		// A[1][1] (Full calculation since no zeros)
		op_matrix[1][1] = ((R_inv[1][0] * Q_t[0][1]) >>> 8) + ((R_inv[1][1] * Q_t[1][1]) >>> 8) + ((R_inv[1][2] * Q_t[2][1]) >>> 8);

		// A[1][2] (Full calculation since no zeros)
		op_matrix[1][2] = ((R_inv[1][0] * Q_t[0][2]) >>> 8) + ((R_inv[1][1] * Q_t[1][2]) >>> 8) + ((R_inv[1][2] * Q_t[2][2]) >>> 8);

		// A[2][0] (Full calculation since no zeros)
		op_matrix[2][0] = ((R_inv[2][0] * Q_t[0][0]) >>> 8) + ((R_inv[2][1] * Q_t[1][0]) >>> 8) + ((R_inv[2][2] * Q_t[2][0]) >>> 8);

		// A[2][1] (Full calculation since no zeros)
		op_matrix[2][1] = ((R_inv[2][0] * Q_t[0][1]) >>> 8) + ((R_inv[2][1] * Q_t[1][1]) >>> 8) + ((R_inv[2][2] * Q_t[2][1]) >>> 8);

		// A[2][2] (Full calculation since no zeros)
		op_matrix[2][2] = ((R_inv[2][0] * Q_t[0][2]) >>> 8) + ((R_inv[2][1] * Q_t[1][2]) >>> 8) + ((R_inv[2][2] * Q_t[2][2]) >>> 8);


	endfunction

endmodule
