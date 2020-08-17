function [h_atributo, h_atributo_media] = calc_entropia_sub_base(n_atributos, base_treino, vetor_limiar_escolhido)
    
    h_atributo = zeros(n_atributos, 2);
    h_atributo_media = zeros(n_atributos, 1);
    [l, c] = size(base_treino);

    for atributo = 2: n_atributos+1
        n_classe_1_atributo_menor_limiar = 0;
        n_classe_2_atributo_menor_limiar = 0;
        n_classe_1_atributo_maior_limiar = 0;
        n_classe_2_atributo_maior_limiar = 0;
        
        %conto quantos são, das duas classes em relação aquele limiar
        for i = 1:l
            if base_treino(i, atributo) < vetor_limiar_escolhido(atributo-1)
                if base_treino(i, 1) == 1
                    n_classe_1_atributo_menor_limiar = n_classe_1_atributo_menor_limiar +1;
                else
                    n_classe_2_atributo_menor_limiar = n_classe_2_atributo_menor_limiar +1;
                end
            else
                if base_treino(i, 1) == 1
                    n_classe_1_atributo_maior_limiar = n_classe_1_atributo_maior_limiar +1;
                else
                    n_classe_2_atributo_maior_limiar = n_classe_2_atributo_maior_limiar +1;
                end
            end
        end
        
        h_atributo(atributo-1, 1) = calc_entropia(n_classe_1_atributo_menor_limiar, n_classe_2_atributo_menor_limiar,(n_classe_1_atributo_menor_limiar+n_classe_2_atributo_menor_limiar));
        h_atributo(atributo-1, 2) = calc_entropia(n_classe_1_atributo_maior_limiar, n_classe_2_atributo_maior_limiar,(n_classe_1_atributo_maior_limiar+n_classe_2_atributo_maior_limiar));
        
        %% faço uma correção, pois quando na expressão tem log2(0), a expressão fica NaN
        [h_atributo] = corrigeNaN(h_atributo, n_atributos, 2);
        
        %% Entropia média destas sub-bases
        h_atributo_media(atributo-1) = ((n_classe_1_atributo_menor_limiar+n_classe_2_atributo_menor_limiar)/117)*h_atributo(atributo-1,1) + ((n_classe_1_atributo_maior_limiar+n_classe_2_atributo_maior_limiar)/117)*h_atributo(atributo-1,2);
        
    end
    
end