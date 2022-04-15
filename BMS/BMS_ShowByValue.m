function BMS_ShowByValue(d)

invested2plot = 1:15;
c = pink(max(invested2plot)*2);

x = -30:30;
%%
figure;
h0 = plot(x,d.baselineQuitProb, 'ko', 'MarkerFaceColor', 'k');
hold on
for iV = 1:length(invested2plot)
    y = d.investedQuits.(sprintf('invested%d',invested2plot(iV)));
    h(iV) = plot(x,y,'o', 'color', c(iV,:), 'MarkerSize', 5);
%     L{iV} = num2str(invested2plot(iV));
end
% legend(cat(2, h0, h), cat(2, {'baseline'},L));
FigureLayout
xlabel('value');
ylabel('p(Earn)');
xlim([-30 30]);
line([0 0], ylim, 'color', 'k');

%%
figure;
hold on
invested2plot = 1:15; 
for iV = 1:length(invested2plot)
    y = d.investedQuits.(sprintf('invested%d',invested2plot(iV)));
    h(iV) = plot(x,y - d.baselineQuitProb,'o', 'color', c(iV,:), 'MarkerSize', 5);
    L{iV} = sprintf('%d{}s invested', invested2plot(iV));
end
line([0 0], ylim, 'color', 'k');
line(xlim, [0 0], 'color', 'k');
legend(h, L, 'location', 'eastoutside');
FigureLayout
xlabel('value');
ylabel('change in p(Earn)');
xlim([-30 30]);
