% Trabalho 3 
% Classificadores Bayesianos, Critério MAP e LDA
% Disciplina de Reconhecimento de Padrões
% Hugo Silveira Sousa 378998

% 2.2) Classificadores Bayesianos
% II) Naive Bayes

%% Limpar variáveis, limpar console, fechar telas
clear; clc; close all; 

%% funções
addpath('Func/');

%% Carrega a base
load data_dermato_01.mat;
[quant_base, colunas_base] = size(derma);

%% Embaralhando as linhas da base
rng(0); % Sempre a mesma semente do rand, para manter os mesmos resultados
vetor_posicoes_rand = randperm(quant_base);
derma_permutada = zeros(quant_base,35);

for cont = 1:quant_base
   derma_permutada(cont, :) = derma(vetor_posicoes_rand(cont), :);
end

%% K-fold
k_fold = 5; % Dividir a base em 5 partes

vetor_acuracia = zeros(k_fold,1);

for iteracao = 1:k_fold
    
    %% Lógica para pegar parte da base por vez para teste, e o resto para treino
    % Testes para cada iteração: 
    % 1 - 71 (71)
    % 72 - 142 (71)
    % 143 - 214 (72)
    % 215 - 286 (72)
    % 287 - 358 (72)
    if iteracao < 3
        inicio_amostra_teste = ((iteracao-1)*71) + 1;
        fim_amostra_teste = iteracao * 71;
    else
        inicio_amostra_teste = ((iteracao-1)*72) - 1;
        fim_amostra_teste = (iteracao * 72) - 2;
    end
    
    % Parte separada para teste
    base_teste = derma_permutada(inicio_amostra_teste:fim_amostra_teste, :);
    
    % Pegando o resto para o treino
    if iteracao == 1
        base_treino = derma_permutada(fim_amostra_teste+1:quant_base, :);
    elseif iteracao == 5
        base_treino = derma_permutada(1:inicio_amostra_teste-1, :);
    else
        base_treino = [derma_permutada(1:inicio_amostra_teste-1,:);derma_permutada(fim_amostra_teste+1:quant_base, :)];
    end
    
    %% Z-score
    [quant_treino, ~] = size(base_treino);
    [quant_teste, ~] = size(base_teste);
    
    base_treino_padronizada = zeros(quant_treino,35);
    base_teste_padronizada = zeros(quant_teste,35);

    for coluna = 1:34
        media_z = mean(base_treino(:, coluna));
        desvio_z = std(base_treino(:, coluna));
        for linha = 1:quant_treino
            base_treino_padronizada(linha, coluna) = (base_treino(linha, coluna)-media_z)/desvio_z;
        end
        for linha = 1:quant_teste
            base_teste_padronizada(linha, coluna) = (base_teste(linha, coluna)-media_z)/desvio_z;
        end
    end

    base_treino_padronizada(:,35) = base_treino(:,35);
    base_teste_padronizada(:,35) = base_teste(:,35);
    
    %% Classes
    classes = 6;
    classe1 = base_treino_padronizada(base_treino_padronizada(:,35)==1, :);
    classe1_at = classe1(:, 1:34);
    classe2 = base_treino_padronizada(base_treino_padronizada(:,35)==2, :);
    classe2_at = classe2(:, 1:34);
    classe3 = base_treino_padronizada(base_treino_padronizada(:,35)==3, :);
    classe3_at = classe3(:, 1:34);
    classe4 = base_treino_padronizada(base_treino_padronizada(:,35)==4, :);
    classe4_at = classe4(:, 1:34);
    classe5 = base_treino_padronizada(base_treino_padronizada(:,35)==5, :);
    classe5_at = classe5(:, 1:34);
    classe6 = base_treino_padronizada(base_treino_padronizada(:,35)==6, :);
    classe6_at = classe6(:, 1:34);
    
    %% Número de Instâncias
    [quant_c1, ~] = size(classe1);
    [quant_c2, ~] = size(classe2);
    [quant_c3, ~] = size(classe3);
    [quant_c4, ~] = size(classe4);
    [quant_c5, ~] = size(classe5);
    [quant_c6, ~] = size(classe6);
    
    %% Probabilidade a priori de cada classe
    probabilidade_priori = zeros(classes,1);

    probabilidade_priori(1) = quant_c1/quant_treino;
    probabilidade_priori(2) = quant_c2/quant_treino;
    probabilidade_priori(3) = quant_c3/quant_treino;
    probabilidade_priori(4) = quant_c4/quant_treino;
    probabilidade_priori(5) = quant_c5/quant_treino;
    probabilidade_priori(6) = quant_c6/quant_treino;

    %% Vetor média
    vetor_media_classe1 = calc_vetor_media(classe1_at);
    vetor_media_classe2 = calc_vetor_media(classe2_at);
    vetor_media_classe3 = calc_vetor_media(classe3_at);
    vetor_media_classe4 = calc_vetor_media(classe4_at);
    vetor_media_classe5 = calc_vetor_media(classe5_at);
    vetor_media_classe6 = calc_vetor_media(classe6_at);

    %% Matriz de covariancia
    matriz_cov_classe1 = calc_matriz_covariancia(classe1_at,vetor_media_classe1);
    matriz_cov_classe2 = calc_matriz_covariancia(classe2_at,vetor_media_classe2);
    matriz_cov_classe3 = calc_matriz_covariancia(classe3_at,vetor_media_classe3);
    matriz_cov_classe4 = calc_matriz_covariancia(classe4_at,vetor_media_classe4);
    matriz_cov_classe5 = calc_matriz_covariancia(classe5_at,vetor_media_classe5);
    matriz_cov_classe6 = calc_matriz_covariancia(classe6_at,vetor_media_classe6);
    
    %% Correção dos valores das matrizes de covariancia com o termo de regularização lambda
    % Problema das determinantes iguais a zero e inversão de matrizes singulares
    I = eye(colunas_base-1);
    lambda = 0.01;
    matriz_cov_classe1 = matriz_cov_classe1 + (lambda * I);
    matriz_cov_classe2 = matriz_cov_classe2 + (lambda * I);
    matriz_cov_classe3 = matriz_cov_classe3 + (lambda * I);
    matriz_cov_classe4 = matriz_cov_classe4 + (lambda * I);
    matriz_cov_classe5 = matriz_cov_classe5 + (lambda * I);
    matriz_cov_classe6 = matriz_cov_classe6 + (lambda * I);
    
    %% Deixando as matrizes de Covariância apenas com valores da diagonal
    for i = 1: colunas_base-1
        for j = 1: colunas_base-1
            if i ~= j
                matriz_cov_classe1(i,j) = 0;
                matriz_cov_classe2(i,j) = 0;
                matriz_cov_classe3(i,j) = 0;
                matriz_cov_classe4(i,j) = 0;
                matriz_cov_classe5(i,j) = 0;
                matriz_cov_classe6(i,j) = 0;
            end
        end
    end
    
    %% Naive Bayes
    % Equação: 
    % min i: ln |M_cov i| + (X - Ui)^T . M_cov^-1 . (X - Ui) - 2.ln P(Ci)
    % Onde M_cov é uma matriz diagonal 
    
    
    % Teste
    rotulos_previstos_teste = zeros(quant_teste,1);
    for cont = 1:quant_teste
        X = base_teste_padronizada(cont, 1:34).';
        
        vetor_nb = zeros(6,1);
        vetor_nb(1) = log(det(matriz_cov_classe1)) + (((X - vetor_media_classe1.').')*inv(matriz_cov_classe1)*(X - vetor_media_classe1.')) - (2*log(probabilidade_priori(1)));
        vetor_nb(2) = log(det(matriz_cov_classe2)) + (((X - vetor_media_classe2.').')*inv(matriz_cov_classe2)*(X - vetor_media_classe2.')) - (2*log(probabilidade_priori(2)));
        vetor_nb(3) = log(det(matriz_cov_classe3)) + (((X - vetor_media_classe3.').')*inv(matriz_cov_classe3)*(X - vetor_media_classe3.')) - (2*log(probabilidade_priori(3)));
        vetor_nb(4) = log(det(matriz_cov_classe4)) + (((X - vetor_media_classe4.').')*inv(matriz_cov_classe4)*(X - vetor_media_classe4.')) - (2*log(probabilidade_priori(4)));
        vetor_nb(5) = log(det(matriz_cov_classe5)) + (((X - vetor_media_classe5.').')*inv(matriz_cov_classe5)*(X - vetor_media_classe5.')) - (2*log(probabilidade_priori(5)));
        vetor_nb(6) = log(det(matriz_cov_classe6)) + (((X - vetor_media_classe6.').')*inv(matriz_cov_classe6)*(X - vetor_media_classe6.')) - (2*log(probabilidade_priori(6))); 
        
        [~, posicao] = min(vetor_nb);  % Menor posição é o rótulo estimado
        
        rotulos_previstos_teste(cont) = posicao;
        
    end
    
    %% Compara rótulos previstos com os reais
    somatorio = sum(rotulos_previstos_teste == base_teste(:, 35));
    
    acuracia = (somatorio/quant_teste) * 100;

    vetor_acuracia(iteracao) = acuracia;
end

disp("Naive B - Média das Taxas de Acurácia em %")
disp(mean(vetor_acuracia))
disp("--------------------------------------")
disp("Desvio padrão das Taxas de Acurácia")
disp(std(vetor_acuracia))
