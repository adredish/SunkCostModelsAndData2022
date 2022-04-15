function FigureLayout(varargin)

layout = [0.5 0.5];

mainFontsize = 40;
varargin = process_varargin(varargin);
legendFontsize = (30/40) * mainFontsize;
process_varargin(varargin);

set(gca, 'fontname', 'Arial', 'FontSize', mainFontsize);

L = get(gca, 'legend');
if ~isempty(L)
    set(L, 'fontname', 'Arial', 'FontSize', legendFontsize, 'box', 'off');
    set(gcf, 'units', 'normalized', 'position', [0 0, layout]);
else
    set(gcf, 'units', 'normalized', 'position', [0 0, layout]);
end

