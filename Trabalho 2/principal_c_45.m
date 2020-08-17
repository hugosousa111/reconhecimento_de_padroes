%% Trabalho 2 - Arvore de Decisão C4.5
% Disciplina de Reconhecimento de Padrões
% Hugo Silveira Sousa 378998

%% Limpar variáveis, limpar console, fechar telas
clear; clc; close all; 

%% funções
addpath('Func/');

%% Carrega a base
base = table2array(readtable('wine.csv'));

%% 
n_classe_1 = sum(base(:,1) == ones(178,1));
n_classe_2 = sum(base(:,1) == (ones(178,1)+ones(178,1)));
n_classe_3 = sum(base(:,1) == (ones(178,1)+ones(178,1)+ones(178,1)));

% Irei trabalhar apenas com a classe 1 e 2

new_base = base(1:(n_classe_1+n_classe_2), :);

%% K-fold
k_fold = 10; % Dividir a base em 10 partes

% para o kfold igual a 10, vou pegar 10% de cada classe para teste, como:
% Classe 1 tem 59 amostras e
% Classe 2 tem 71 amostras

% Irei usar para os testes, em cada iteração do kfold:
% 6 amostras da classe 1
% 7 amostras da classe 2

% e na última iteração do kfold uso para teste:
% 5 amostras da classe 1
% 8 amostras da classe 2

vetor_acuracia = zeros(k_fold, 1);

