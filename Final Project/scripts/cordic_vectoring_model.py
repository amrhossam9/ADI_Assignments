import math
import numpy as np

def _calc(x, y):
    # Correcting for division by zero and sign of angle
    if x == 0:
        if y > 0:
            theta = 90
        elif y < 0:
            theta = -90
        else:
            theta = 0
        x_new = abs(y)  # Magnitude is just the absolute value of y when x is zero
    else:
        x_new = math.sqrt(x**2 + y**2)  # Corrected for CORDIC gain
        theta = math.degrees(math.atan2(y, x))    # atan2 handles full circle angles

    return x_new, theta

def _test(x, y, scaling=8):
    x_new, theta = _calc(x, y)

    x_scaled = x * 2**scaling
    y_scaled = y * 2**scaling

    x_new_scaled = x_new * 2**scaling
    theta_scaled = theta * 2**scaling  # You may need to rethink scaling angles appropriately

    print(f"test('d{int(x_scaled)}, 'd{int(y_scaled)}); // x = {x}, y = {y}")
    print(f"checkout('d{int(x_new_scaled)}, 'd{int(theta_scaled)}, 'd{int((2**scaling) * 0.001)}); // x_n = {x_new}, theta = {theta}")

# Testing with sample values
_test(4, 6)
_test(1, 2)
_test(3, 4)
_test(5, 9)
_test(6, 7)
_test(1.67, 0)
_test(1, 0)