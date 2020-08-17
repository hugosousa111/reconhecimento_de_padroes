function [candidatos_limiar,posicao_candidato_limiar, cont_candidatos,h_limiar, h_T_limiar, vetor_limiar_escolhido] = escolha_limiar(n_atributos, base_treino)
    vetor_limiar_escolhido = zeros(n_atributos, 1);

    for atributo = 2: n_atributos+1
    
        %% ordeno a base, por atributo
        base_ordenada = sortrows(base_treino, atributo);

        %% guardo os candidatos a limiar
        [candidatos_limiar,posicao_candidato_limiar, cont_candidatos] = escolha_candidato_limiar(base_ordenada, atributo);

        %% calculando entropia pra cada candidato
        % coluna 1 => <
        % coluna 2 => > 
        
        if posicao_candidato_limiar == 0
            % serve para não dá erro, quando não tem candidatos a limiar (todos da mesma classe)
            h_limiar = 0;
            h_T_limiar = 0;
        elseif isempty(posicao_candidato_limiar)
            % serve para não dá erro, quando não tem candidatos a limiar (todos da mesma classe)
            h_limiar = 0;
            h_T_limiar = 0;
        
        else
        %% H(x<limiar)
        [h_limiar] = calc_entropia_menores_limiar(base_ordenada, posicao_candidato_limiar, cont_candidatos);

        %% H(x>limiar)
        [h_limiar] = calc_entropia_maiores_limiar(base_ordenada, posicao_candidato_limiar, cont_candidatos, h_limiar);

        %% faço uma correção, pois quando na expressão tem log2(0), a expressão fica NaN
        h_limiar = corrigeNaN(h_limiar, (cont_candidatos-1) , 2);
        
        %% faz a "media" dos H < e >
        [h_T_limiar] = h_medio(cont_candidatos, posicao_candidato_limiar, h_limiar);

        %% o menor vai ser o limiar, daquele atributo
        [valor, pos] = min(h_T_limiar);
        vetor_limiar_escolhido(atributo-1) = candidatos_limiar(pos);
        end
        
    end
end