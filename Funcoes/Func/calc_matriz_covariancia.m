function [matriz_covariancia] = calc_matriz_covariancia(classe, vetor_media)
    classe = classe.';
    vetor_media = vetor_media.';
    [atributos, elementos] = size(classe);
    % mudar para N e p
    matriz_covariancia = zeros(atributos, atributos);

    for linha1_atual = 1:atributos
        for linha2_atual = 1:atributos
            acumulador = 0;
            for  elemento = 1:elementos
                x = (classe(linha1_atual,elemento)-vetor_media(linha1_atual))*(classe(linha2_atual,elemento)-vetor_media(linha2_atual));
                acumulador = acumulador + x;
            end
            matriz_covariancia(linha1_atual,linha2_atual) = acumulador/(elementos-1);
        end
    end
end