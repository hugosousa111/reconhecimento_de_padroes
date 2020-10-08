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

% Treshold para os autovalores do PCA
rth = 0.9;

% Constante C
C = [0.01, 0.1, 1, 5, 10, 100];

% Constante gamma    
gamma = [0.01, 0.1, 1, 5, 10, 100];

% Kernel (valores = RBF ou linear)
kernel_linear = 'linear';
kernel_rbf = 'RBF';

%% Experimentos RBF
fprintf('************************ EXPERIMENTOS RBF ************************\n')
n_experimentos_RBF = length(C)*length(gamma);
mean_ac_RBF = zeros(n_experimentos_RBF, 1);
std_ac_RBF = zeros(n_experimentos_RBF, 1);
cont = 1;

for ex_c = 1: length(C)
    for ex_g = 1: length(gamma)
        fprintf('Experimento %d: C = %0.2f, gamma = %0.2f, kernel = %s\n\n',cont, C(ex_c), gamma(ex_g), kernel_rbf)
        if semente_fixa == 0
            % isso aq é pra os dados de experimentos.m ficarem com os mesmos
            % resultados do arquivo main.m
            rng(0);
        end
        [m, s] = pca_svm(base,iteracoes, rth, C(ex_c), gamma(ex_g), kernel_rbf);
        mean_ac_RBF(cont) = m;
        std_ac_RBF(cont) = s;
        fprintf('\n\n------------------------------------------------\n\n')
        cont = cont+1;
    end
end

%% Experimentos Linear
fprintf('************************ EXPERIMENTOS LINEAR ************************\n')
n_experimentos_linear = length(C);
mean_ac_linear = zeros(n_experimentos_linear, 1);
std_ac_linear = zeros(n_experimentos_linear, 1);

for ex_c = 1: length(C)
    fprintf('Experimento %d: C = %0.2f, kernel = %s\n\n',ex_c, C(ex_c), kernel_linear)
    % o gamma é enviado mas não é usado
    if semente_fixa == 0
       rng(0);
    end
    [m, s] = pca_svm(base,iteracoes, rth, C(ex_c), gamma(1), kernel_linear);
    mean_ac_linear(ex_c) = m;
    std_ac_linear(ex_c) = s;
    fprintf('\n\n------------------------------------------------\n\n')
end

%% Resultados Experimentos RBF
fprintf('************************ RESULTADOS EXPERIMENTOS RBF ************************\n')
cont = 1;
for ex_c = 1: length(C)
    for ex_g = 1: length(gamma)
        fprintf('---------------------------------\n\n')
        fprintf('Experimento %d: C = %0.2f, gamma = %0.2f, kernel = %s\n\n',cont, C(ex_c), gamma(ex_g), kernel_rbf)
        fprintf('Média das Taxas de Acurácia(em porcentagem) => %f\n', mean_ac_RBF(cont))
        fprintf('Desvio padrão das Taxas de Acurácia => %f\n', std_ac_RBF(cont))
        fprintf('\n\n---------------------------------\n\n')
        cont = cont+1;
    end
end

%% Resultados Experimentos Linear
fprintf('************************ RESULTADOS EXPERIMENTOS LINEAR ************************\n')
for ex_c = 1: length(C)
    fprintf('---------------------------------\n\n')
    fprintf('Experimento %d: C = %0.2f, kernel = %s\n\n',ex_c, C(ex_c), kernel_linear)
    fprintf('Média das Taxas de Acurácia(em porcentagem) => %f\n', mean_ac_linear(ex_c))
    fprintf('Desvio padrão das Taxas de Acurácia => %f\n', std_ac_linear(ex_c))
    fprintf('\n\n---------------------------------\n\n')
end