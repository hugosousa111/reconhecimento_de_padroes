% Trabalho 3 
% Classificadores Bayesianos, Critério MAP e LDA
% Disciplina de Reconhecimento de Padrões
% Hugo Silveira Sousa 378998

% 2.1) Análise inicial dos dados

%% Limpar variáveis, limpar console, fechar telas
clear; clc; close all; 

%% funções
addpath('Func/');

%% Carrega a base
load data_dermato_01.mat;

%% Classes
classes = 6;
classe1 = derma(derma(:,35)==1, :);
classe1_at = classe1(:, 1:34);
classe2 = derma(derma(:,35)==2, :);
classe2_at = classe2(:, 1:34);
classe3 = derma(derma(:,35)==3, :);
classe3_at = classe3(:, 1:34);
classe4 = derma(derma(:,35)==4, :);
classe4_at = classe4(:, 1:34);
classe5 = derma(derma(:,35)==5, :);
classe5_at = classe5(:, 1:34);
classe6 = derma(derma(:,35)==6, :);
classe6_at = classe6(:, 1:34);

%% Vetor média
vetor_media_classe1 = calc_vetor_media(classe1_at);
vetor_media_classe2 = calc_vetor_media(classe2_at);
vetor_media_classe3 = calc_vetor_media(classe3_at);
vetor_media_classe4 = calc_vetor_media(classe4_at);
vetor_media_classe5 = calc_vetor_media(classe5_at);
vetor_media_classe6 = calc_vetor_media(classe6_at);

vetor_media_base = calc_vetor_media(derma(:,1:34));

%% Vetor variancia
vetor_variancia_classe1 = calc_vetor_variancia(classe1_at);
vetor_variancia_classe2 = calc_vetor_variancia(classe2_at);
vetor_variancia_classe3 = calc_vetor_variancia(classe3_at);
vetor_variancia_classe4 = calc_vetor_variancia(classe4_at);
vetor_variancia_classe5 = calc_vetor_variancia(classe5_at);
vetor_variancia_classe6 = calc_vetor_variancia(classe6_at);

vetor_variancia_base = calc_vetor_variancia(derma(:,1:34));

%% Matriz de covariancia
matriz_cov_classe1 = calc_matriz_covariancia(classe1_at,vetor_media_classe1);
matriz_cov_classe2 = calc_matriz_covariancia(classe2_at,vetor_media_classe2);
matriz_cov_classe3 = calc_matriz_covariancia(classe3_at,vetor_media_classe3);
matriz_cov_classe4 = calc_matriz_covariancia(classe4_at,vetor_media_classe4);
matriz_cov_classe5 = calc_matriz_covariancia(classe5_at,vetor_media_classe5);
matriz_cov_classe6 = calc_matriz_covariancia(classe6_at,vetor_media_classe6);

matriz_cov_base = calc_matriz_covariancia(derma(:,1:34), vetor_media_base);

%% Matriz de Correlacao
matriz_cor_classe1 = calc_matriz_correlacao(classe1_at,vetor_media_classe1);
matriz_cor_classe2 = calc_matriz_correlacao(classe2_at,vetor_media_classe2);
matriz_cor_classe3 = calc_matriz_correlacao(classe3_at,vetor_media_classe3);
matriz_cor_classe4 = calc_matriz_correlacao(classe4_at,vetor_media_classe4);
matriz_cor_classe5 = calc_matriz_correlacao(classe5_at,vetor_media_classe5);
matriz_cor_classe6 = calc_matriz_correlacao(classe6_at,vetor_media_classe6);

matriz_cor_base = calc_matriz_correlacao(derma(:,1:34), vetor_media_base);

plota_com_cores(matriz_cor_base, 'Mapa de Correlação')    
