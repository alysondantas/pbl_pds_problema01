function [t_sample,sinal_sample] = ventilador(f, fs, stoptime)
% %% dados do sinal
% f = 1000;%Freq entrada Hz
% fs =500;% Frequencia de amostragem Hz
%% gerar sinal
%% sinal amostrado
Ts = 1/fs;
t_sample = (0 : Ts : stoptime);
N=length(t_sample);
n = (0:1:N-1);
DigitalFrequency=2*pi*f/fs;
sinal_sample = sin (DigitalFrequency.*n);

return