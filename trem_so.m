% Geração de um trem de Pulsos com mudança de duty cycle
%	    Sintaxe: [y] = pulses_generator(t,freq,amp,duty)
%             Entradas:
%                 t    = vetor de tempo 
%                 freq = frequência do sinal.
%                 amp  = amplitude do sinal
%                 duty = duty cycle do trem de pulsos 
%             Saída:
%                 Y = sinal de saída
function [Y]  = trem_so(t,freq,amp,duty)
Y = amp*square(2*pi*freq*t,duty);
% Retira os valores negativos
for i =1:length(Y)
   if Y(1,i) == -1
      Y(1,i) = 0;
   end
end
return