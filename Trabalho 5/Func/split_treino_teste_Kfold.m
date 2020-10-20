function [base_teste,base_treino] = split_treino_teste_Kfold(iteracao,base, n)
    %% Lógica para pegar parte da base por vez para teste, e o resto para treino
        % Testes para cada iteração: 
        % 1 - 4322 (4322)
        % 4323 - 8644 (4322)
        % 8645 - 12967 (4323)
        % 12968 - 17290 (4323)
        % 17291 - 21613 (4323)
        if iteracao < 3
            inicio_amostra_teste = ((iteracao-1)*4322) + 1;
            fim_amostra_teste = iteracao * 4322;
        else
            inicio_amostra_teste = ((iteracao-1)*4323) - 1;
            fim_amostra_teste = (iteracao * 4323) - 2;
        end

        % Parte separada para teste
        base_teste = base(inicio_amostra_teste:fim_amostra_teste, :);

        % Pegando o resto para o treino
        if iteracao == 1
            base_treino = base(fim_amostra_teste+1:n, :);
        elseif iteracao == 5
            base_treino = base(1:inicio_amostra_teste-1, :);
        else
            base_treino = [base(1:inicio_amostra_teste-1,:);base(fim_amostra_teste+1:n, :)];
        end
end

