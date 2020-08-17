function [entropia] = calc_entropia(numerador_1, numerador_2, denominador)
    % função para calcular entropia
    entropia = -((numerador_1/denominador)*log2(numerador_1/denominador))-((numerador_2/denominador)*log2(numerador_2/denominador));
    
end