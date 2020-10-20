function [beta] = calc_beta(X,y, lambda)
    
    [~, c] = size(X);
    I = eye(c);
    
    beta = inv(X'*X + (lambda * I))*X'*y;
end

