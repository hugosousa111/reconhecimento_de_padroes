function plota_com_cores(matriz_cor_base, titulo)
    % código adaptado de 
    % https://stackoverflow.com/questions/3942892/how-do-i-visualize-a-matrix-with-colors-and-values-displayed
    
    % Vale ressaltar que os valores são aproximados para duas casas decimais
    
    imagesc(matriz_cor_base);            % Create a colored plot of the matrix values
    colormap(gca,'jet');  % Change the colormap to gray (so higher values are
                             %   black and lower values are white)

    textStrings = num2str(matriz_cor_base(:), '%0.2f');       % Create strings from the matrix values
    textStrings = strtrim(cellstr(textStrings));  % Remove any space padding
    [x, y] = meshgrid(1:34);  % Create x and y coordinates for the strings
    hStrings = text(x(:), y(:), textStrings(:), ...  % Plot the strings
                    'HorizontalAlignment', 'center');
    midValue = 0.5; %mean(get(gca, 'CLim'));  % Get the middle value of the color range
    textColors = repmat(abs(matriz_cor_base(:)) > midValue, 1, 3);  % Choose white or black for the
                                                   %   text color of the strings so
                                                   %   they can be easily seen over
                                                   %   the background color
    set(hStrings, {'Color'}, num2cell(textColors, 2));  % Change the text colors

    set(gca, 'XTick', 1:34, ...                             % Change the axes tick marks
             'XTickLabel', {'1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30','31','32','33','34'}, ...  %   and tick labels
             'YTick', 1:34, ...
             'YTickLabel', {'1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30','31','32','33','34'}, ...
             'TickLength', [0 0]);
    % Set [min,max] value of C to scale colors
    clrLim = [-1,1];  % or [-1,1] as in your question
    colorbar();
    caxis(clrLim);
    title(titulo)
end