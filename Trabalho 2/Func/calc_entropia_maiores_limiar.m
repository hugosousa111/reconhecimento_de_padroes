function [h_limiar]= calc_entropia_maiores_limiar(base_ordenada, posicao_candidato_limiar, cont_candidatos, h_limiar)

    %% H(x>limiar)
    % faz o contrario

    % pego a ultima classe que aparece na base ordenada
    if base_ordenada(posicao_candidato_limiar(cont_candidatos-1), 1) == 2
        cont_classe_1 = 117 - posicao_candidato_limiar(cont_candidatos-1);
        cont_classe_2 = 0; 
    else
        cont_classe_1 = 0;
        cont_classe_2 = 117 - posicao_candidato_limiar(cont_candidatos-1);
    end

    for i = (cont_candidatos-1):-1:1
        h_limiar(i,2) = calc_entropia(cont_classe_1,cont_classe_2,(117 - posicao_candidato_limiar(i)));

        if i ~= 1
            if base_ordenada(posicao_candidato_limiar(i), 1) == 2
                cont_classe_2 = 117 - posicao_candidato_limiar(i-1) - cont_classe_1; 
            else
                cont_classe_1 = 117 - posicao_candidato_limiar(i-1) - cont_classe_2;
            end 
        end
    end
end