close all; clear ;
%% DEFINIÇÃO DE PARÂMETROS
amp      = 1;                 % Amplitude do Sinal;
freq     =1000;              % Frequência do Sinal = 1kHz;
T        = 1/freq;             % Período do Sinal;
fs       = 300000;           % Frequência de Amostragem para geração do sinal = 3000kHz = 3 MHz (amostras por segundo);
ts       = 1/fs;              % Período de Amostragem (um período para cada amostra);
stoptime = (10*T) - ts;        % Duração do Sinal em segundos (5 períodos);
t        = 0:ts:stoptime;     % Vetor de tempo;
% Geração de um sinal senoidal;
xt       = amp*sin(2*pi*freq*t);
N        = length(xt);    % Quantidade de amostras do sinal;
% Geração do trem de pulsos
amp_tp  = 1;
duty_tp = 1; % 1/3 do período total.
freq_tp = 1000; % frequencia do trem de pulsos
% 100 1000 1500 1900 2000 2100  
%% TRANSFORMADA DA ENTRADA
[f,Y] = fourrier(xt, fs);
%% GERAÇÃO DO TREM DE PULSOS
tp = trem_so(t,freq_tp,amp_tp,duty_tp);
%% TRANSFORMADA DO TREM DE PULSOS
[f_tp, Y_tp] = fourrier(tp, fs);
%% GERAÇÃO DA AMOSTRAGEM
amostragem = xt.*tp;
%% TRASFORMADA DA AMOSTRAGEM
[f_a, Y_a] = fourrier(amostragem, fs);
%% PLOT DO SINAL DE ENTRADA
figure(1)
subplot(4,4,1)
plot(t,xt, 'LineWidth',2);
axis([0 stoptime -1.5 1.5]);
grid on;
xlabel ('Tempo (s)' , 'fontsize', 12);
ylabel ("Amplitude", 'fontsize', 12);
title ("Sinal da Entrada", 'fontsize', 12);
%% PLOTAGEM DA TRANSFORMADA DA ENTRADA
subplot(4,4,5)
stem(f,Y,'.');
axis([-6000 6000 0 max(Y)*1.1]);
grid on;
xlabel ('{\it f} (Hertz)' , 'fontsize', 12);
ylabel ('|X({\itf})|', 'fontsize', 12);
title ("Espectro do Sinal da Entrada", 'fontsize', 12);
%% PLOT DO TREM DE PULSOS
subplot(4,4,2)
plot(t,tp, 'LineWidth',2);
axis([0 stoptime -0.5 1.5]);
grid on;
xlabel ('Tempo (s)' , 'fontsize', 12);
ylabel ("Amplitude", 'fontsize', 12);
title ("Trem de Pulsos", 'fontsize', 12);
%% PLOTAGEM DA TRANSFORMADA DO TREM DE PULSOS
subplot(4,4,6)
stem(f_tp,Y_tp,'.');
axis([-6000 6000 0 max(Y_tp)*1.1]);
grid on;
xlabel ('{\it f} (Hertz)' , 'fontsize', 12);
ylabel ('|X({\itf})|', 'fontsize', 12);
title ("Espectro do Trem de Pulsos", 'fontsize', 12);
%% PLOT DA AMOSTRAGEM
subplot(4,4,[9,10])
plot(t,amostragem, 'LineWidth',2);
axis([0 stoptime -1.5 1.5]);
grid on;
xlabel ('Tempo (s)' , 'fontsize', 12);
ylabel ("Amplitude", 'fontsize', 12);
title ("Amostragem", 'fontsize', 12);
%% PLOTAGEM DA TRANSFORMADA DA AMOSTRAGEM
subplot(4,4,[13,14])
stem(f_a,Y_a,'.');
axis([-6000 6000 0 max(Y_a)*1.1]);
grid on;
xlabel ('{\it f} (Hertz)' , 'fontsize', 12);
ylabel ('|X({\itf})|', 'fontsize', 12);
title ("Espectro da Amostragem", 'fontsize', 12);
%% COMPARATIVO ENTRE OS ESPECTROS
subplot(4,4,[3,4,7,8,11,12,15,16])
hold on
stem(f,Y,'.b');
stem(f_tp,Y_tp,'.g');
stem(f_a,Y_a,'.r');
axis([-(freq_tp*2) (freq_tp*2) 0 max(Y_a)*1.1]);
legend('Entrada', 'Trem de pulsos', 'Efeito');
grid on;
xlabel ('{\it f} (Hertz)' , 'fontsize', 12);
ylabel ('|X({\itf})|', 'fontsize', 12);
title ("Comparativo dos Espectros", 'fontsize', 12);
%% FASE SINAL DE ENTRADA
tol = 1e-6;
Xw = fft(xt);
Yw = fftshift(Xw);
sizeXw = length(Xw);
vf = (-sizeXw/2:sizeXw/2-1)/sizeXw*fs;
Yw(abs(Yw) < tol) = 0;
fase_original = angle(Yw);
%% FASE SINAL AMOSTRADO
X_a_w = fft(amostragem);
Y_a_w = fftshift(X_a_w);
size_x_a = length(X_a_w);
vf_a = (-size_x_a/2:size_x_a/2-1)/size_x_a.*fs;
Y_a_w(abs(Y_a_w) < tol) = 0;
fase_amostragem = angle(Y_a_w);
%% PLOT DA FASE SINAL ORIGINAL
figure(2)
hold on
stem(vf_a,fase_amostragem/pi,'.b')
stem(vf,fase_original/pi,'.r')
legend('Fase original','Fase amostragem');
axis([-2000 2000 -1 1]);