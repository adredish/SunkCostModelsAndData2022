function FigureLayout(varargin)

scaling = 4;
layout = [0.5 0.5];
varargin = process_varargin(varargin);

mainFontSize = 6 * scaling;
varargin = process_varargin(varargin);

labelFontSize = mainFontSize * 10/8;
titleFontSize = mainFontSize * 12/8;
legendFontSize = mainFontSize;
process_varargin(varargin);

set(gcf, 'units', 'normalized', 'position', [0 0, layout]);

a = findobj(gcf, 'Type', 'axes');
for iA = 1:length(a)
    axes(a(iA));
    set(gca, 'FontName', 'Arial', 'FontSize', mainFontSize);
    
    set(get(gca, 'xlabel'), 'FontName', 'Arial', 'FontSize', labelFontSize);
    set(get(gca, 'ylabel'), 'FontName', 'Arial', 'FontSize', labelFontSize);
    set(get(gca, 'title'),  'FontName', 'Arial', 'FontSize', titleFontSize);
    t = findobj(gca, 'Type', 'text');
    if ~isempty(t)
        set(t, 'FontName', 'Arial', 'FontSize', mainFontSize);
    end
    
    L = get(gca, 'legend');
    if ~isempty(L)
        set(L, 'fontname', 'Arial', 'FontSize', legendFontSize, 'box', 'off');
    end
end



