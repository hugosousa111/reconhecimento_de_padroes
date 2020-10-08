function [atributos_treino_pca,atributos_teste_pca] = PCA(atributos_treino,atributos_teste, rth)

    [V2, u] = calc_matriz_projecao_PCA(atributos_treino, rth);
    
    atributos_treino_sub = atributos_treino - u;
    atributos_teste_sub = atributos_teste - u;
    
    %% Projeção dos dados
    atributos_treino_pca = V2.'*atributos_treino_sub.';  % tem matriz de correlacao = I (corr(atributos_treino_pca.'))
    %atributos_treino_pca = atributos_treino_pca.';
    
    atributos_teste_pca = V2.'*atributos_teste_sub.';
    %atributos_teste_pca = atributos_teste_pca.';
end

