import numpy as np
import matplotlib.pyplot as plt

# Parameters
fs = 1e6  # Sampling frequency (1 MHz)
f_signal = 100e3  # Signal frequency (100 kHz)
T = 1  # Signal duration in seconds
IRR_dB = 25  # Desired image rejection ratio in dB

# Time vector
t = np.arange(0, T, 1/fs)

# Generate single-tone signal (baseband)
z_I = np.cos(2 * np.pi * f_signal * t)  # In-phase component
z_Q = np.sin(2 * np.pi * f_signal * t)  # Quadrature component

# Original complex signal (without imbalance)
z_original = z_I + 1j * z_Q

# Assuming the values for g and phi to achieve -25 dB image rejection
g = 0.94  # Gain imbalance
phi = np.radians(5.5)  # Phase imbalance (5 degrees)

# Apply imbalance
z_I_prime = z_I  # In-phase component remains unchanged
z_Q_prime = g * (np.cos(phi) * z_Q - np.sin(phi) * z_I)  # Quadrature component is imbalanced

# Imbalanced complex signal
z_prime = z_I_prime + 1j * z_Q_prime

# QEC Algorithm
# Estimate gain and phase
g_est = np.sqrt(np.sum(np.abs(z_Q_prime)**2) / np.sum(np.abs(z_I_prime)**2))
phi_est = np.sum(z_I_prime * z_Q_prime) / np.sqrt(np.sum(np.abs(z_I_prime)**2) * np.sum(np.abs(z_Q_prime)**2))

# Correct the imbalance
z_I_corrected = z_I_prime
z_Q_corrected = np.tan(phi) * z_I_prime +  (1 / (g * np.cos(phi))) * z_Q_prime

# Corrected complex signal
z_corrected = z_I_corrected + 1j * z_Q_corrected

# Apply windowing to reduce spectral leakage (Hann window)
window = np.hanning(len(z_prime))

# Perform FFT for all signals to analyze frequency domain
Z_original = np.fft.fftshift(np.fft.fft(z_original * window))
Z_prime = np.fft.fftshift(np.fft.fft(z_prime * window))
Z_corrected = np.fft.fftshift(np.fft.fft(z_corrected * window))
frequencies = np.fft.fftshift(np.fft.fftfreq(len(t), 1/fs))

# Convert to dB scale
Z_original_dB = 20 * np.log10(np.abs(Z_original))
Z_prime_dB = 20 * np.log10(np.abs(Z_prime))
Z_corrected_dB = 20 * np.log10(np.abs(Z_corrected))

# Signal and image power in the imbalanced signal
signal_power = np.max(Z_prime_dB[frequencies >= 0])  # Power of the main signal (positive frequencies)
image_power = np.max(Z_prime_dB[frequencies < 0])  # Power of the image (negative frequencies)

# Calculate Image Rejection Ratio (IRR)
image_rejection_ratio = signal_power - image_power

# Signal and image power in the corrected signal
signal_power_corrected = np.max(Z_corrected_dB[frequencies >= 0])  # Power of the main signal (positive frequencies)
image_power_corrected = np.max(Z_corrected_dB[frequencies < 0])  # Power of the image (negative frequencies)

# Calculate Image Rejection Ratio (IRR) after correction
image_rejection_ratio_corrected = signal_power_corrected - image_power_corrected

# Print verification outputs
print(f"Signal Power (dB) - Original: {np.max(Z_original_dB[frequencies >= 0])}")
print(f"Image Power (dB) - Original: {np.max(Z_original_dB[frequencies < 0])}")
print(f"Signal Power (dB) - Imbalanced: {signal_power}")
print(f"Image Power (dB) - Imbalanced: {image_power}")
print(f"Image Rejection Ratio (dB) - Imbalanced: {image_rejection_ratio}")
print(f"Signal Power (dB) - Corrected: {signal_power_corrected}")
print(f"Image Power (dB) - Corrected: {image_power_corrected}")
print(f"Image Rejection Ratio (dB) - Corrected: {image_rejection_ratio_corrected}")

plt.figure(figsize=(12, 8))

# Create 3 subplots (1 row, 3 columns)
plt.subplot(1, 3, 1)
plt.plot(frequencies / 1e3, Z_original_dB, label="Original Signal", linestyle='--', color='blue')
plt.title("Original Signal")
plt.xlabel("Frequency (kHz)")
plt.ylabel("Magnitude (dB)")
plt.grid(True)

plt.subplot(1, 3, 2)
plt.plot(frequencies / 1e3, Z_prime_dB, label=f"Imbalanced Signal (-{IRR_dB} dB image rejection)", color='red')
plt.title("Imbalanced Signal")
plt.xlabel("Frequency (kHz)")
plt.ylabel("Magnitude (dB)")
plt.grid(True)

plt.subplot(1, 3, 3)
plt.plot(frequencies / 1e3, Z_corrected_dB, label="Corrected Signal", linestyle='-.', color='green')
plt.title("Corrected Signal")
plt.xlabel("Frequency (kHz)")
plt.ylabel("Magnitude (dB)")
plt.grid(True)

plt.tight_layout()  # Adjust spacing between subplots
plt.show()

# Output imbalance parameters
print(f"Applied Gain Imbalance (g): {g}")
print(f"Applied Phase Imbalance (phi in degrees): {np.degrees(phi)}")
print(f"Estimated Gain Imbalance (g_est): {g_est}")
print(f"Estimated Phase Imbalance (phi_est in degrees): {np.degrees(phi_est)}")
