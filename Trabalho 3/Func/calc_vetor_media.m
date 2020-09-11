function [vetor_media_base] = calc_vetor_media(base)
    [linha, coluna] = size(base);
    vetor_media_base = zeros(1, coluna);
    
    % Soma e divide por n
    
    for j = 1:coluna
        for  i = 1:linha
            vetor_media_base(j) = vetor_media_base(j) + base(i,j);
        end
        vetor_media_base(j) = vetor_media_base(j)/linha;
    end
end