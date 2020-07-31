%% Trabalho 1 - KNN
% Disciplina de Reconhecimento de Padrões
% Hugo Silveira Sousa 378998

%% Limpar variáveis, limpar console, fechar telas
clear; clc; close all; 

%% Carrega a base
load Classe1.mat;
load Classe2.mat;

%plot(Classe1) %só pra vê como é
%plot(Classe2) %só pra vê como é

%% Extraindo Atributos Classe 1
at_1_media = (mean(Classe1))'; % Média
at_1_desvio = (std(Classe1))'; % Desvio padrao
at_1_assimetria = (skewness(Classe1))'; % Assimetria
at_1_curtose = (kurtosis(Classe1))'; % Curtose
at_1_momento = (moment(Classe1,3))'; % Momento Central de Ordem 3

% Juntei tudo em uma matriz, onde cada linha representa uma amostra da base
% e cada coluna um atributo
atributos_classe1 = [at_1_media, at_1_desvio, at_1_assimetria, at_1_curtose, at_1_momento];

%% Extraindo Atributos Classe 2
at_2_media = (mean(Classe2))'; % Média
at_2_desvio = (std(Classe2))'; % Desvio padrão
at_2_assimetria = (skewness(Classe2))'; % Assimetria
at_2_curtose = (kurtosis(Classe2))'; % Curtose
at_2_momento = (moment(Classe2,3))'; % Momento Central de Ordem 3

% Juntei tudo em uma matriz, onde cada linha representa uma amostra da base
% e cada coluna um atributo
atributos_classe2 = [at_2_media, at_2_desvio, at_2_assimetria, at_2_curtose, at_2_momento];

%% Vetor de rótulos
rotulo_classe1 = ones(1,50)'; % vetor de 1's
rotulo_classe2 = ones(1,50)' + ones(1,50)'; % vetor de 2's

%% Z-score
atributos = [atributos_classe1; atributos_classe2];
atributos_padronizado = zeros(100,5);

for coluna = 1:5
    media_z = mean(atributos(:, coluna));
    desvio_z = std(atributos(:, coluna));
    for linha = 1:100
        atributos_padronizado(linha, coluna) = (atributos(linha, coluna)-media_z)/desvio_z;
    end
end

%% Juntando em uma só matriz base
rotulo = [rotulo_classe1; rotulo_classe2];
base = [atributos_padronizado, rotulo];
%base = [atributos, rotulo]; %TESTE SEM PADRONIZAR

%% Embaralhando as linhas da base
rng(0); % Sempre a mesma semente para o rand, para fins de manter os mesmos resultados
vetor_posicoes_rand = randperm(100);

quant_de_amostras = 100;
base_perm = zeros(100,6);

for cont = 1:quant_de_amostras
   base_perm(cont, :) = base(vetor_posicoes_rand(cont), :);
end

%% K-fold
k_fold = 10; % Dividir a base em 10 partes

quant_de_amostras_por_iteracao = quant_de_amostras/k_fold;

vetor_taxa_de_acerto = zeros(10,1);
vetor_taxa_de_acerto2 = zeros(10,1);

