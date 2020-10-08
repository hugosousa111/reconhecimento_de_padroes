function [rotulos_al] = transforma_rotulos(rotulos, classe_1)
    [li, co] = size(rotulos);
    rotulos_al = zeros(li, co);
    
    for l = 1:li
        for c = 1:co
            if rotulos(l,c) == classe_1
                % Minha classe é a 1
                rotulos_al(l,c) = 1;
            else 
                % Resto é classe -1
                rotulos_al(l,c) = -1;
            end
        end
    end
end

