% Trabalho 4
% PCA e Classificador SVM
% Disciplina de Reconhecimento de Padrões
% Hugo Silveira Sousa 378998

% SVM + PCA

%% Limpar variáveis, limpar console, fechar telas
clear; clc; close all; 

%% funções
addpath('Func/');

%% Carrega a base
base = readtable('divorce/divorce.csv');
base = base{:,:};

%% Parâmentros do código

% Quantidade de iterações do For principal?
iteracoes = 20;

% Semente aleatória ou fixa? Comente a próxima linha, se quiser aleatória
% 0 para fixa, 1 para aleatoria
semente_fixa = 0; %Sempre a mesma semente do rand, se quiser manter os mesmos resultados

if semente_fixa == 0
    rng(0);
end

% Treshold para os autovalores do PCA
rth = 0.9;

% Constante C
C = 100;

% Constante gamma    
gamma = 0.01;

% Kernel (valores = RBF ou linear)
%kernel = 'linear';
kernel = 'RBF';

%% Experimento
[media, std, matriz_c] = pca_svm(base,iteracoes, rth, C, gamma, kernel);

%% Resultado
fprintf('---------------------------------\n\n')
fprintf('Experimento: C = %0.2f, gamma = %0.2f, kernel = %s\n\n', C, gamma, kernel)
fprintf('Média das Taxas de Acurácia(em porcentagem) => %f\n', media)
fprintf('Desvio padrão das Taxas de Acurácia => %f\n', std)
fprintf('Matriz de confusão (Média) => \n  %0.2f   %0.2f\n  %0.2f   %0.2f ', matriz_c)
fprintf('\n\n---------------------------------\n\n')
