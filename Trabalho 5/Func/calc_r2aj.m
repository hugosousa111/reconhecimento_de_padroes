function [R2AJ] = calc_r2aj(y,y_chapeu, n, grau)
    k = grau + 1;
    R2AJ = 1 - ((sum((y-y_chapeu).^2))/(n-k))/((sum((y-mean(y)).^2))/(n-1));
end

