import math

# Function to generate atan table based on given scale
def generate_atan_table(scale, width=16, iterations=15):
    atan_values = []
    
    for i in range(iterations):
        # Calculate atan(2^-i) and scale it
        atan_val = math.degrees(math.atan(2 ** -i)) * scale
        # Convert to fixed-point by scaling and rounding
        atan_fixed = int(round(atan_val))
        atan_values.append(atan_fixed)
    
    # Generate the Verilog format
    verilog_output = []
    for idx, value in enumerate(atan_values):
        verilog_output.append(f"atan_table[{idx}] = {width}'d{value};     // atan(2^-{idx})")

    return verilog_output

# User input for scale factor
scale = 2**8

# Generate and print the atan table in Verilog format
verilog_table = generate_atan_table(scale)
print("\n".join(verilog_table))

# To calculate the gain factor

# res = 1
# for i in range(15):
#     res *= math.cos(math.atan(2**(-i)))

# print(1.0/res)

