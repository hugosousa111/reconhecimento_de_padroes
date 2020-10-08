function [TP, TN, FP, FN] = calc_T_F_P_N(rotulos_reais,rotulos_previstos)
    TP = sum(rotulos_previstos == 1 & rotulos_reais == 1);
    TN = sum(rotulos_previstos == -1 & rotulos_reais == -1);
    FP = sum(rotulos_previstos == 1 & rotulos_reais == -1);
    FN = sum(rotulos_previstos == -1 & rotulos_reais == 1);
end

