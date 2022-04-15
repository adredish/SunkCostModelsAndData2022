function Show_pEarnXvalue(PEV)

figure; 
clf;
[V, TSQ] = ndgrid(PEV.values, 1:30);
c = pink(30);
colormap(c);
scatter(V(:), PEV.pEarnV(:), 10, TSQ(:), 'filled')
hold on;
xlim([-20 20]);
ylim([0.5 1]);
line([0 0], ylim, 'color', 'k', 'LineWidth', 2);
xlabel('value');
ylabel('p(Earn)');
ylim([0.5 1]);
FigureLayout

figure; hold on
x = -30:30;
h = []; L = {};
y0 = PEV.pEarnV(:,1);
for iV = 2:15
    y = PEV.pEarnV(:,iV);
    h(end+1) = plot(x,y-y0, 'o', 'color', c(iV,:), 'MarkerSize', 5);
    L{end+1} = sprintf('%d s invested', iV);
end
line([0 0], ylim, 'color', 'k');
line(xlim, [0 0], 'color', 'k');
legend(h, L, 'location', 'eastoutside');
FigureLayout
xlabel('value');
ylabel('change in p(Earn)');
xlim([-30 30]);

