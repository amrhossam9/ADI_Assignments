import math
import numpy as np

def _calc(x, y, theta):
    theta = math.radians(theta)
    x_new = x * np.cos(theta) - y * np.sin(theta)
    y_new = x * np.sin(theta) + y * np.cos(theta)

    return x_new, y_new

def _test(x, y, theta, scaling=8):
    x_new, y_new = _calc(x, y, theta)

    x_scaled = x * 2**scaling
    y_scaled = y * 2**scaling
    theta_scaled = theta * 2**scaling

    x_new_scaled = x_new * 2**scaling
    y_new_scaled = y_new * 2**scaling

    print(f"test('d{int(x_scaled)}, 'd{int(y_scaled)}, 'd{int(theta_scaled)}); // x = {x}, y = {y}, theta = {theta}")
    print(f"checkout('d{int(x_new_scaled)}, 'd{int(y_new_scaled)}, 'd{int((2**scaling) * 0.001)}); // x_n = {x_new}, y_n = {y_new}")

_test(1,0, 45)
_test(1,0, 30)
_test(1,0, 60)
_test(1,0, 90)
_test(1,0.125, 67)
_test(1,0, 30)
_test(0.125,1, 30)
_test(5,12, 30)

_test(1, 0, -45)
