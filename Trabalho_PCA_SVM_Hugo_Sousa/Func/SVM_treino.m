function [alpha, vet_sup,b] = SVM_treino(rotulos_treino_al, K, C)
    [quant_amostras_treino, ~] = size(rotulos_treino_al);
    
    %% Formulação da programação quadrática
    H = diag(rotulos_treino_al)*K*diag(rotulos_treino_al);
    H = (H + H.')/2; % Forçar simetria exata
    f = -ones(quant_amostras_treino,1);
    A = -eye(quant_amostras_treino);
    b = zeros(quant_amostras_treino,1);
    Aeq = rotulos_treino_al.';
    beq = 0;
    
    % Parte do C
    lb = zeros(quant_amostras_treino,1);        % Minimum values for SV (Lagrange Multipliers)
    ub = C*ones(quant_amostras_treino,1);       % Maximum values for SV (Lagrande Multipliers)
    x0 = [];                % Dosen't indicate a initial value for alphas
    opt = optimoptions(@quadprog,'Algorithm', ...
                           'interior-point-convex','Display','off');

    %% Chamada da função de otimização
    alpha = quadprog(H,f,A,b,Aeq,beq,lb,ub,x0,opt);

    %% Achar vetores suporte
    vet_sup = find(alpha > 1e-6);

    %% Cálculo da constante b
    b = 0;
    for jj = 1:length(vet_sup)
        b = b + 1/rotulos_treino_al(vet_sup(jj));
        for ii = 1:length(vet_sup)
              b = b - rotulos_treino_al(vet_sup(ii))*alpha(vet_sup(ii))*K(vet_sup(ii),vet_sup(jj));
        end
    end
    b = b/length(vet_sup);
end

