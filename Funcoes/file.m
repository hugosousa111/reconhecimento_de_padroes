% Disciplina de Reconhecimento de Padrões
% Hugo Silveira Sousa 378998

%% Limpar variáveis, limpar console, fechar telas
clear; clc; close all; 

%% funções
addpath('Func/');

%% Carrega a base
base = table2array(readtable('wine.csv'));

%% 
classes = 3;

classe1 = base(1:59, :);
classe1_at = classe1(:, 2:14);

classe2 = base(60:130, :);
classe2_at = classe2(:, 2:14);

classe3 = base(131:178, :);
classe3_at = classe3(:, 2:14);

%% Probabilidade a priori de cada classe
probabilidade_priori = zeros(classes,1);

probabilidade_priori(1) = 59/178;
probabilidade_priori(2) = 71/178;
probabilidade_priori(3) = 48/178;

%% Calculando o vetor média de cada classe
vetor_media_base = calc_vetor_media(base(:,2:14));
vetor_media_classe1 = calc_vetor_media(classe1_at);
vetor_media_classe2 = calc_vetor_media(classe2_at);
vetor_media_classe3 = calc_vetor_media(classe3_at);


%% Matriz de covariancia

matriz_cov_classe1 = calc_matriz_covariancia(classe1_at,vetor_media_classe1);
matriz_cov_classe1_cov = cov(classe1_at);

matriz_cov_classe2 = calc_matriz_covariancia(classe2_at,vetor_media_classe2);
matriz_cov_classe2_cov = cov(classe2_at);

matriz_cov_classe3 = calc_matriz_covariancia(classe3_at,vetor_media_classe3);
matriz_cov_classe3_cov = cov(classe3_at);

matriz_cov_base = calc_matriz_covariancia(base(:,2:14), vetor_media_base);
matriz_cov_base_cov = cov(base(:,2:14));

%% Matriz de Correlacao

matriz_cor_classe1 = calc_matriz_correlacao(classe1_at,vetor_media_classe1);
matriz_cor_classe1_cor = corr(classe1_at);

matriz_cor_classe2 = calc_matriz_correlacao(classe2_at,vetor_media_classe2);
matriz_cor_classe2_cor = corr(classe2_at);

matriz_cor_classe3 = calc_matriz_correlacao(classe3_at,vetor_media_classe3);
matriz_cor_classe3_cor = corr(classe3_at);

matriz_cor_base = calc_matriz_correlacao(base(:,2:14), vetor_media_base);
matriz_cor_base_cor = corr(base(:,2:14));
