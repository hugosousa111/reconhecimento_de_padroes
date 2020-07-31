%% Trabalho 1 - NPC
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
    
    %% Calculando os centróides de cada atributo das duas classes
    soma_classe_1 = zeros(1,5);
    contador_classe_1 = 0;
    
    soma_classe_2 = zeros(1,5);
    contador_classe_2 = 0;
    
    for cont = 1:90
        if rotulos_treino(cont) == 1
            soma_classe_1(1) = atributos_treino(cont, 1)+ soma_classe_1(1);
            soma_classe_1(2) = atributos_treino(cont, 1)+ soma_classe_1(2);
            soma_classe_1(3) = atributos_treino(cont, 1)+ soma_classe_1(3);
            soma_classe_1(4) = atributos_treino(cont, 1)+ soma_classe_1(4);
            soma_classe_1(5) = atributos_treino(cont, 1)+ soma_classe_1(5);
            
            contador_classe_1 = 1 + contador_classe_1;
        else
            soma_classe_2(1) = atributos_treino(cont, 1)+ soma_classe_2(1);
            soma_classe_2(2) = atributos_treino(cont, 1)+ soma_classe_2(2);
            soma_classe_2(3) = atributos_treino(cont, 1)+ soma_classe_2(3);
            soma_classe_2(4) = atributos_treino(cont, 1)+ soma_classe_2(4);
            soma_classe_2(5) = atributos_treino(cont, 1)+ soma_classe_2(5);
            
            contador_classe_2 = 1 + contador_classe_2;
        end
    end
    
    centroide_classe_1 = zeros(1,5);
    centroide_classe_1(1) = soma_classe_1(1) / contador_classe_1 ;
   	centroide_classe_1(2) = soma_classe_1(2) / contador_classe_1 ;
    centroide_classe_1(3) = soma_classe_1(3) / contador_classe_1 ;
    centroide_classe_1(4) = soma_classe_1(4) / contador_classe_1 ;
    centroide_classe_1(5) = soma_classe_1(5) / contador_classe_1 ;
    
    centroide_classe_2 = zeros(1,5);
    centroide_classe_2(1) = soma_classe_2(1) / contador_classe_2 ;
   	centroide_classe_2(2) = soma_classe_2(2) / contador_classe_2 ;
    centroide_classe_2(3) = soma_classe_2(3) / contador_classe_2 ;
    centroide_classe_2(4) = soma_classe_2(4) / contador_classe_2 ;
    centroide_classe_2(5) = soma_classe_2(5) / contador_classe_2 ;
    
    %% Plotando os centróides
    
    % para funcionar deve-se apagar a próxima linha, e descomentar a seção no cálculo de distâncias, e descomentar a seção de plotar os erros
    %{
    
    % 1 p/ centróide da média
    % 2 p/ centróide da desvio
    % 3 p/ centróide da assimetria
    % 4 p/ centróide da curtorse 
    % 5 p/ centróide da momento central 3
    dim1 = 1;
    dim2 = 4;
    
    % Vermelho: centróide da parte do treino da classe 1
    % Azul: centróide da parte de treino da classe 2
    % Verde: parte de teste
    
    % Classe 1 'o'
    % Classe 2 '*'
    
    figure;    
    scatter(centroide_classe_1(dim1), centroide_classe_1(dim2), 'o', 'red')
    hold on;
    
    scatter(centroide_classe_2(dim1), centroide_classe_2(dim2), '*', 'blue')
    hold on;
    
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
    %% NPC    
    % Pega uma amostra de teste por vez para os cálculos de distância
    for i = 1:10
        vetor_teste_atual = atributos_teste(i,:);
        
        %% Calcula a distância euclidiana do vetor atual 
        % para os centróides, e guarda dentro de um vetor
        vetor_distancias = zeros(2,1);
        
        vetor_distancias(1) = sqrt(((vetor_teste_atual(1)-centroide_classe_1(1))^2)+((vetor_teste_atual(2)-centroide_classe_1(2))^2)+((vetor_teste_atual(3)-centroide_classe_1(3))^2)+((vetor_teste_atual(4)-centroide_classe_1(4))^2)+((vetor_teste_atual(5)-centroide_classe_1(5))^2)); 
        vetor_distancias(2) = sqrt(((vetor_teste_atual(1)-centroide_classe_2(1))^2)+((vetor_teste_atual(2)-centroide_classe_2(2))^2)+((vetor_teste_atual(3)-centroide_classe_2(3))^2)+((vetor_teste_atual(4)-centroide_classe_2(4))^2)+((vetor_teste_atual(5)-centroide_classe_2(5))^2));            
            
        %% Testando só duas dimensões, as mesmas dos gráficos
        %vetor_distancias(1) = sqrt(((vetor_teste_atual(dim1)-centroide_classe_1(dim1))^2)+((vetor_teste_atual(dim2)-centroide_classe_1(dim2))^2)); 
        %vetor_distancias(2) = sqrt(((vetor_teste_atual(dim1)-centroide_classe_2(dim1))^2)+((vetor_teste_atual(dim2)-centroide_classe_2(dim2))^2));            
        
        %% Previsão
        
        % Vê qual centróide mais próximo
        if vetor_distancias(1) < vetor_distancias(2)
            rotulos_previstos_teste(i) = 1;
        else
            rotulos_previstos_teste(i) = 2;
        end
        
        %% Plotando os errados
        % essa parte serve para analisar os erros quando treinado com duas dimensões
        % as classificações erradas, ficam com um quadrado preto ao redor
        % antes, deve ser executado a parte que plota os gráficos
        
        % para funcionar apague a próxima linha
        %{
        
        if rotulos_previstos_teste(i) ~= rotulos_teste(i)
            sz = 90;
            scatter(base_teste(i, dim1), base_teste(i, dim2), sz, 's', 'black')
            hold on;
        end
        %}
    end
    
    %% Compara rótulos previstos com os reais
    somatorio = sum(rotulos_previstos_teste == rotulos_teste);
    
    taxa_de_acerto = (somatorio/10) * 100;

    vetor_taxa_de_acerto(iteracao) = taxa_de_acerto;
    taxa_de_acerto = 0;

end

disp("Média das Taxas de Acurácia em %")

disp("Minha Implementação do NPC")
disp(sum(vetor_taxa_de_acerto)/10)
