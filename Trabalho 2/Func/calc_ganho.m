function [max_atributo] = calc_ganho(n_atributos, h_base, h_atributo_media)
    
    info = zeros(n_atributos, 1);
    for atributo = 2: n_atributos+1
        info(atributo-1) = h_base - h_atributo_media(atributo-1);
    end
    [valor, max_atributo] = max(info);
    
end