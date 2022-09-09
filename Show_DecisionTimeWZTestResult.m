function Show_DecisionTimeWZTestResult(SCout)

[nB, nD, nT] = size(SCout.sc);
colors = BuildColorMap(15,5);

figure;
title(SCout.T);
xlabel('Time Spent (s)'); 
ylabel('SunkCost Sensitivity: D(slope)');
hold on
h = zeros(nD,1);
for iD = 1:size(SCout.sc,2)        
    if size(SCout.sc,1) == 1
        h(iD) = plot(1:nT, squeeze(SCout.sc(1,iD,:)), '.-', 'color', colors(iD,:));        
    elseif size(SCout.sc,1) > 1
        h(iD) = plot(1:nT, squeeze(nanmean(SCout.sc(:,iD,:))), '.-', 'color', colors(iD,:));
        shadederrorbar(1:nT, squeeze(nanmean(SCout.sc(:,iD,:))), ...
            nanstderr(squeeze(SCout.sc(:,iD,:))), 'color', colors(iD,:));
    end
end
legend(h,arrayfun(@(x)sprintf('DT = %d{}s',x),SCout.decisionTimeWZ,'UniformOutput',false), 'location','eastoutside');
axis([0 30 -0.4 0.4]);
FigureLayout
set(gcf,'Units', 'normalized','Position', [0 0 0.5 0.5]);

figure
hold on
X = repmat(SCout.decisionTimeWZ,[nB 1]); Y = SCout.scSum;
plot(X(:), Y(:), 'o', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'm'); 
[p1,gof1] = fit(X(:), Y(:), 'poly1');  plot(p1, 'g');
[p2,gof2] = fit(X(:), Y(:), 'poly2');  plot(p2, 'b');

fprintf('Linear: Adjusted R^2 = %.4f\n', gof1.adjrsquare);
fprintf('Quadratic: Adjusted R^2 = %.4f\n', gof2.adjrsquare);

legend('data','linear fit','quadratic fit');
xlabel('Decision Time (in the WZ) [s]');
ylabel('sunk cost sensitivity');
title(SCout.T);
FigureLayout;

