function [rotulos_teste_est] = SVM_teste(vet_sup,alpha,b, rotulos_treino_al, quant_amostras_teste, K2)
    %% Teste do SVM baseado no arquivo simple_kernelPol_SVM_2D
    aux = zeros(1,quant_amostras_teste);
    for ii = 1:length(vet_sup)
        aux = aux + rotulos_treino_al(vet_sup(ii))*alpha(vet_sup(ii))*K2(ii,:);
    end
    %% escolhendo as classes (com a função sinal)
    rotulos_teste_est = sign(aux+b).';
end

