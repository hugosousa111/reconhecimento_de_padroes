% Trabalho 4
% Regressão
% Disciplina de Reconhecimento de Padrões
% Hugo Silveira Sousa 378998

% Regressão Polinomial - base aerogerador

%% Limpar variáveis, limpar console, fechar telas
clear; clc; close all; 

%% funções
addpath('Func/');

%% Carrega a base
load Bases/aerogerador.dat; %pegar o arquivo 

%% semente
semente_fixa = 0; %Sempre a mesma semente do rand, se quiser manter os mesmos resultados

if semente_fixa == 0
    rng(0);
end

lambda = 0.01;

%% Embaralhando as linhas da base
[aerogerador] = permuta_base(aerogerador);

%% Dividindo a base em treino e teste
porcentagem_treino = 70;
[x_treino,y_treino, x_teste, y_teste] = split_treino_teste(aerogerador, porcentagem_treino);

n_treino = length(x_treino); % numero de amostras de treino
n_teste = length(x_teste); % numero de amostras de treino

vet_um_treino = ones(1,n_treino)';
vet_um_teste = ones(1,n_teste)';

%% Plotando os pontos da base
hold on;
plot(x_treino,y_treino,'c*');
grid on;
plot(x_teste,y_teste,'m*');

%% Polinômio de grau 1
    grau = 1;

    %% Treinamento
    X_treino = [vet_um_treino x_treino];
    beta = calc_beta(X_treino,y_treino, lambda);

    %% Teste da base de treino
    y_chapeu_treino = X_treino*beta;
    
    [sorted_x, sorted_order] = sort(x_treino);
    sorted_y = y_chapeu_treino(sorted_order);
    
    plot(sorted_x,sorted_y,'b-','linewidth',2);

    R2AJ_treino = calc_r2aj(y_treino,y_chapeu_treino, n_treino, grau);

    fprintf('Polinomio de Grau %d\n', grau);
    fprintf('---> R2AJ_treino = %f\n', R2AJ_treino);

    %% Teste na base de teste
    X_teste = [vet_um_teste x_teste];

    y_chapeu_teste = X_teste*beta;
    
    R2AJ_teste = calc_r2aj(y_teste,y_chapeu_teste, n_teste, grau);

    fprintf('---> R2AJ_teste = %f\n\n', R2AJ_teste);

%% Polinômio de grau 2
    grau = 2;

    %% Treinamento
    X_treino = [vet_um_treino x_treino x_treino.^2];
    beta = calc_beta(X_treino,y_treino, lambda);

    %% Teste da base de treino
    y_chapeu_treino = X_treino*beta;
    
    [sorted_x, sorted_order] = sort(x_treino);
    sorted_y = y_chapeu_treino(sorted_order);
    
    plot(sorted_x,sorted_y,'g-','linewidth',2);

    R2AJ_treino = calc_r2aj(y_treino,y_chapeu_treino, n_treino, grau);

    fprintf('Polinomio de Grau %d\n', grau);
    fprintf('---> R2AJ_treino = %f\n', R2AJ_treino);
    
    %% Teste na base de teste
    X_teste = [vet_um_teste x_teste x_teste.^2];

    y_chapeu_teste = X_teste*beta;
    
    R2AJ_teste = calc_r2aj(y_teste,y_chapeu_teste, n_teste, grau);

    fprintf('---> R2AJ_teste = %f\n\n', R2AJ_teste);
%% Polinômio de grau 3
    grau = 3;

    %% Treinamento
    X_treino = [vet_um_treino x_treino x_treino.^2 x_treino.^3];
    beta = calc_beta(X_treino,y_treino, lambda);

    %% Teste da base de treino
    y_chapeu_treino = X_treino*beta;
    
    [sorted_x, sorted_order] = sort(x_treino);
    sorted_y = y_chapeu_treino(sorted_order);
    
    plot(sorted_x,sorted_y,'y-','linewidth',2);

    R2AJ_treino = calc_r2aj(y_treino,y_chapeu_treino, n_treino, grau);

    fprintf('Polinomio de Grau %d\n', grau);
    fprintf('---> R2AJ_treino = %f\n', R2AJ_treino);
    
    %% Teste na base de teste
    X_teste = [vet_um_teste x_teste x_teste.^2 x_teste.^3];

    y_chapeu_teste = X_teste*beta;
    
    R2AJ_teste = calc_r2aj(y_teste,y_chapeu_teste, n_teste, grau);

    fprintf('---> R2AJ_teste = %f\n\n', R2AJ_teste);
    
%% Polinômio de grau 4
    grau = 4;

    %% Treinamento
    X_treino = [vet_um_treino x_treino x_treino.^2 x_treino.^3 x_treino.^4];
    beta = calc_beta(X_treino,y_treino, lambda);

    %% Teste da base de treino
    y_chapeu_treino = X_treino*beta;
    
    [sorted_x, sorted_order] = sort(x_treino);
    sorted_y = y_chapeu_treino(sorted_order);
    
    plot(sorted_x,sorted_y,'k-','linewidth',2);

    R2AJ_treino = calc_r2aj(y_treino,y_chapeu_treino, n_treino, grau);

    fprintf('Polinomio de Grau %d\n', grau);
    fprintf('---> R2AJ_treino = %f\n', R2AJ_treino);
    
    
    %% Teste na base de teste
    X_teste = [vet_um_teste x_teste x_teste.^2 x_teste.^3 x_teste.^4];

    y_chapeu_teste = X_teste*beta;
    
    R2AJ_teste = calc_r2aj(y_teste,y_chapeu_teste, n_teste, grau);

    fprintf('---> R2AJ_teste = %f\n\n', R2AJ_teste);
    
%% Polinômio de grau 5
    grau = 5;

    %% Treinamento
    X_treino = [vet_um_treino x_treino x_treino.^2 x_treino.^3 x_treino.^4 x_treino.^5];
    beta = calc_beta(X_treino,y_treino, lambda);

    %% Teste da base de treino
    y_chapeu_treino = X_treino*beta;
    
    [sorted_x, sorted_order] = sort(x_treino);
    sorted_y = y_chapeu_treino(sorted_order);
    
    plot(sorted_x,sorted_y,'r-','linewidth',1);

    R2AJ_treino = calc_r2aj(y_treino,y_chapeu_treino, n_treino, grau);

    fprintf('Polinomio de Grau %d\n', grau);
    fprintf('---> R2AJ_treino = %f\n', R2AJ_treino);
    
    %% Teste na base de teste
    X_teste = [vet_um_teste x_teste x_teste.^2 x_teste.^3 x_teste.^4 x_teste.^5];

    y_chapeu_teste = X_teste*beta;
    
    R2AJ_teste = calc_r2aj(y_teste,y_chapeu_teste, n_teste, grau);

    fprintf('---> R2AJ_teste = %f\n\n', R2AJ_teste);
    
%% Legenda do plot
legend('Dados de Treino','Dados de Teste', 'Grau 1', 'Grau 2', 'Grau 3', 'Grau 4', 'Grau 5','Location','northwest');