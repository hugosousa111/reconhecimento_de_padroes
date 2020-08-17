function [h_limiar] = calc_entropia_menores_limiar(base_ordenada, posicao_candidato_limiar, cont_candidatos)

    %% calculando entropia pra cada candidato
    % coluna 1 => <
    % coluna 2 => > 
    h_limiar = zeros(cont_candidatos-1, 2);

    %% H(x<limiar) 
    % pego a primeira classe que aparece na base ordenada
    if base_ordenada(posicao_candidato_limiar(1), 1) == 1
        cont_classe_1 = posicao_candidato_limiar(1);
        cont_classe_2 = 0; 
    else
        cont_classe_1 = 0;
        cont_classe_2 = posicao_candidato_limiar(1);
    end

    for i = 1:(cont_candidatos-1)
        h_limiar(i,1) = calc_entropia(cont_classe_1, cont_classe_2, posicao_candidato_limiar(i));

        if base_ordenada(posicao_candidato_limiar(i), 1) == 1
            cont_classe_2 = posicao_candidato_limiar(i+1) - cont_classe_1; 
        else
            cont_classe_1 = posicao_candidato_limiar(i+1) - cont_classe_2;
        end 
    end
end