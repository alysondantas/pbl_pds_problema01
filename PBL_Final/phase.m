function [f,Y]  = phase(x,fs)
y  = fft(x);
z  = fftshift(y);
ly = length(y);
fr  = (-ly/2:ly/2-1)/ly*fs;
tol = 1e-6;
z(abs(z) < tol) = 0;
theta = angle(z);
f = fr;
Y = theta/pi;
return