for iteracao = 1:k_fold
    
    %% Lógica para pegar parte da base por vez para teste, e o resto para treino
    inicio_amostra_teste = ((iteracao-1)*quant_de_amostras_por_iteracao) + 1;
    fim_amostra_teste = iteracao * quant_de_amostras_por_iteracao;
    
    % Parte separada para teste
    % base_perm = base % TESTE SEM PERMUTAR 
    base_teste = base_perm(inicio_amostra_teste:fim_amostra_teste, :);
    
    % Pegando o resto para o treino
    if iteracao == 1
        base_treino = base_perm(fim_amostra_teste+1:100, :);
    elseif iteracao == 10
        base_treino = base_perm(1:inicio_amostra_teste-1, :);
    else
        base_treino = [base_perm(1:inicio_amostra_teste-1,:); base_perm(fim_amostra_teste+1:100, :)];
    end
    
    %% Separando atributos e rótulos de treino e teste
    atributos_treino = base_treino(:, 1:5);
    rotulos_treino = base_treino(:, 6);
    
    atributos_teste = base_teste(:, 1:5);
    rotulos_teste = base_teste(:, 6);
    
    rotulos_previstos_teste = zeros(10,1);
    
    %% Plotando algumas dimensões
    % Essa parte serve apenas para comparar dois atributos, o algoritmo está com
    % 100% de acurácia utilizando os 5 atributos, e eu achei estranho
    % Nas comparações, percebi que o algoritmo pode está certo, pois esses atributos 
    % escolhidos, como a assimetria e a média, já separam bem as classes, mas, 
    % por exemplo, se comparar só a média e o desvio padrão, algumas amostras 
    % estão bem próximas, e se treinar só com esses dois atributos, temos 92% de acurácia
    
    % para funcionar deve-se apagar a próxima linha, e descomentar a seção no cálculo de distâncias
    %{
    
    % 1 p/ média
    % 2 p/ desvio
    % 3 p/ assimetria
    % 4 p/ curtorse 
    % 5 p/ momento central 3
    dim1 = 1; % também serve pro treino só com duas dimensões
    dim2 = 2;
    
    % Vermelho: parte de treino da classe 1
    % Azul: parte de treino da classe 2
    % Verde: parte de teste
    
    % Classe 1 'o'
    % Classe 2 '*'
    
    figure;
    for contador = 1:90
        if rotulos_treino(contador) == 1
            scatter(base_treino(contador, dim1), base_treino(contador, dim2), 'o', 'red')
            hold on;
        else 
            scatter(base_treino(contador, dim1), base_treino(contador, dim2), '*', 'blue')
            hold on;
        end
    end
    
    for contador = 1:10
        if rotulos_teste(contador) == 1
            scatter(base_teste(contador, dim1), base_teste(contador, dim2), 'o', 'green')
            hold on;
        else 
            scatter(base_teste(contador, dim1), base_teste(contador, dim2), '*', 'green')
            hold on;
        end
    end
    %}
    
    %% KNN    
    % Pega uma amostra de teste por vez para os cálculos de distância
    for i = 1:10
        vetor_teste_atual = atributos_teste(i,:);
        
        %% Calcula a distância euclidiana do vetor atual
        % para todas as amostras de treino, e guarda dentro de um vetor
        vetor_distancias = zeros(90,1);
        for cont = 1:90
            vetor_treino_atual = atributos_treino(cont, :);
            vetor_distancias(cont) = sqrt(((vetor_teste_atual(1)-vetor_treino_atual(1))^2)+((vetor_teste_atual(2)-vetor_treino_atual(2))^2)+((vetor_teste_atual(3)-vetor_treino_atual(3))^2)+((vetor_teste_atual(4)-vetor_treino_atual(4))^2)+((vetor_teste_atual(5)-vetor_treino_atual(5))^2));            
            
            %% Testando só duas dimensões, as mesmas dos gráficos
            %vetor_distancias(cont) = sqrt(((vetor_teste_atual(dim1)-vetor_treino_atual(dim1))^2)+((vetor_teste_atual(dim2)-vetor_treino_atual(dim2))^2));
        end
        
        %% Pego os k vizinhos com menores distâncias
        % K número de vizinhos
        % Testei com alguns valores, e todos dão 100% de acurácia
        % apartir de k = 64, a acurácia começa a cair
        k = 3;
        
        vetor_menores_distancias = zeros(k,1);
        vetor_indices_menores_distancias = zeros(k,1);
        
        for j = 1:k
            [vetor_menores_distancias(j), vetor_indices_menores_distancias(j)] = min(vetor_distancias);
            vetor_distancias(vetor_indices_menores_distancias(j)) = inf;
        end
  
        rotulos_vizinhos_proximos = zeros(k,1);
        % Vê os rótulos dos vizinhos mais próximos
        % Esse vetor é ordenado do mais próximo ao mais distante desses vizinhos
        for j = 1:k
            rotulos_vizinhos_proximos(j) = rotulos_treino(vetor_indices_menores_distancias(j));
        end
        
        %% Previsão
        
        % Vê qual classe mais presente nos vizinhos próximos
        n_classe_1 = 0;
        n_classe_2 = 0;
        for j = 1:k
            if rotulos_vizinhos_proximos(j) == 1
                n_classe_1 = n_classe_1 + 1;
            else
                n_classe_2 = n_classe_2 + 2;
            end
        end
        
        % Se for empate, é porque k é par
        % Como o vetor rotulos_vizinhos_proximos é ordenado, recalculo até k-1
        if n_classe_1 == n_classe_2  
            n_classe_1 = 0;
            n_classe_2 = 0;
            for j = 1:k-1
                if rotulos_vizinhos_proximos(j) == 1
                    n_classe_1 = n_classe_1 + 1;
                else
                    n_classe_2 = n_classe_2 + 2;
                end
            end 
        end 
        
        % Salvando o rótulo previsto
        if n_classe_1>n_classe_2
            rotulos_previstos_teste(i) = 1;
        else
            rotulos_previstos_teste(i) = 2;
        end
        
    end
    
    %% Compara rótulos previstos com os reais
    somatorio = sum(rotulos_previstos_teste == rotulos_teste);
    
    taxa_de_acerto = (somatorio/10) * 100;

    vetor_taxa_de_acerto(iteracao) = taxa_de_acerto;
    taxa_de_acerto = 0;

    %% Usando o método do Matlab para comparar os resultados com a minha implementação
    % para funcionar deve-se apagar a próxima linha, e descomentar as duas últimas linhas do código
    %{
    Mdl = fitcknn(atributos_treino,rotulos_treino,'NumNeighbors',k);
    %Mdl
    label = predict(Mdl,atributos_teste);
    
    somatorio2 = sum(label == rotulos_teste);
    taxa_de_acerto2 = (somatorio2/10) * 100;
    vetor_taxa_de_acerto2(iteracao) = taxa_de_acerto2;
    taxa_de_acerto2 = 0;
    %}
    
end

disp("Média das Taxas de Acurácia em %")

disp("Minha Implementação do K-NN")
disp(sum(vetor_taxa_de_acerto)/10)

%disp("Método de K-NN do Matlab")
%disp(sum(vetor_taxa_de_acerto2)/10)