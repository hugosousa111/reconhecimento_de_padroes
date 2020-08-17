function [vetor_classes] = teste(base_teste, modelo)
    [l,c] = size(base_teste);
    vetor_classes = zeros(l,1);
    for i=1:l
        amostra_atual = base_teste(i,:);
        % Para o teste, eu pego uma amostra por vez, e coloco nessa função
        % procura_classe, que é recursiva e percorre o modelo, procurando a
        % classe daquela amostra
        classe_previsao = procura_classe(amostra_atual, modelo);
        
        vetor_classes(i) = classe_previsao;
    end
end