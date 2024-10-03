import scipy.linalg as la
import numpy as np
import numpy as np

def rotate_point(x, y, theta_degrees):
    theta = np.radians(theta_degrees)  # convert degrees to radians
    rotation_matrix = np.array([[np.cos(theta), -np.sin(theta)],
                                [np.sin(theta),  np.cos(theta)]])
    
    point = np.array([x, y])
    rotated_point = np.dot(rotation_matrix, point)  # Matrix multiplication
    
    return rotated_point

# Example matrix A
A = np.array([[1, 1, 1],
              [0, 1, 1],
              [1, 1, 0]])

# Perform QR decomposition
Q, R = la.qr(A)
print(Q)
print(R)

