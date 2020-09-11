% Trabalho 3 
% Classificadores Bayesianos, Critério MAP e LDA
% Disciplina de Reconhecimento de Padrões
% Hugo Silveira Sousa 378998

% 2.3) LDA(CDA)

%% Limpar variáveis, limpar console, fechar telas
clear; clc; close all; 

%% funções
addpath('Func/');

%% Carrega a base
load data_dermato_01.mat;
[quant_base, colunas_base] = size(derma);

%% Parâmentros do código

% Z_score antes da transformação do LDA? Sim = 1, Não = 0 
% O Trabalho pede com Z_score
z_score_lda = 1;

% Z_score antes da classificação do QDA? Sim = 1, Não = 0
z_score_qda = 1;

% Quantidade de iterações do For principal?
iteracoes = 50;

% Semente aleatória ou fixa? Comente a próxima linha, se quiser aleatória
rng(0); %Sempre a mesma semente do rand, se quiser manter os mesmos resultados

% Quantidade de maiores autovalores que deseja para criar a matriz de projeção W?
% C-1 máximo é 5
quant_maiores_autovalores = 5;

%% Roda varias vezes e tira a média das acurácias
vetor_acuracia = zeros(iteracoes,1);

for iteracao = 1:iteracoes

    %% Embaralhando as linhas da base
    vetor_posicoes_rand = randperm(quant_base);
    derma_permutada = zeros(quant_base,colunas_base);

    for cont = 1:quant_base
       derma_permutada(cont, :) = derma(vetor_posicoes_rand(cont), :);
    end

    %% Lógica para pegar 30% da base para teste, e o resto para treino
    % 001 - 250 Treino (69,83%)
    % 251 - 358 Teste  (30,17%)

    % Parte separada para teste
    base_teste = derma_permutada(251:358, :);
    % Parte separada para treino
    base_treino = derma_permutada(1:250, :);

    %% Z-score
    
    [quant_treino, ~] = size(base_treino);
    [quant_teste, ~] = size(base_teste);

    if z_score_lda == 1 
        for coluna = 1:colunas_base-1
            media_z = mean(base_treino(:, coluna));
            desvio_z = std(base_treino(:, coluna));
            for linha = 1:quant_treino
                base_treino(linha, coluna) = (base_treino(linha, coluna)-media_z)/desvio_z;
            end
            for linha = 1:quant_teste
                base_teste(linha, coluna) = (base_teste(linha, coluna)-media_z)/desvio_z;
            end
        end
    end
    
    %% Classes
    classes = 6;
    classe1 = base_treino(base_treino(:,colunas_base)==1, :);
    classe1_at = classe1(:, 1:colunas_base-1);
    classe2 = base_treino(base_treino(:,colunas_base)==2, :);
    classe2_at = classe2(:, 1:colunas_base-1);
    classe3 = base_treino(base_treino(:,colunas_base)==3, :);
    classe3_at = classe3(:, 1:colunas_base-1);
    classe4 = base_treino(base_treino(:,colunas_base)==4, :);
    classe4_at = classe4(:, 1:colunas_base-1);
    classe5 = base_treino(base_treino(:,colunas_base)==5, :);
    classe5_at = classe5(:, 1:colunas_base-1);
    classe6 = base_treino(base_treino(:,colunas_base)==6, :);
    classe6_at = classe6(:, 1:colunas_base-1);

    %% Número de Instâncias
    [N1, ~] = size(classe1);
    [N2, ~] = size(classe2);
    [N3, ~] = size(classe3);
    [N4, ~] = size(classe4);
    [N5, ~] = size(classe5);
    [N6, ~] = size(classe6);

    %% Vetor média
    u1 = calc_vetor_media(classe1_at);
    u2 = calc_vetor_media(classe2_at);
    u3 = calc_vetor_media(classe3_at);
    u4 = calc_vetor_media(classe4_at);
    u5 = calc_vetor_media(classe5_at);
    u6 = calc_vetor_media(classe6_at);
    u = (u1 + u2 + u3 + u4 + u5 + u6)/6;

    %% Matriz de covariancia
    S1 = calc_matriz_covariancia(classe1_at,u1);
    S2 = calc_matriz_covariancia(classe2_at,u2);
    S3 = calc_matriz_covariancia(classe3_at,u3);
    S4 = calc_matriz_covariancia(classe4_at,u4);
    S5 = calc_matriz_covariancia(classe5_at,u5);
    S6 = calc_matriz_covariancia(classe6_at,u6);

    %% SW 
    Sw = S1 + S2 + S3 + S4 + S5 + S6;

    %% SB
    SB1 = N1*(u1 - u)*(u1 - u).';
    SB2 = N2*(u2 - u)*(u2 - u).';
    SB3 = N3*(u3 - u)*(u3 - u).';
    SB4 = N4*(u4 - u)*(u4 - u).';
    SB5 = N5*(u5 - u)*(u5 - u).';
    SB6 = N6*(u6 - u)*(u6 - u).';

    SB = SB1 + SB2 + SB3 + SB4 + SB5 + SB6;

    %% Autovalores e Autovetores 
    [V,D] = eig(inv(Sw)*SB);

    %% Menores Autovalores
    quant_menores = (colunas_base-1) - quant_maiores_autovalores;
    D_linha = sum(D);
    posicao_menores = zeros(quant_menores,1);
    for i = 1:quant_menores
        [~, posicao_menores(i)] = min(D_linha);
        D_linha(posicao_menores(i)) = Inf; % Elimino os menores autovalores
    end

    %% Matriz de Projeção
    W = V;
    W(:, posicao_menores) = []; % Elimino os menores autovalores

    %% Projeção dos Dados (Dados de treino e teste)
    base_treino_projetada = (W.' * base_treino(:, 1:colunas_base-1).').';
    base_treino_projetada = [base_treino_projetada base_treino(:, colunas_base)]; % Guarda os rotulos

    base_teste_projetada = (W.' * base_teste(:, 1:colunas_base-1).').';
    base_teste_projetada = [base_teste_projetada base_teste(:, colunas_base)]; % Guarda os rotulos

    %% Z-score dos dados projetados
    [~, col_projetado] = size(base_treino_projetada);

    if z_score_qda == 1
        for coluna = 1:col_projetado-1
            media_z = mean(base_treino_projetada(:, coluna));
            desvio_z = std(base_treino_projetada(:, coluna));
            for linha = 1:quant_treino
                base_treino_projetada(linha, coluna) = (base_treino_projetada(linha, coluna)-media_z)/desvio_z;
            end
            for linha = 1:quant_teste
                base_teste_projetada(linha, coluna) = (base_teste_projetada(linha, coluna)-media_z)/desvio_z;
            end
        end
     end
    
    %% Separando por classes

    Y_classe1 = base_treino_projetada(base_treino_projetada(:,col_projetado)==1, :);
    Y1 = Y_classe1(:, 1:col_projetado-1);
    Y_classe2 = base_treino_projetada(base_treino_projetada(:,col_projetado)==2, :);
    Y2 = Y_classe2(:, 1:col_projetado-1);
    Y_classe3 = base_treino_projetada(base_treino_projetada(:,col_projetado)==3, :);
    Y3 = Y_classe3(:, 1:col_projetado-1);
    Y_classe4 = base_treino_projetada(base_treino_projetada(:,col_projetado)==4, :);
    Y4 = Y_classe4(:, 1:col_projetado-1);
    Y_classe5 = base_treino_projetada(base_treino_projetada(:,col_projetado)==5, :);
    Y5 = Y_classe5(:, 1:col_projetado-1);
    Y_classe6 = base_treino_projetada(base_treino_projetada(:,col_projetado)==6, :);
    Y6 = Y_classe6(:, 1:col_projetado-1);

    %% Aplicação do QDA nos dados projetados

        %% Probabilidade a priori de cada classe
        probabilidade_priori = zeros(classes,1);

        probabilidade_priori(1) = N1/quant_treino;
        probabilidade_priori(2) = N2/quant_treino;
        probabilidade_priori(3) = N3/quant_treino;
        probabilidade_priori(4) = N4/quant_treino;
        probabilidade_priori(5) = N5/quant_treino;
        probabilidade_priori(6) = N6/quant_treino;

        %% Vetor média
        vetor_media_classe1 = calc_vetor_media(Y1);
        vetor_media_classe2 = calc_vetor_media(Y2);
        vetor_media_classe3 = calc_vetor_media(Y3);
        vetor_media_classe4 = calc_vetor_media(Y4);
        vetor_media_classe5 = calc_vetor_media(Y5);
        vetor_media_classe6 = calc_vetor_media(Y6);

        %% Matriz de covariancia
        matriz_cov_classe1 = calc_matriz_covariancia(Y1,vetor_media_classe1);
        matriz_cov_classe2 = calc_matriz_covariancia(Y2,vetor_media_classe2);
        matriz_cov_classe3 = calc_matriz_covariancia(Y3,vetor_media_classe3);
        matriz_cov_classe4 = calc_matriz_covariancia(Y4,vetor_media_classe4);
        matriz_cov_classe5 = calc_matriz_covariancia(Y5,vetor_media_classe5);
        matriz_cov_classe6 = calc_matriz_covariancia(Y6,vetor_media_classe6);

        %% Correção dos valores das matrizes de covariancia com o termo de regularização lambda
        % Problema das determinantes iguais a zero e inversão de matrizes singulares
        I = eye(col_projetado-1);
        lambda = 0.01;
        matriz_cov_classe1 = matriz_cov_classe1 + (lambda * I);
        matriz_cov_classe2 = matriz_cov_classe2 + (lambda * I);
        matriz_cov_classe3 = matriz_cov_classe3 + (lambda * I);
        matriz_cov_classe4 = matriz_cov_classe4 + (lambda * I);
        matriz_cov_classe5 = matriz_cov_classe5 + (lambda * I);
        matriz_cov_classe6 = matriz_cov_classe6 + (lambda * I);

        %% QDA
        % Equação: 
        % min i: ln |M_cov i| + (X - Ui)^T . M_cov^-1 . (X - Ui) - 2.ln P(Ci)

        % Teste
        rotulos_previstos_teste = zeros(quant_teste,1);
        for cont = 1:quant_teste
            X_projetado = base_teste_projetada(cont, 1:col_projetado-1).';

            vetor_qda = zeros(6,1);
            vetor_qda(1) = log(det(matriz_cov_classe1)) + (((X_projetado - vetor_media_classe1.').')*inv(matriz_cov_classe1)*(X_projetado - vetor_media_classe1.')) - (2*log(probabilidade_priori(1)));
            vetor_qda(2) = log(det(matriz_cov_classe2)) + (((X_projetado - vetor_media_classe2.').')*inv(matriz_cov_classe2)*(X_projetado - vetor_media_classe2.')) - (2*log(probabilidade_priori(2)));
            vetor_qda(3) = log(det(matriz_cov_classe3)) + (((X_projetado - vetor_media_classe3.').')*inv(matriz_cov_classe3)*(X_projetado - vetor_media_classe3.')) - (2*log(probabilidade_priori(3)));
            vetor_qda(4) = log(det(matriz_cov_classe4)) + (((X_projetado - vetor_media_classe4.').')*inv(matriz_cov_classe4)*(X_projetado - vetor_media_classe4.')) - (2*log(probabilidade_priori(4)));
            vetor_qda(5) = log(det(matriz_cov_classe5)) + (((X_projetado - vetor_media_classe5.').')*inv(matriz_cov_classe5)*(X_projetado - vetor_media_classe5.')) - (2*log(probabilidade_priori(5)));
            vetor_qda(6) = log(det(matriz_cov_classe6)) + (((X_projetado - vetor_media_classe6.').')*inv(matriz_cov_classe6)*(X_projetado - vetor_media_classe6.')) - (2*log(probabilidade_priori(6))); 

            [~, posicao] = min(vetor_qda); % Menor posição é o rótulo estimado

            rotulos_previstos_teste(cont) = posicao;

        end

        %% Compara rótulos previstos com os reais
        somatorio = sum(rotulos_previstos_teste == base_teste(:, colunas_base));

        acuracia = (somatorio/quant_teste) * 100;

        vetor_acuracia(iteracao) = acuracia;
end

disp("CDA - QDA - Média das Taxas de Acurácia em %")
disp(mean(vetor_acuracia))
disp("--------------------------------------")
disp("Desvio padrão das Taxas de Acurácia")
disp(std(vetor_acuracia))