for iteracao = 1:k_fold
    %% Criando Modelo da minha árvore
        modelo = [];
        save('modelo.mat', 'modelo') 
        % Eu salvo meu modelo, pois foi a maneira que achei para simular
        % uma passagem por referência nas minhas funções, já que no MatLab
        % não tem ponteiros
        pai = 0;
        
        % Eu salvei minha árvore em uma matriz, o que deixou a interpretação 
        % da árvore um pouco complicada, infelizmente não consegui fazer
        % mais simples ou mais compreensivo, mas nos comentários a seguir
        % tento explicar como ler a matriz modelo.
        
        % Modelo é uma matriz de 4 colunas onde eu salvo a minha árvore, 
        % Exemplo de Modelo = 
        %             1.0000   12.8100         0         0
        %             2.0000    1.9800         0    1.0000
        %             1.0000    4.9200         0    2.0000
        %             1.0000         0    2.0000    3.0000
        %             1.0000   27.5000         0    3.0000
        %                  0         0    2.0000    4.0000
        %                  0         0    1.0000    4.0000
        %             1.0000         0    2.0000    2.0000
        %             1.0000         0    2.0000    1.0000
        % Coluna 1 = representa o atributo daquele nó (o valor não é 
        % exatamente o atributo, mas representa ele) 
        % Coluna 2 = Limiar escolhido daquele atributo
        % Coluna 3 = Classe se for nó final (0 se não for)
        % Coluna 4 = Nó Pai (0 se for a raiz)
        %
        % A leitura do Modelo é feita da seguinte forma, pego uma linha da matriz,
        % a próxima linha representa o nó onde as amostras são maiores que
        % aquele limiar da primeira linha que eu peguei
        % Sempre o próximo é nó onde as amostras são maiores que o limiar
        % 
        % Se a linha começar com [ 1   0  ... ] é porque aquele é um nó final
        % e sua classe é o valor que está na coluna 3 (vai ser 1 ou 2)
        % E a próxima linha é o lado onde os valores são menores que o limiar
        % 
        % Se a linha começar com [ 0   0 ... ] é porque ao chegar naquele
        % nó já foram usados todos os atributos, então ele virou um nó
        % final, sua classe é o valor que está na coluna 3, e essa classe
        % foi escolhida dado a maioria das amostras de treino que chegaram
        % naquele nó, e da mesma maneira, a próxima linha é o lado onde os 
        % valores são menores que o limiar
        %
        % Exemplo de Modelo = 
        % Linha 1             1.0000   12.8100         0         0
        % Linha 2             2.0000    1.9800         0    1.0000
        % Linha 3             1.0000    4.9200         0    2.0000
        % Linha 4             1.0000         0    2.0000    3.0000
        % Linha 5             1.0000   27.5000         0    3.0000
        % Linha 6                  0         0    2.0000    4.0000
        % Linha 7                  0         0    1.0000    4.0000
        % Linha 8             1.0000         0    2.0000    2.0000
        % Linha 9             1.0000         0    2.0000    1.0000
        %
        % Nesse exemplo, a Linha 1 é a raiz, o atributo escolhido foi o
        % atributo 1, com limiar 12.8100.
        %
        % A linha 2, são as amostras que com valores maiores que 12.8100
        % para o atributo 1
        % Na linha 2, o atributo escolhido foi o 3, com limiar 1.9800
        % (no meu código, esses valores de atributo vão se alterando, por 
        % isso tem 2 na matriz, eu recupero o valor do atributo correto durante o teste) 
        %
        % Na linha 3, são as amostras que sobraram, com valores maiores que
        % 1.9800, para o atributo 3
        % Na linha 3, o atributo escolhido foi o 2, com limiar 4.9200
        %
        % Na linha 4, temos [1  0  2 ...], logo, as amostras que chegaram
        % naquele nó, são todas da classe 2
        % 
        % Na linha 5, temos as amostras menores que 4.9200 para o atributo 2
        % Na linha 5, o atributo escolhido foi 4, com limiar 27.5000
        % 
        % Na linha 6, são as amostras com valores maiores que 27.5000 para 
        % o atributo 4, é um nó final pois não temos mais atributos para escolher
        % um limiar, a classe das amostras é a classe 2
        % 
        % Na linha 7, são as amostras com valores menores que 27.5000 para 
        % o atributo 4, também é um nó final pois não temos mais atributos 
        % para escolher um limiar, a classe das amostras é a classe 1
        %
        % Na linha 8, são as amostras menores que o limiar da linha 2, que
        % é um nó final
        % 
        % Na linha 9, são as amostras menores que o limiar da linha 1, que
        % é um nó final
        %
        % Coluna Pai
        % A última coluna representa os pais/filhos daquele nó, da seguinte
        % maneira: se na coluna pai (coluna 4) de uma linha tem o valor 3, 
        % o nó pai dele é primeira linha acima que está com o valor 2 no pai
        % 
        % E se uma linha X na coluna pai tem o valor 2, a primeira linha com
        % valor 3 na coluna pai que vem depois da linha X é o filho daquele nó
        % com valores maiores que o limiar da linha X, e o segunda linha com
        % valor 3 na coluna pai que vem depois da linha X é o filho daquele nó
        % com valores menoress que o limiar da linha X
        
        
    %% dividindo a base
    [base_treino, base_teste] = dividir_base_k_fold(iteracao,new_base, n_classe_1, n_classe_2);
    n_atributos = 4;
    % Os atributos escolhidos foram os 4 primeiros
    base_treino = base_treino(:, 1: n_atributos+1);
    base_teste = base_teste(:, 1: n_atributos+1);

    %% Treino 
    % No treino eu escolho os limiares e crio um modelo de árvore
    posicao_candidato_limiar = 1;
    treino(base_treino, posicao_candidato_limiar,pai)
    
    %% Exibindo o Modelo da Árvore
    disp('Iteração: ')
    disp(iteracao)
    
    load('modelo.mat') 
    disp("Modelo:")
    disp(modelo)
    
    %% Teste
    [vetor_classes] = teste(base_teste(:, 2:5), modelo);
    
    %% Acurácia
    acuracia = sum(vetor_classes == base_teste(:, 1)) / 13;
    vetor_acuracia(iteracao) = acuracia;
    
    disp('Acurácia: ')
    disp(acuracia)
    
    disp('*****************************************')
end

media_acuracia = sum(vetor_acuracia)/10;
disp('Média das Acurácias: ')
disp(media_acuracia)