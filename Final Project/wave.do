onerror {resume}
radix fpoint 8
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {FSM
} -radix decimal /TOP_TB/DUT/FSM_U0/R
add wave -noupdate -expand -group {FSM
} /TOP_TB/DUT/FSM_U0/curr_state
add wave -noupdate -expand -group {FSM
} /TOP_TB/DUT/FSM_U0/RST
add wave -noupdate -expand -group {FSM
} /TOP_TB/DUT/FSM_U0/CLK
add wave -noupdate -expand -group {FSM
} /TOP_TB/DUT/FSM_U0/start
add wave -noupdate -expand -group {FSM
} -radix decimal /TOP_TB/DUT/FSM_U0/ip_matrix
add wave -noupdate -expand -group {FSM
} -radix decimal /TOP_TB/DUT/FSM_U0/theta_q
add wave -noupdate -expand -group {FSM
} -radix decimal /TOP_TB/DUT/FSM_U0/start_q
add wave -noupdate -expand -group {FSM
} -radix decimal /TOP_TB/DUT/FSM_U0/theta1
add wave -noupdate -expand -group {FSM
} -radix decimal /TOP_TB/DUT/FSM_U0/cos_th1
add wave -noupdate -expand -group {FSM
} -radix decimal /TOP_TB/DUT/FSM_U0/sin_th1
add wave -noupdate -expand -group {FSM
} -radix decimal /TOP_TB/DUT/FSM_U0/theta2
add wave -noupdate -expand -group {FSM
} -radix decimal /TOP_TB/DUT/FSM_U0/cos_th2
add wave -noupdate -expand -group {FSM
} -radix decimal /TOP_TB/DUT/FSM_U0/sin_th2
add wave -noupdate -expand -group {FSM
} -radix decimal /TOP_TB/DUT/FSM_U0/theta3
add wave -noupdate -expand -group {FSM
} -radix decimal /TOP_TB/DUT/FSM_U0/cos_th3
add wave -noupdate -expand -group {FSM
} -radix decimal /TOP_TB/DUT/FSM_U0/sin_th3
add wave -noupdate -expand -group {FSM
} -radix decimal /TOP_TB/DUT/FSM_U0/Q_t
add wave -noupdate -expand -group {FSM
} -radix decimal /TOP_TB/DUT/FSM_U0/R_inv
add wave -noupdate -expand -group {FSM
} -radix decimal /TOP_TB/DUT/FSM_U0/op_matrix
add wave -noupdate -expand -group {FSM
} /TOP_TB/DUT/FSM_U0/done
add wave -noupdate -expand -group {FSM
} -color Yellow -radix decimal /TOP_TB/DUT/FSM_U0/x_vict
add wave -noupdate -expand -group {FSM
} -color Yellow -radix decimal /TOP_TB/DUT/FSM_U0/theta_vict
add wave -noupdate -expand -group {FSM
} -color Yellow /TOP_TB/DUT/FSM_U0/valid_vict
add wave -noupdate -expand -group {FSM
} -color Yellow -radix decimal /TOP_TB/DUT/FSM_U0/x0_vict
add wave -noupdate -expand -group {FSM
} -color Yellow -radix decimal /TOP_TB/DUT/FSM_U0/y0_vict
add wave -noupdate -expand -group {FSM
} -color Yellow -radix decimal /TOP_TB/DUT/FSM_U0/start_vict
add wave -noupdate -expand -group {FSM
} -color Blue -radix decimal /TOP_TB/DUT/FSM_U0/x_rot
add wave -noupdate -expand -group {FSM
} -color Blue -radix decimal /TOP_TB/DUT/FSM_U0/y_rot
add wave -noupdate -expand -group {FSM
} -color Blue /TOP_TB/DUT/FSM_U0/valid_rot
add wave -noupdate -expand -group {FSM
} -color Blue -radix decimal /TOP_TB/DUT/FSM_U0/theta_rot
add wave -noupdate -expand -group {FSM
} -color Blue -radix symbolic /TOP_TB/DUT/FSM_U0/start_rot
add wave -noupdate -expand -group {FSM
} -color Blue -radix decimal /TOP_TB/DUT/FSM_U0/x0_rot
add wave -noupdate -expand -group {FSM
} -color Blue -radix decimal /TOP_TB/DUT/FSM_U0/y0_rot
add wave -noupdate -expand -group {FSM
} /TOP_TB/DUT/FSM_U0/sin_rot
add wave -noupdate -expand -group {FSM
} /TOP_TB/DUT/FSM_U0/cos_rot
add wave -noupdate -expand -group {FSM
} /TOP_TB/DUT/FSM_U0/valid_angle
add wave -noupdate -expand -group {FSM
} /TOP_TB/DUT/FSM_U0/next_state
add wave -noupdate -group {cordic_rotating_U0
} /TOP_TB/DUT/cordic_rotating_U0/WIDTH
add wave -noupdate -group {cordic_rotating_U0
} /TOP_TB/DUT/cordic_rotating_U0/ITERATIONS
add wave -noupdate -group {cordic_rotating_U0
} /TOP_TB/DUT/cordic_rotating_U0/clk
add wave -noupdate -group {cordic_rotating_U0
} /TOP_TB/DUT/cordic_rotating_U0/rst
add wave -noupdate -group {cordic_rotating_U0
} /TOP_TB/DUT/cordic_rotating_U0/start
add wave -noupdate -group {cordic_rotating_U0
} /TOP_TB/DUT/cordic_rotating_U0/x_in
add wave -noupdate -group {cordic_rotating_U0
} /TOP_TB/DUT/cordic_rotating_U0/y_in
add wave -noupdate -group {cordic_rotating_U0
} /TOP_TB/DUT/cordic_rotating_U0/theta_in
add wave -noupdate -group {cordic_rotating_U0
} /TOP_TB/DUT/cordic_rotating_U0/valid
add wave -noupdate -group {cordic_rotating_U0
} /TOP_TB/DUT/cordic_rotating_U0/x_out
add wave -noupdate -group {cordic_rotating_U0
} /TOP_TB/DUT/cordic_rotating_U0/y_out
add wave -noupdate -group {cordic_rotating_U0
} /TOP_TB/DUT/cordic_rotating_U0/atan_table
add wave -noupdate -group {cordic_rotating_U0
} /TOP_TB/DUT/cordic_rotating_U0/x_reg
add wave -noupdate -group {cordic_rotating_U0
} /TOP_TB/DUT/cordic_rotating_U0/y_reg
add wave -noupdate -group {cordic_rotating_U0
} /TOP_TB/DUT/cordic_rotating_U0/z_reg
add wave -noupdate -group {cordic_rotating_U0
} /TOP_TB/DUT/cordic_rotating_U0/iter
add wave -noupdate -group {cordic_rotating_U0
} /TOP_TB/DUT/cordic_rotating_U0/busy
add wave -noupdate -group {cordic_rotating_U1
} /TOP_TB/DUT/cordic_rotating_U1/WIDTH
add wave -noupdate -group {cordic_rotating_U1
} /TOP_TB/DUT/cordic_rotating_U1/ITERATIONS
add wave -noupdate -group {cordic_rotating_U1
} /TOP_TB/DUT/cordic_rotating_U1/clk
add wave -noupdate -group {cordic_rotating_U1
} /TOP_TB/DUT/cordic_rotating_U1/rst
add wave -noupdate -group {cordic_rotating_U1
} /TOP_TB/DUT/cordic_rotating_U1/start
add wave -noupdate -group {cordic_rotating_U1
} /TOP_TB/DUT/cordic_rotating_U1/x_in
add wave -noupdate -group {cordic_rotating_U1
} /TOP_TB/DUT/cordic_rotating_U1/y_in
add wave -noupdate -group {cordic_rotating_U1
} /TOP_TB/DUT/cordic_rotating_U1/theta_in
add wave -noupdate -group {cordic_rotating_U1
} /TOP_TB/DUT/cordic_rotating_U1/valid
add wave -noupdate -group {cordic_rotating_U1
} /TOP_TB/DUT/cordic_rotating_U1/x_out
add wave -noupdate -group {cordic_rotating_U1
} /TOP_TB/DUT/cordic_rotating_U1/y_out
add wave -noupdate -group {cordic_rotating_U1
} /TOP_TB/DUT/cordic_rotating_U1/atan_table
add wave -noupdate -group {cordic_rotating_U1
} /TOP_TB/DUT/cordic_rotating_U1/x_reg
add wave -noupdate -group {cordic_rotating_U1
} /TOP_TB/DUT/cordic_rotating_U1/y_reg
add wave -noupdate -group {cordic_rotating_U1
} /TOP_TB/DUT/cordic_rotating_U1/z_reg
add wave -noupdate -group {cordic_rotating_U1
} /TOP_TB/DUT/cordic_rotating_U1/iter
add wave -noupdate -group {cordic_rotating_U1
} /TOP_TB/DUT/cordic_rotating_U1/busy
add wave -noupdate -group {cordic_vectoring
} /TOP_TB/DUT/cordic_vectoring_U0/WIDTH
add wave -noupdate -group {cordic_vectoring
} /TOP_TB/DUT/cordic_vectoring_U0/ITERATIONS
add wave -noupdate -group {cordic_vectoring
} /TOP_TB/DUT/cordic_vectoring_U0/clk
add wave -noupdate -group {cordic_vectoring
} /TOP_TB/DUT/cordic_vectoring_U0/rst
add wave -noupdate -group {cordic_vectoring
} /TOP_TB/DUT/cordic_vectoring_U0/start
add wave -noupdate -group {cordic_vectoring
} /TOP_TB/DUT/cordic_vectoring_U0/x_in
add wave -noupdate -group {cordic_vectoring
} /TOP_TB/DUT/cordic_vectoring_U0/y_in
add wave -noupdate -group {cordic_vectoring
} /TOP_TB/DUT/cordic_vectoring_U0/valid
add wave -noupdate -group {cordic_vectoring
} /TOP_TB/DUT/cordic_vectoring_U0/x_out
add wave -noupdate -group {cordic_vectoring
} /TOP_TB/DUT/cordic_vectoring_U0/z_out
add wave -noupdate -group {cordic_vectoring
} /TOP_TB/DUT/cordic_vectoring_U0/atan_table
add wave -noupdate -group {cordic_vectoring
} /TOP_TB/DUT/cordic_vectoring_U0/x_reg
add wave -noupdate -group {cordic_vectoring
} /TOP_TB/DUT/cordic_vectoring_U0/y_reg
add wave -noupdate -group {cordic_vectoring
} /TOP_TB/DUT/cordic_vectoring_U0/z_reg
add wave -noupdate -group {cordic_vectoring
} /TOP_TB/DUT/cordic_vectoring_U0/iter
add wave -noupdate -group {cordic_vectoring
} /TOP_TB/DUT/cordic_vectoring_U0/busy
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1517801 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 296
configure wave -valuecolwidth 222
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {1116736 ns} {1636200 ns}
