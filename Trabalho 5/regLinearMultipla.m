% Trabalho 4
% Regressão
% Disciplina de Reconhecimento de Padrões
% Hugo Silveira Sousa 378998

% Regressão Linear Multipla - base House Sales in King County, USA

%% Limpar variáveis, limpar console, fechar telas
clear; clc; close all; 

%% funções
addpath('Func/');

%% Carrega a base
base = readtable('Bases/kc_house_data.csv');

%% Tratando os dados da base
var_floor = base{:, 8}; % estava no formato de str
var_floor = str2double(var_floor); 

var_zipcode = base{:, 17}; % estava no formato de str
var_zipcode = str2double(var_zipcode); 

base = [base{:, 3:7} var_floor base{:, 9:16} var_zipcode base{:, 18:21}];

%% semente
semente_fixa = 0; %Sempre a mesma semente do rand, se quiser manter os mesmos resultados

if semente_fixa == 0
    rng(0);
end

lambda = 0.01;
%lambda = 0.1; % Esse lambda é melhor (Tira o warning)

%% Embaralhando as linhas da base
[base] = permuta_base(base);
[n, at] = size(base);

%% K-fold
k_fold = 5; % Dividir a base em 5 partes

vetor_r2aj_treino = zeros(k_fold,1);
vetor_r2aj_teste = zeros(k_fold,1);
matriz_beta = zeros(at, k_fold);

for iteracao = 1:k_fold
    fprintf('\n\n***********************\nIteração = %d\n\n', iteracao);

    %% Lógica para pegar parte da base por vez para teste, e o resto para treino
    % Testes para cada iteração: 
    % 1 - 4322 (4322)
    % 4323 - 8644 (4322)
    % 8645 - 12967 (4323)
    % 12968 - 17290 (4323)
    % 17291 - 21613 (4323)
    [base_teste,base_treino] = split_treino_teste_Kfold(iteracao,base, n);
    
    %% Separando X e y
    x_treino = base_treino(:,2:19);
    x_teste = base_teste(:,2:19);

    [n_treino, ~] = size(x_treino);
    [n_teste, ~] = size(x_teste);

    X_treino = [ones(n_treino,1) x_treino];
    X_teste = [ones(n_teste,1) x_teste];

    y_treino = base_treino(:,1);
    y_teste = base_teste(:,1);
    
    %% Treinamento
    beta = calc_beta(X_treino,y_treino, lambda);
    
    disp("Vetor beta")
    disp(beta)
    matriz_beta(:, iteracao) = beta;
    
    %% Teste
    y_chapeu_treino = X_treino*beta;
    y_chapeu_teste = X_teste*beta;

    R2AJ_treino = calc_r2aj(y_treino,y_chapeu_treino, n_treino, 1);
    fprintf('R2AJ_treino = %f\n', R2AJ_treino);
    
    R2AJ_teste = calc_r2aj(y_teste,y_chapeu_teste, n_teste, 1);
    fprintf('R2AJ_teste = %f\n', R2AJ_teste);
    
    %% 
    vetor_r2aj_treino(iteracao) = R2AJ_treino;
    vetor_r2aj_teste(iteracao) = R2AJ_teste;
end
disp("--------------------------------------")
fprintf('\n\nMédia do R2AJ_treino = %f\n', mean(vetor_r2aj_treino));
fprintf('Desvio padrão do R2AJ_treino = %f\n', std(vetor_r2aj_treino));
disp("--------------------------------------")
fprintf('\n\nMédia do R2AJ_teste = %f\n', mean(vetor_r2aj_teste));
fprintf('Desvio padrão do R2AJ_teste = %f\n', std(vetor_r2aj_teste));

disp("--------------------------------------")
%fprintf('\n\nMédia dos vetores de betas = %f\n', mean(matriz_beta'));
fprintf('\n\nDesvio padrão dos coeficientes beta = \n')
fprintf('%f\n', std(matriz_beta'));


%% Para toda a base
x = base(:,2:19);
[n, ~] = size(x);
X = [ones(n,1) x];
y = base(:,1);
beta = calc_beta(X,y, lambda);
y_chapeu = X*beta;
R2AJ = calc_r2aj(y,y_chapeu, n, 1);
fprintf("\n\nR2AJ treinando com toda a base = \n")
fprintf('R2AJ = %f\n', R2AJ);
