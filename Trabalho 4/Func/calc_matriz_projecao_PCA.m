function [V2, u] = calc_matriz_projecao_PCA(atributos_treino, rth)
    [~, quant_atributos] = size(atributos_treino);
    
    %% Cálculo da média de cada atributo da base de treino
    u = calc_vetor_media(atributos_treino);
    
    %% Subtraindo a média de cada atributo da base de dados
    atributos_treino_sub = atributos_treino - u;
    
    u2 = calc_vetor_media(atributos_treino_sub);
    %% Cálculo da covariância da base
    Rx = calc_matriz_covariancia(atributos_treino_sub,u2);
    
    %% Autovalores e Autovetores 
    [V,D] = eig(Rx);
    
    %% Escolhendo o número de componentes
    lambda = diag(D);
    lambda = lambda(end:-1:1);
    
    %Visualização dos autovalores
    %close all;
    %figure,plot(lambda)
    
    %Autovalores acumulados
    energ = cumsum(lambda);
    %figure,plot(energ)
    
    inde = find(energ < energ(end)*rth);
    if length(inde) == 0
        inde = 0;
    end
    V2 = V(:,quant_atributos-inde(end)+1:quant_atributos);
    
end

