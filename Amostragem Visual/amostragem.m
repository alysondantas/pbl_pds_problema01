clear all; close all; clc
%% dados do sinal
f = 1000;%Freq entrada Hz
fs =500;% Frequencia de amostragem Hz
%% gerar sinal
tempo = [0:1/(100*f):10/f];%Tempo amostral
sinal = sin(2*pi*f*tempo); % Geração onda senoidal
%% plotar sinal
plot(tempo,sinal)
hold;
%% sinal amostrado
Ts = 1/fs;
N=101;
n = [0:1:N-1];
t_sample = [0 : Ts : n(N)*Ts];
DigitalFrequency=2*pi*f/fs;
sinal_sample = sin (DigitalFrequency.*n);
plot(t_sample, sinal_sample,'o');
axis([0 10/f -1.5 1.5])
set(gca,'FontSize',16)
xlabel('$t$','Interpreter','LaTex','FontSize',18)
ylabel('$x[nT_s],x(t)$','Interpreter','LaTex','FontSize',18)

%% FFT do sinal
X=fft(sinal);

%X são valores complexos porque representam magnitude e fase!!!!
%Magnitude
%figure;
X_mag=abs(X);
X_mag(30:34)
plot(X_mag)
set(gca,'FontSize',16)

A=1;
w0=10*pi;
fi=0.5;
%t=0:0.001:1;

%trem = A*sawtooth(w0*t+fi);
%plot(t,trem);