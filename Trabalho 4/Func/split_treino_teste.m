function [atributos_treino,rotulos_treino, atributos_teste, rotulos_teste] = split_treino_teste(base, porcentagem_treino)
    
    %% Dividindo a Base
    [quant_amostras, quant_colunas] = size(base);
    quant_amostras_treino = floor(quant_amostras*porcentagem_treino/100);
    
    % Parte separada para teste
    base_teste = base(quant_amostras_treino+1:quant_amostras, :);
    % Parte separada para treino
    base_treino = base(1:quant_amostras_treino, :);

    
    %% Separando em atributos e rotulos
    atributos_treino = base_treino(:, 1:quant_colunas-1);
    rotulos_treino = base_treino(:, quant_colunas);
    
    atributos_teste = base_teste(:, 1:quant_colunas-1);
    rotulos_teste = base_teste(:, quant_colunas);
end

