function [vetor_media_classe] = calc_vetor_media(classe)
    [linha, coluna] = size(classe);
    vetor_media_classe = zeros(1, coluna);
    for j = 1:coluna
        for  i = 1:linha
            vetor_media_classe(j) = vetor_media_classe(j) + classe(i,j);
        end
        vetor_media_classe(j) = vetor_media_classe(j)/linha;
    end
end