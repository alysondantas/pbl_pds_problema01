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
% Caso 01 - Fs = 500 MARCA PARADA NO MESMO LUGAR PISCANDO LENTAMENTE(APARECE A CADA 2 CICLOS
% Caso 02 - Fs = 700 MARCA ANDANDO LENTAMENTE NO SENTIDO HORÁRIO
% Caso 03 - Fs = 900 MARCA ANDANDO LENTAMENTE NO SENTIDO HORÁRIO - MAIS RAPIDO QUE O ANTERIOR
% Caso 04 - Fs = 1000 MARCA PARADA NO MESMO LOCAL
% Caso 05 - Fs = 1100 MARCA ANDANDO LENTAMENTE NO SENTIDO ANTI-HORÁRIO
% Caso 06 - Fs = 1300 MARCA ALTERNADA 2-1-1 REPETE
% Caso 07 - Fs = 1500 3 MARCAS PARADAS
% Caso 08 - Fs = 1700 2 MARCAS ANDANDO EM SENTIDO HORÁRIO
% Caso 09 - Fs = 1900 2 MARCAS ANDANDO EM SENTIDO HORÁRIO - VELOCIDADE MENOR QUE 1700
% Caso 10 - Fs = 2000 2 MARCAS PARADAS
% Caso 11 - Fs = 2100 2 MARCAS ANDANDO EM SENTIDO HORÁRIO
% Caso 12 - Fs = 2300 1 MARCA ANDANDO EM SENTIDO HORÁRIO
% Caso 13 - Fs = 2500 1 MARCA ANDANDO EM SENTIDO HORÁRIO MAIS RÁPIDO QUE 2300
% Caso 14 - Fs = 3000 1 MARCA APARECENDO n VEZES A FREQENCIA SEMPRE NOS MESMO PONTOS, NESSE CASO n=3
% Caso 15 - Fs = 4000 1 MARCA APARECENDO n VEZES A FREQENCIA SEMPRE NOS  MESMO PONTOS, NESSE CASO n=4
% Caso 16 - Fs = 5000 1 MARCA APARECENDO n VEZES A FREQENCIA SEMPRE NOS MESMO PONTOS, NESSE CASO n=5 
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
p1 = figure;
subplot(2,1,1);
plot(t,xt, 'LineWidth',2);
grid on;
axis([0 stoptime min(xt)*1.1 max(xt)*1.1]);
xlabel ('Tempo (s)' , 'fontsize', 14);
ylabel ("Amplitude", 'fontsize', 14);
title ("Sinal de Entrada no Domínio do Tempo", 'fontsize', 14);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GERAÇÃO DO TREM DE PULSOS
amp  = 1;
duty = 1; %Lembrar de explicar o que acontece com a sync. 
freq_tp = 500;
pwm_signal = pulses_generator(t,freq_tp,amp,duty);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT DO TREM DE PULSOS
subplot(2,1,2);
plot(t,pwm_signal, 'LineWidth',2);
grid on;
axis([0 stoptime 0 max(xt)*1.1]);
xlabel ('Tempo (s)' , 'fontsize', 14);
ylabel ("Amplitude", 'fontsize', 14);
title ("Trem de Pulsos", 'fontsize', 14);
freq_tp_str = join(['PRINTS\\', int2str(freq_tp), '_F1.pdf']);
exportgraphics(p1,freq_tp_str);
freq_tp_str = join(['PRINTS\\', int2str(freq_tp), '_F1.eps']);
exportgraphics(p1,freq_tp_str);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MODULAÇÃO DO SINAL DE ENTRADA
xs = xt.*pwm_signal;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CÁLCULO DAS FFTS
[f_Xt,Xt] = my_fft2(t,xt,fs);
[f_PWM,PWM] = my_fft2(t,pwm_signal,fs);
[f_Xs,Xs] = my_fft2(t,xs,fs);
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT DA MODULAÇÃO E DA INTERSSEÇÃO DOS SINAIS ORIGINAIS E MODULADOS
% PLOT DA MODULAÇÃO
p2 = figure;
subplot(3,1,1)
plot(t,xs, 'LineWidth',2);
grid on;
xlabel ('Tempo (s)' , 'fontsize', 14);
ylabel ("Amplitude", 'fontsize', 14);
title ("Sinal Modulado com PAM", 'fontsize', 14);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT DA SOBREPOSIÇÃO DO SINAL ORIGINAL E MODULADO
subplot(3,1,2)
plot(t,xt, '-.', 'LineWidth',1);
hold on
plot(t,xs, '-', 'LineWidth',1);
grid on;
xlabel ('Tempo (s)' , 'fontsize', 14);
ylabel ("Amplitude", 'fontsize', 14);
title ("Sobreposição entre o sinal original e modulado", 'fontsize', 14);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT DO VENTILADOR
[x_v, y_v] = ventilador (freq, freq_tp, stoptime);
subplot(3,1,3)
% figure;
plot(t,xt, '-.', 'LineWidth',1);
hold on
plot(x_v,y_v, 'o', 'LineWidth',1);
grid on;
xlabel('$t$','Interpreter','LaTex','FontSize',18)
ylabel('$x[nT_s],x(t)$','Interpreter','LaTex','FontSize',18)
title ("Visualização do Efeito", 'fontsize', 14);
freq_tp_str = join(['PRINTS\\', int2str(freq_tp), '_F2.pdf']);
exportgraphics(p2,freq_tp_str);
freq_tp_str = join(['PRINTS\\', int2str(freq_tp), '_F2.eps']);
exportgraphics(p2,freq_tp_str);
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT DO ESPECTRO DA ENTRADA, TREM DE PULSOS E SOBREPOSIÇÃO DE ESPECTROS
% PLOT ENTRADA
p3 = figure;
subplot(2,2,1)
plot(f_Xt,Xt);
axis([-3000 3000 0 max(Xt)*1.1]);
grid on;
xlabel ('{\it f} (Hertz)' , 'fontsize', 12);
ylabel ('|X({\itf})|', 'fontsize', 12);
title ("Espectro do Sinal da Entrada", 'fontsize', 12);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT PWM
subplot(2,2,3)
plot(f_PWM,PWM);
%axis([-3000 3000 0 max(PWM)*1.1]);
grid on;
xlabel ('{\it f} (Hertz)' , 'fontsize', 12);
ylabel ('|X({\itf})|', 'fontsize', 12);
title ("Espectro do Trem de Pulsos", 'fontsize', 12);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT SOBREPOSIÇÃO DE ESPECTROS
subplot(2,2,[2,4])
stem(f_Xt,Xt,'.');
hold on
plot(f_Xs,Xs);
axis([-3000 3000 0 max(Xs)*1.1]);
xlabel ('{\it f} (Hertz)' , 'fontsize', 12);
ylabel ('|X({\itf})|', 'fontsize', 12);
title ("Sobreposição de espectros", 'fontsize', 12);
legend ('Entrada', 'Saida');
freq_tp_str = join(['PRINTS\\', int2str(freq_tp), '_F3.pdf']);
exportgraphics(p3,freq_tp_str);
freq_tp_str = join(['PRINTS\\', int2str(freq_tp), '_F3.eps']);
exportgraphics(p3,freq_tp_str);