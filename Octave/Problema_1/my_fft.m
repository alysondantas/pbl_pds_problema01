% Cálculo da FFT de um sinal no domínio do tempo.
%	    Sintaxe: [y] = my_fft(t,x,fs)
%             Entradas:
%                 t  = vetor de tempo 
%                 x  = amostras do sinal
%                 fs = frequência de amostragem do sinal.
%             Saídas:
%                 f = vetor de frequências
%                 Y = valores do módulo de X(jW)
function [f,Y]  = my_fft(t,x,fs)
X          = fft(x);
Y          = fftshift(X);
N          = length(x);
fshift     = (-N/2:N/2-1)*(fs/N);
powershift = abs(Y)/(N/2);
f = fshift;
Y = powershift; 
return
