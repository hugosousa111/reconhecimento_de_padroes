function [KX] = kernel_RBF(X1,X2, gamma)
    [~, cX1] = size(X1);
    [~, cX2] = size(X2);
    KX = zeros(cX1, cX2);
    
    for l = 1 : cX1
        for c = 1 : cX2
            KX(l,c) = exp(-gamma * norm(X1(:,l) - X2(:, c)));
        end
    end
    
end