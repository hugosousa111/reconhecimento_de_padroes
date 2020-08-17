function [candidatos_limiar,posicao_candidato_limiar, cont_candidatos] = escolha_candidato_limiar(base_ordenada, atributo)

    %% guardo os candidatos a limiar
    [l, c] = size(base_ordenada);
    candidatos_limiar = zeros(l,1); %vetor onde ira ficar os valores de limiar
    posicao_candidato_limiar = zeros(l,1); %posicao daquele limiar 
    cont_candidatos = 1;

    for i = 1:l-1
        if base_ordenada(i,1) ~= base_ordenada(i+1, 1) 
            % se muda a classe, é porque aquele é um limiar
            candidatos_limiar(cont_candidatos) = (base_ordenada(i,atributo)+base_ordenada(i+1, atributo))/2;
            % guardo a média dele
            posicao_candidato_limiar(cont_candidatos) = i;
            cont_candidatos = cont_candidatos+1;
        end
    end
end