function [base_treino, base_teste] = dividir_base_k_fold(iteracao, new_base, n_classe_1, n_classe_2)

    %% Lógica para pegar parte da base por vez para teste, e o resto para treino
    % separando 6 amostras da classe 1 e 7 amostras da classe 2
    % e o resto para treino
    
    if iteracao ~= 10
        inicio_amostra_teste_classe_1 = ((iteracao-1)*6) + 1;
        inicio_amostra_teste_classe_2 = ((iteracao-1)*7) + n_classe_1+1;
        fim_amostra_teste_classe_1 = iteracao * 6;
        fim_amostra_teste_classe_2 = (iteracao * 7) + n_classe_1;
        
        % Parte separada para teste
        base_teste = [new_base(inicio_amostra_teste_classe_1:fim_amostra_teste_classe_1, :) ; new_base(inicio_amostra_teste_classe_2:fim_amostra_teste_classe_2, :)];

        % Pegando o resto para o treino
        if iteracao == 1
            base_treino = [new_base(fim_amostra_teste_classe_1+1:n_classe_1, :) ; new_base(fim_amostra_teste_classe_2+1:(n_classe_1+n_classe_2), :)];
        else
            base_treino = [new_base(1:inicio_amostra_teste_classe_1-1,:);new_base(fim_amostra_teste_classe_1+1:n_classe_1, :);new_base(n_classe_1+1:inicio_amostra_teste_classe_2-1,:);new_base(fim_amostra_teste_classe_2+1:(n_classe_1+n_classe_2), :)];
        end

    else
        % Na última iteração, eu tenho divido a base de maneira diferente,
        % para usar todos as amostras corretamente
        inicio_amostra_teste_classe_1 = n_classe_1 - 4; %55
        inicio_amostra_teste_classe_2 = n_classe_1 + n_classe_2 - 7; %123
        fim_amostra_teste_classe_1 = n_classe_1;
        fim_amostra_teste_classe_2 = n_classe_1 + n_classe_2;

        base_teste = [new_base(inicio_amostra_teste_classe_1:fim_amostra_teste_classe_1, :) ; new_base(inicio_amostra_teste_classe_2:fim_amostra_teste_classe_2, :)];
        base_treino = [new_base(1:inicio_amostra_teste_classe_1-1, :) ; new_base(n_classe_1+1:inicio_amostra_teste_classe_2-1, :)];
        
    end
end