function [classe_prevista] = procura_classe(amostra_atual, modelo)
    atributo = modelo(1,1);
    limiar = modelo(1,2);
    classe = modelo(1,3);
    pai = modelo(1,4);
    
    if classe ~= 0
        % Caso base, quando na linha daquele modelo, eu tenho uma classe
        % logo aquela amostra chegou em um nó final
        classe_prevista = classe;
    else
        if amostra_atual(atributo) > limiar 
           % Procuro se for maior
           amostra_atual(atributo) = [];
           classe_prevista = procura_classe(amostra_atual, modelo(2:end, :));
        else
            filho = pai+1;
            for cont = 1:size(modelo)
                if modelo(cont,4) == filho
                    % aqui é o primeiro filho que aparece, não quero ele,
                    % pois ele é do caso maior que o limiar
                    break          
                end
            end
            for cont2 = cont+1:size(modelo)
                % agora eu procuro o segundo filho, que é do lado menor que
                % o limiar
                if modelo(cont2,4) == filho
                    amostra_atual(atributo) = [];
                    classe_prevista = procura_classe(amostra_atual, modelo(cont2:end, :));
                    break 
                    % quando eu acho o segundo, eu paro de procurar pois
                    % pode encontrar outros com o mesmo valor de filho, que
                    % não são o que eu quero
                end
            end
        end
    end
end