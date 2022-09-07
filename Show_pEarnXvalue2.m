function Show_pEarnXvalue2(PEV, varargin)

colors=BuildColorMap(15);

hold on
x = PEV.values;
h = []; L = {};
y0 = PEV.pEarnV(:,1);
for iV = 2:15
    y = PEV.pEarnV(:,iV);
    h(end+1) = plot(x,y-y0, 'o', 'color', colors(iV,:), 'MarkerSize', 8, 'MarkerFaceColor', colors(iV,:));
    L{end+1} = sprintf('%d s invested', iV);
end

xlim([-30 30]); ylim([-0.3 1.0]); yticks([-0.2 0 0.5 1]);
line([0 0], ylim, 'color', 'k');
line(xlim, [0 0], 'color', 'k');
legend(h, L, 'location', 'eastoutside');
xlabel('value');
ylabel('change in p(Earn)');

[slopes] = Calculate_PEV_slopes(PEV, varargin{:});
errorbar(slopes.x, slopes.mu, slopes.se, 'color', 'k', 'LineWidth',2);
