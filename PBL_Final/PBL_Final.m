%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Disciplina: MI-Processamento Digital de Sinais
% Instituição: Uefs
% Período: 2022.2
% Projeto: Entendendo o Efeito Estroboscópico - Subamostragem e Aliasing
% Discentes: 
%         - Alyson Dantas 
%         - Gabriel Sá
%         - Lucas Cardoso
%         - Marcelo Mota
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear all; clc; %pkg load signal;
% Geração de um sinal contínuo no tempo e limitado em frequência;
% Definições no tempo para geração e amostragem do sinal de entrada:
amp      = 1;                           % Amplitude do Sinal;
freq     = 1000;                        % Frequência do Sinal = 1kHz;
T        = 1/freq;                      % Período do Sinal;
fs       = 3000000;                     % Frequência de Amostragem para geração do sinal = 3000kHz = 3 MHz (amostras por segundo);
ts       = 1/fs;                        % Período de Amostragem (um período para cada amostra);
stoptime = (20*T) - ts;                 % Duração do Sinal em segundos (20 períodos);
t        = 0:ts:stoptime;               % Vetor de tempo;
xt       = amp*sin(2*pi*freq*t);        % Geração de um sinal senoidal;
N        = length(xt);                  % Quantidade de amostras do sinal;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT DO SINAL ORIGINAL
p1 = figure;
subplot(2,1,1);
plot(t,xt, 'LineWidth',2);
grid on;
axis([0 stoptime min(xt)*1.1 max(xt)*1.1]);
xlabel ('Tempo (s)' , 'Interpreter','LaTex','FontSize',12);
ylabel ("Amplitude", 'Interpreter','LaTex','FontSize',12);
title (" Sinal de Entrada no Dom\'{i}nio do Tempo", 'Interpreter', 'LaTex','FontSize',12);
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GERAÇÃO DO TREM DE PULSOS
amp  = 1;
duty = 1;           % Duty Cicle do trem de pulsos 
freq_tp = 2900;     % Frequência do trem de pulsos
pwm_signal = pulses_generator(t,freq_tp,amp,duty);
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT DO TREM DE PULSOS
subplot(2,1,2);
plot(t,pwm_signal, 'LineWidth',2);
grid on;
axis([0 stoptime 0 max(xt)*1.1]);
xlabel ('Tempo (s)' , 'Interpreter','LaTex','FontSize',12);
ylabel ("Amplitude", 'Interpreter','LaTex','FontSize',12);
title (" Trem de Pulsos", 'Interpreter','LaTex','FontSize',12);
% EXPORT AUTOMÁTICO DAS FIGURAS
freq_tp_str = join(['PRINTS\\', int2str(freq_tp), '_F1.pdf']);
exportgraphics(p1,freq_tp_str);
freq_tp_str = join(['PRINTS\\', int2str(freq_tp), '_F1.eps']);
exportgraphics(p1,freq_tp_str);
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MODULAÇÃO DO SINAL DE ENTRADA
xs = xt.*pwm_signal;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
xlabel ('Tempo (s)' , 'Interpreter','LaTex','FontSize',12);
ylabel ("Amplitude", 'Interpreter','LaTex','FontSize',12);
title (" Sinal Modulado com PAM", 'Interpreter','LaTex','FontSize',12);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT DA SOBREPOSIÇÃO DO SINAL ORIGINAL E MODULADO
subplot(2,1,1)
plot(t,xt, '-.', 'LineWidth',1);
hold on
plot(t,xs, '-', 'LineWidth',1);
grid on;
xlabel ('Tempo (s)' , 'Interpreter','LaTex','FontSize',12);
ylabel ("Amplitude", 'Interpreter','LaTex','FontSize',12);
title (" Sobreposi\c{c}\~{a}o entre o sinal original e modulado", 'Interpreter','LaTex','FontSize',12);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT DA VISUALIZAÇÃO DO EFEITO ESTROBOSCÓPICO
[x_v, y_v] = ventilador (freq, freq_tp, stoptime);
subplot(2,1,2)
% figure;
plot(t,xt, '-.', 'LineWidth',1);
hold on
plot(x_v,y_v, 'o', 'LineWidth',1);
grid on;
xlabel('$t$','Interpreter','LaTex','FontSize',12)
ylabel('$x[nT_s],x(t)$','Interpreter','LaTex','FontSize',12)
title (" Visualiza\c{c}\~{a}o do Efeito", 'Interpreter','LaTex','FontSize',12);
% EXPORT AUTOMÁTICO DAS FIGURAS
freq_tp_str = join(['PRINTS\\', int2str(freq_tp), '_F2.pdf']);
exportgraphics(p2,freq_tp_str);
freq_tp_str = join(['PRINTS\\', int2str(freq_tp), '_F2.eps']);
exportgraphics(p2,freq_tp_str);
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
p4 = figure;
subplot(2,1,1)
plot(f_Xt,Xt);
axis([-3000 3000 0 max(Xt)*1.1]);
grid on;
xlabel ("\it f (Hertz)" , 'Interpreter','LaTex','FontSize',12);
ylabel ('$\arrowvert$X(\it f)$\arrowvert$', 'Interpreter','LaTex','FontSize',12);
title (" Espectro do Sinal da Entrada", 'Interpreter','LaTex','FontSize',12);
subplot(2,1,2)
plot(f_PWM,PWM);
axis([-10000 10000 0 max(PWM)*1.1]);
grid on;
xlabel ("\it f (Hertz)" , 'Interpreter','LaTex','FontSize',12);
ylabel ('$\arrowvert$X(\it f)$\arrowvert$', 'Interpreter','LaTex','FontSize',12);
title (" Espectro do  Trem de Pulsos", 'Interpreter','LaTex','FontSize',12);
% EXPORT AUTOMÁTICO DAS FIGURAS
freq_tp_str = join(['PRINTS\\sinc.pdf']);
exportgraphics(p4,freq_tp_str);
freq_tp_str = join(['PRINTS\\sinc.eps']);
exportgraphics(p4,freq_tp_str);
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT DO ESPECTRO DA ENTRADA, TREM DE PULSOS E SOBREPOSIÇÃO DE ESPECTROS
% PLOT DO ESPECTRO DA ENTRADA
p3 = figure;
subplot(2,4,[1,2])
plot(f_Xt,Xt);
axis([-3000 3000 0 max(Xt)*1.1]);
grid on;
xlabel ("\it f (Hertz)" , 'Interpreter','LaTex','FontSize',12);
ylabel ('$\arrowvert$X(\it f)$\arrowvert$', 'Interpreter','LaTex','FontSize',12);
title (" Espectro do Sinal da Entrada", 'Interpreter','LaTex','FontSize',12);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT DO EXPECTRO DO PWM
subplot(2,4,[5,6])
plot(f_PWM,PWM);
axis([-3000 3000 0 max(PWM)*1.1]);
grid on;
xlabel ("\it f (Hertz)" , 'Interpreter','LaTex','FontSize',12);
ylabel ('$\arrowvert$X(\it f)$\arrowvert$', 'Interpreter','LaTex','FontSize',12);
title (" Espectro do  Trem de Pulsos", 'Interpreter','LaTex','FontSize',12);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT SOBREPOSIÇÃO DE ESPECTROS
l = subplot(2,4,[3,4,7,8]);
stem(f_Xt,Xt,'.');
hold on
plot(f_Xs,Xs);
axis([-4500 4500 0 max(Xs)*1.1]);
xlabel ("\it f (Hertz)" , 'Interpreter','LaTex','FontSize',12);
ylabel ('$\arrowvert$X(\it f)$\arrowvert$', 'Interpreter','LaTex','FontSize',12, 'Color', 'black');
title (" Sobreposi\c{c}\~{a}o de espectros", 'Interpreter','LaTex','FontSize',12);
legend ('Entrada', 'Saida');
% EXPORT AUTOMÁTICO DAS FIGURAS
freq_tp_str = join(['PRINTS\\', int2str(freq_tp), '_F3.pdf']);
exportgraphics(p3,freq_tp_str);
freq_tp_str = join(['PRINTS\\', int2str(freq_tp), '_F3.eps']);
exportgraphics(p3,freq_tp_str);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%