function [h_T_limiar] = h_medio(cont_candidatos, posicao_candidato_limiar, h_limiar)
    
    h_T_limiar = zeros(cont_candidatos-1, 1);
    for i = 1: (cont_candidatos-1)
        h_T_limiar(i) = (posicao_candidato_limiar(i)/117)*h_limiar(i,1) + ((117 - posicao_candidato_limiar(i))/117)*h_limiar(i,2); 
    end
    
end