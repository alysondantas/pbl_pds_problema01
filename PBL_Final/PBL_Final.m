%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Disciplina: MI-Processamento Digital de Sinais
% Instituição: Uefs
% Período: 2022.2
% Projeto: Amostragem Natural (Gatilhamento)
% Discentes: 
%         - Gabriel Sá 
%         - Marcelo Mota
%         - Alyson Dantas
%         - Lucas Cardoso
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CASOS DE ANALISE:
% Fn = 1000;
% Caso 01 - Fs = 500 
% Caso 02 - Fs = 700
% Caso 03 - Fs = 900
% Caso 04 - Fs = 1000
% Caso 05 - Fs = 1100
% Caso 06 - Fs = 1300
% Caso 07 - Fs = 1500
% Caso 08 - Fs = 1700
% Caso 09 - Fs = 1900
% Caso 10 - Fs = 2000
% Caso 11 - Fs = 2100
% Caso 12 - Fs = 2300
% Caso 13 - Fs = 2500
% Caso 14 - Fs = 3000
% Caso 15 - Fs = 4000
% Caso 16 - Fs = 5000
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear all; clc; %pkg load signal;
% Geração de um sinal contínuo no tempo e limitado em frequência;
% Definições no tempo para geração e amostragem do sinal de entrada:
amp      = 1;                 % Amplitude do Sinal;
freq     = 1000;              % Frequência do Sinal = 1kHz;
T        = 1/freq;             % Período do Sinal;
fs       = 3000000;           % Frequência de Amostragem para geração do sinal = 3000kHz = 3 MHz (amostras por segundo);
ts       = 1/fs;              % Período de Amostragem (um período para cada amostra);
stoptime = (20*T) - ts;        % Duração do Sinal em segundos (5 períodos);
t        = 0:ts:stoptime;     % Vetor de tempo;
% Geração de um sinal senoidal;
xt       = amp*sin(2*pi*freq*t);
N        = length(xt);    % Quantidade de amostras do sinal;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT DO SINAL ORIGINAL
figure;
subplot(2,1,1);
plot(t,xt, 'LineWidth',2);
grid on;
xlabel ('Tempo (s)' , 'fontsize', 14);
ylabel ("Amplitude", 'fontsize', 14);
title ("Sinal de Entrada no Domínio do Tempo", 'fontsize', 14);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GERAÇÃO DO TREM DE PULSOS
amp  = 1;
duty = 1; 
freq = 1900;
pwm_signal = pulses_generator(t,freq,amp,duty);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT DO TREM DE PULSOS
subplot(2,1,2);
plot(t,pwm_signal, 'LineWidth',2);
grid on;
xlabel ('Tempo (s)' , 'fontsize', 14);
ylabel ("Amplitude", 'fontsize', 14);
title ("Trem de Pulsos", 'fontsize', 14);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MODULAÇÃO DO SINAL DE ENTRADA
xs = xt.*pwm_signal;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CÁLTUCO DAS FFTS
[f_Xt,Xt] = my_fft2(t,xt,fs);
[f_PWM,PWM] = my_fft2(t,pwm_signal,fs);
[f_Xs,Xs] = my_fft2(t,xs,fs);
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT DA MODULAÇÃO E DA INTERSSEÇÃO DOS SINAIS ORIGINAIS E MODULADOS
% PLOT DA MODULAÇÃO
figure;
subplot(2,1,1)
plot(t,xs, 'LineWidth',2);
grid on;
xlabel ('Tempo (s)' , 'fontsize', 14);
ylabel ("Amplitude", 'fontsize', 14);
title ("Sinal Modulado com PAM", 'fontsize', 14);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT DA SOBREPOSIÇÃO DO SINAL ORIGINAL E MODULADO
subplot(2,1,2)
plot(t,xt, '-.', 'LineWidth',1);
hold on
plot(t,xs, '-', 'LineWidth',1);
grid on;
xlabel ('Tempo (s)' , 'fontsize', 14);
ylabel ("Amplitude", 'fontsize', 14);
title ("Sobreposição entre o sinal original e modulado", 'fontsize', 14);
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT DO ESPECTRO DA ENTRADA, TREM DE PULSOS E SOBREPOSIÇÃO DE ESPECTROS
% PLOT ENTRADA
figure;
subplot(2,2,1)
stem(f_Xt,Xt,'.');
axis([-3000 3000 0 max(Xt)*1.1]);
grid on;
xlabel ('{\it f} (Hertz)' , 'fontsize', 12);
ylabel ('|X({\itf})|', 'fontsize', 12);
title ("Espectro do Sinal da Entrada", 'fontsize', 12);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT PWM
subplot(2,2,3)
stem(f_PWM,PWM,'.');
axis([-3000 3000 0 max(PWM)*1.1]);
grid on;
xlabel ('{\it f} (Hertz)' , 'fontsize', 12);
ylabel ('|X({\itf})|', 'fontsize', 12);
title ("Espectro do Trem de Pulsos", 'fontsize', 12);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT SOBREPOSIÇÃO DE ESPECTROS
subplot(2,2,[2,4])
stem(f_Xt,Xt,'.');
hold on
stem(f_Xs,Xs,'.');
axis([-3000 3000 0 max(Xs)*1.1]);
xlabel ('{\it f} (Hertz)' , 'fontsize', 12);
ylabel ('|X({\itf})|', 'fontsize', 12);
title ("Sobreposição de espectros", 'fontsize', 12);
legend ('Entrada', 'Saida');
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CÁLCULO DAS FASES
[fr, ph] = phase(xt,fs);
[fr_Xs, ph_Xs] = phase(xs,fs);
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT DO ESPECTRO DA ENTRADA, TREM DE PULSOS E SOBREPOSIÇÃO DE ESPECTROS
% PLOT ENTRADA
figure;
subplot(2,2,1)
stem(fr,ph);
axis([-1200 1200 -2 2]);
xlabel 'Frequency (Hz)';
ylabel 'Phase / \pi';
title ("Fase do sinal de Entrada", 'fontsize', 12);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT PWM
subplot(2,2,3)
stem(fr_Xs,ph_Xs);
axis([-1200 1200 -2 2]);
xlabel 'Frequency (Hz)';
ylabel 'Phase / \pi';
title ("Fase do sinal de Saída", 'fontsize', 12);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT SOBREPOSIÇÃO DE ESPECTROS
subplot(2,2,[2,4])
stem(fr,ph,'.');
hold on
stem(fr_Xs,ph_Xs,'.');
axis([-1200 1200 -2 2]);
xlabel ('{\it f} (Hertz)' , 'fontsize', 12);
ylabel ('|X({\itf})|', 'fontsize', 12);
title ("Sobreposição das fases", 'fontsize', 12);
legend ('Entrada', 'Saida');
