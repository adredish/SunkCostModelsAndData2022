function h=Show_pEarn(pEarn, R)
maxD = max(R.offer);

hold on;
c = BuildColorMap(maxD,5);

TSQs = [1:5 10:5:(maxD-1)];
% calculate slopes
for iTSQ = 1:length(TSQs)
    h(iTSQ) = plot(1:maxD,pEarn(TSQs(iTSQ),:), 'o');
    set(h(iTSQ), 'color', c(TSQs(iTSQ),:));
    if TSQs(iTSQ)==1, set(h(iTSQ), 'MarkerFaceColor', c(1,:)); end
end
legend off

xlabel('Time remaining (s)');
ylabel('p(Earn)');
yticks([0 1]);
ylim([0 1]);
xlim([0 30]);
legend(arrayfun(@(x) sprintf('%.0fs invested', x), TSQs, 'UniformOutput', false), ...
    'Location', 'eastoutside');

FigureLayout('layout', [0.5 0.5]);

