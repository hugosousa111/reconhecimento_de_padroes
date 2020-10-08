function [matriz_conf] = calc_matriz_de_confusao(rotulos_reais, rotulos_previstos)
    [TP, TN, FP, FN] = calc_T_F_P_N(rotulos_reais,rotulos_previstos);
    
    %acuracia = (TP+TN)/(TP+TN+FP+FN);
    %disp("Acuracia baseado no TFPN = ")
    %disp(acuracia)
    
    matriz_conf = zeros(2,2);
    
    matriz_conf(1,1) = TP;
    matriz_conf(1,2) = FP;
    matriz_conf(2,1) = FN;
    matriz_conf(2,2) = TN;
    
end

