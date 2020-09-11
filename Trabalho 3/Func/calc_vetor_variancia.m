function [vetor_var_base] = calc_vetor_variancia(base)
    [linha, coluna] = size(base);
    vetor_media_base = zeros(1, coluna);
    % Calculo o vetor de medias
    for j = 1:coluna
        for  i = 1:linha
            vetor_media_base(j) = vetor_media_base(j) + base(i,j);
        end
        vetor_media_base(j) = vetor_media_base(j)/linha;
    end
    
    % Aplico a formula da variancia
        % var = Somatorio( (Xi - X_medio)^2 ) / n - 1
        
    vetor_var_base = zeros(1, coluna);
    for j = 1:coluna
        soma = 0;
        for  i = 1:linha
            soma = soma + (base(i,j) - vetor_media_base(j))^2;
        end
        vetor_var_base(j) = soma/(linha-1);
    end
    
end