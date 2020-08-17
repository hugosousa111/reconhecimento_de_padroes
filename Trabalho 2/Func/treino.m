function treino(base_treino, posicao_candidato_limiar,pai)
    [linhas, colunas] = size(base_treino);
    n_atributos = colunas - 1;
    
    if n_atributos == 0
        % Como é recursivo, esse é um dos casos base, só entra aqui, quando
        % já fez "perguntas" com todos os atributos, nesse caso, vira nó
        % final, e vejo qual a maioria das classes que sobraram nas amostras,
        % a maioria vai definir qual classe será aquele nó
        
        cont_classe_1 = 0;
        cont_classe_2 = 0;
        for i = 1:linhas
            if base_treino(i) == 1
                cont_classe_1 = cont_classe_1+1;
            else
                cont_classe_2 = cont_classe_2+1;
            end
        end
        
        if cont_classe_1 <= cont_classe_2
            % coloquei =, pois se tiver a mesma quantidade de amostras das
            % duas classes, como a base original tem mais elementos da
            % classe 2, a probabilidade de uma amostra ser da classe 2 é
            % maior que da classe 1
            nova_linha_modelo = [0,0,2,pai];
        else
            nova_linha_modelo = [0,0,1,pai];
        end       
        
        load('modelo.mat');
        modelo = [modelo; nova_linha_modelo];
        save('modelo.mat', 'modelo')
    else
        %% escolhendo os limiares 
        [candidatos_limiar,posicao_candidato_limiar, cont_candidatos,h_limiar, h_T_limiar, vetor_limiar_escolhido] = escolha_limiar(n_atributos, base_treino);
      
        %% Calcular a Entropia da base de treino
        n_classe_1_treino = sum(base_treino(:,1) == ones(linhas,1));
        n_classe_2_treino = sum(base_treino(:,1) == (ones(linhas,1)+ones(linhas,1)));

        h_base = calc_entropia(n_classe_1_treino,n_classe_2_treino,(n_classe_1_treino+n_classe_2_treino));

        %% Calcular Entropia das sub-bases divididas por atributo

        % h_atributo guarda: 
        % 1 coluna = < que o limiar
        % 2 coluna = > que o limiar
        [h_atributo, h_atributo_media] = calc_entropia_sub_base(n_atributos, base_treino, vetor_limiar_escolhido);


        %% Calcular o ganho de informação
        [max_atributo] = calc_ganho(n_atributos, h_base, h_atributo_media);
        
        %% Se [max_atributo,vetor_limiar_escolhido(max_atributo)] == [1,0]
        % é porque aquele é um nó final, sendo meu segundo caso de caso
        % base da função recursiva
        % logo, devo salvar a classe que está presente naquele nó
        if max_atributo == 1
            if vetor_limiar_escolhido(max_atributo) == 0
                nova_linha_modelo = [1,0,base_treino(1,1),pai];
                % eu pego o primeiro valor, mas poderia ser qualquer classe da base_treino
                % pois todas são iguais nesse passo, que é o passo onde não tem candidatos 
            else
                nova_linha_modelo = [max_atributo,vetor_limiar_escolhido(max_atributo),0,pai];
            end
        else
           nova_linha_modelo = [max_atributo,vetor_limiar_escolhido(max_atributo),0,pai];
        end
        
        %% Salvando o contexto no modelo
        load('modelo.mat');
        modelo = [modelo; nova_linha_modelo];
        save('modelo.mat', 'modelo');
        
        %% Chamar novamente a função treino
        if sum(posicao_candidato_limiar ~= 0) ~= 0 
            if sum(vetor_limiar_escolhido ~= 0) ~= 0 
            pai = pai+1;
        
            base_t_1 = base_treino(base_treino(:,max_atributo+1) >= vetor_limiar_escolhido(max_atributo), :);
            base_t_1(:,max_atributo+1) = [];
            % Para valores maiores que o limiar
            treino(base_t_1, posicao_candidato_limiar, pai);

            base_t_2 = base_treino(base_treino(:,max_atributo+1) < vetor_limiar_escolhido(max_atributo), :);
            base_t_2(:,max_atributo+1) = [];
            % Para valores menores que o limiar
            treino(base_t_2, posicao_candidato_limiar, pai);
        
            end
        end
    end
end   