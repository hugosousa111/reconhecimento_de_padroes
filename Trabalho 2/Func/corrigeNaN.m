function [matriz] = corrigeNaN(matriz,linhas, colunas)
    
    %% faço uma correção, pois quando na expressão tem log2(0), a expressão fica NaN
    for a = 1: linhas
        for b = 1:colunas
            if isnan(matriz(a, b))
                matriz(a, b) = 0;
            end
        end
    end
end