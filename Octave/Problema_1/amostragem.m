%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Disciplina: MI-Processamento Digital de Sinais
% Instituição: Uefs
% Período: 2022.2
% Projeto: Amostragem Natural (Gatilhamento)
% Discentes: 
%         - Gabriel Sá Barreto Alves
%         - Marcelo
%         - Allyson
%         - Lucas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear all; clc; %pkg load signal;
% Geração de um sinal contínuo no tempo e limitado em frequência;
% Definições no tempo para geração e amostragem do sinal de entrada:
amp      = 1;                 % Amplitude do Sinal;
freq     = 1000;              % Frequência do Sinal = 1kHz;
T        = 1/freq;             % Período do Sinal;
fs       = 3000000;           % Frequência de Amostragem para geração do sinal = 3000kHz = 3 MHz (amostras por segundo);
ts       = 1/fs;              % Período de Amostragem (um período para cada amostra);
stoptime = (2*T) - ts;        % Duração do Sinal em segundos (5 períodos);
t        = 0:ts:stoptime;     % Vetor de tempo;
% Geração de um sinal senoidal;
xt       = amp*sin(2*pi*freq*t);
N        = length(xt);    % Quantidade de amostras do sinal;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,1,1);
plot(t,xt, 'LineWidth',2);
grid on;
xlabel ('Tempo (s)' , 'fontsize', 14);
ylabel ("Amplitude", 'fontsize', 14);
title ("Sinal de Entrada no Domínio do Tempo", 'fontsize', 14);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Geração do trem de pulsos
amp  = 1;
duty = 33; 
freq = 1900;
pwm_signal = pulses_generator(t,freq,amp,duty);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,1,2);
plot(t,pwm_signal, 'LineWidth',2);
grid on;
xlabel ('Tempo (s)' , 'fontsize', 14);
ylabel ("Amplitude", 'fontsize', 14);
title ("Trem de Pulsos", 'fontsize', 14);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modulação do sinal de entrada
xs = xt.*pwm_signal;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,1,3);
plot(t,xs, 'LineWidth',2);
grid on;
xlabel ('Tempo (s)' , 'fontsize', 14);
ylabel ("Amplitude", 'fontsize', 14);
title ("Sinal Modulado com PAM", 'fontsize', 14);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cálculo da FFT e Plotagem no Domínio da Frequência;
%[f,Xs] = fft(xs);%my_fft2(t,xs,fs);
Xs = fft(xs);%my_fft2(t,xs,fs);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
subplot(2,1,1);
stem((abs(Xs)/length(xs)),'.');
%stem(f,Xs,'.');
grid on;
axis([-(3*freq) (3*freq) -2 2]);
xlabel ('{\it f} (Hertz)' , 'fontsize', 14);
ylabel ('|X({\itf})|', 'fontsize', 14);
title ("Espectro do Sinal xt(t) modulado", 'fontsize', 14);
subplot(2,1,2);
stem(angle(Xs));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
[fr, ph] = phase(xt,fs);
stem(fr,ph);
axis([-(3*freq) (3*freq) -2 2]);
xlabel 'Frequency (Hz)';
ylabel 'Phase / \pi';
grid on;
hold on;
[fr, ph] = phase(xs,fs);
stem(fr,ph);