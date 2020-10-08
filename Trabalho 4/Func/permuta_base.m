function [base_permutada] = permuta_base(base)
    %% Embaralhando as linhas da base
    [quant_amostras, quant_colunas] = size(base);

    vetor_posicoes_rand = randperm(quant_amostras);
    base_permutada = zeros(quant_amostras,quant_colunas);

    for cont = 1:quant_amostras
       base_permutada(cont, :) = base(vetor_posicoes_rand(cont), :);
    end
end

