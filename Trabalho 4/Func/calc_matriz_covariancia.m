function [matriz_covariancia] = calc_matriz_covariancia(base, vetor_media)
    base = base.';
    vetor_media = vetor_media.';
    [atributos, elementos] = size(base);
    
    matriz_covariancia = zeros(atributos, atributos);
    
    % Aplico na formula da covariância
        % cov(A,B)= Somatorio((Ai - A_media)∗(Bi - B_media))/ N - 1 
        
    for linha1_atual = 1:atributos
        for linha2_atual = 1:atributos
            acumulador = 0;
            for  elemento = 1:elementos
                x = (base(linha1_atual,elemento)-vetor_media(linha1_atual))*(base(linha2_atual,elemento)-vetor_media(linha2_atual));
                acumulador = acumulador + x;
            end
            matriz_covariancia(linha1_atual,linha2_atual) = acumulador/(elementos-1);
        end
    end
end