function [media_ac,std_ac] = pca_svm(base,iteracoes,rth, C, gamma, kernel)
    %% Roda varias vezes e tira a média das acurácias
    vetor_acuracia = zeros(iteracoes,1);

    for iteracao = 1:iteracoes
        %% Embaralhando as linhas da base
        [base_permutada] = permuta_base(base);

        %% Lógica para pegar 30% da base para teste, e o resto para treino
        % 001 - 119 Treino (70%)
        % 120 - 170 Teste  (30%)

        porcentagem_treino = 70;
        [atributos_treino,rotulos_treino, atributos_teste, rotulos_teste] = split_treino_teste(base_permutada, porcentagem_treino);
        [quant_amostras_teste, ~ ] = size(rotulos_teste);

        %% PCA
        [atributos_treino_pca,atributos_teste_pca] = PCA(atributos_treino,atributos_teste, rth);

        % Se quiser testar sem aplicar o PCA
        %atributos_treino_pca = atributos_treino.';
        %atributos_teste_pca = atributos_teste.';

        %% SVM

        %% Tranformando os rótulos de 0 para -1
        rotulos_treino_al = transforma_rotulos(rotulos_treino, 1);
        rotulos_teste_al = transforma_rotulos(rotulos_teste, 1);

        %% SVM Treino

            %% Kernel
            if strcmp(kernel, 'linear')
                K = kernel_linear(atributos_treino_pca,atributos_treino_pca);
            elseif strcmp(kernel, 'RBF')
                K = kernel_RBF(atributos_treino_pca,atributos_treino_pca, gamma);
            end

            %% Cálculo do alpha, vetores de suporte e b
            [alpha, vet_sup,b] = SVM_treino(rotulos_treino_al, K, C);

        %% SVM Teste

            %% Kernel
            if strcmp(kernel, 'linear')
                K2 = kernel_linear(atributos_treino_pca(:,vet_sup),atributos_teste_pca);
            elseif strcmp(kernel, 'RBF')
                K2 = kernel_RBF(atributos_treino_pca(:,vet_sup),atributos_teste_pca, gamma);
            end

            %% Previsão
            [rotulos_teste_est] = SVM_teste(vet_sup,alpha,b, rotulos_treino_al, quant_amostras_teste, K2);

            %error_rate = length(find(rotulos_teste_al~=rotulos_teste_est))/length(rotulos_teste_al)

        %% Matriz de confusão
        fprintf('Iteração => %d',iteracao)
        [matriz_confusao] = calc_matriz_de_confusao(rotulos_teste_al, rotulos_teste_est);
        fprintf('\nMatriz de Confusão => \n  %d   %d\n  %d   %d',matriz_confusao)

        %% Compara rótulos previstos com os reais
        somatorio = sum(rotulos_teste_est == rotulos_teste_al);

        acuracia = (somatorio/quant_amostras_teste) * 100;
        fprintf('\nAcurácia => %f\n',acuracia)
        vetor_acuracia(iteracao) = acuracia;

        disp("%%%%%%%%%%%%%%%%%%%%%%%")
    end
    
    
    %disp("Média das Taxas de Acurácia em %")
    media_ac = mean(vetor_acuracia);
    %disp(media_ac)
    %disp("--------------------------------------")
    %disp("Desvio padrão das Taxas de Acurácia")
    std_ac = std(vetor_acuracia);
    %disp(std_ac)
    %disp("--------------------------------------")
    
    
    %disp("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
    %disp("Formato da Matriz de Confusão:")
    %disp(" | TP   FP |")
    %disp(" | FN   TN |")
end

