function [matriz_correlacao] = calc_matriz_correlacao(classe, vetor_media)
    classe = classe.';
    vetor_media = vetor_media.';
    [atributos, elementos] = size(classe);
    % mudar para N e p
    % classe chamar de base
    matriz_correlacao = zeros(atributos, atributos);

    for linha1_atual = 1:atributos
        for linha2_atual = 1:atributos
            acumulador = 0;
            for  elemento = 1:elementos
                x = (classe(linha1_atual,elemento)-vetor_media(linha1_atual))*(classe(linha2_atual,elemento)-vetor_media(linha2_atual));
                acumulador = acumulador + x;
            end
            matriz_correlacao(linha1_atual,linha2_atual) = acumulador/(elementos-1);
        end
    end
    
    for linha = 1:atributos
        desvio1 = sqrt(matriz_correlacao(linha, linha));
        for coluna = linha:atributos
            desvio2 = sqrt(matriz_correlacao(coluna, coluna));
            matriz_correlacao(linha, coluna) = matriz_correlacao(linha, coluna) / (desvio1*desvio2);
            matriz_correlacao(coluna, linha) = matriz_correlacao(linha, coluna);
        end
    end
end