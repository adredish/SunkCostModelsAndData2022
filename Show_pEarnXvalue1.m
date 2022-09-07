function Show_pEarnXvalue1(PEV, varargin)

maxTSQ = max(PEV.TSQ);
colors=BuildColorMap(15);

hold on
[V, TSQ] = ndgrid(PEV.values, 1:maxTSQ);
scatter(V(:), PEV.pEarnV(:), 10, TSQ(:), 'filled')
colormap(colors);
FigureLayout
xlim([-20 20]); ylim([0 1]);
line([0 0], ylim, 'color', 'k', 'LineWidth', 2);
xlabel('value');
ylabel('p(Earn)');
