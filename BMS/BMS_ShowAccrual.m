%% Delay to accrual figure

R = load('accrualdata');

%% plot data
figure;
uG = unique(R.group); nG = length(uG);
c = [1 0 0 0.1; 
     1 0 1 0.1; 
     0 1 1 0.4; 
     0 0 1 0.25];
clf; hold on;
for iG = 1:nG
    inGroup = R.group==uG(iG);
    plot(0:28, R.SC(inGroup,:), 'color', c(iG,:))
    h(iG) = shadederrorbar(0:28, nanmean(R.SC(inGroup,:)), nanstderr(R.SC(inGroup,:)), 'color', c(iG,1:3));    
end
line(xlim, [0 0], 'color', 'k');
legend(h, uG, 'location', 'eastoutside');
xlabel('time already waited');
ylabel('sunk cost sensitivity');
ylim([-0.1 0.5]); yticks([-0.1 0 0.5]);
FigureLayout

%%
figure;
clf
gscatter(R.latencyToAccrues + 0.1*randn(size(R.latencyToAccrues)), R.peakMagnitude, R.group,c)
hold on
X = R.latencyToAccrues; Y = R.peakMagnitude; k = ~isnan(X) & ~isnan(Y);  X = X(k); Y = Y(k);
[p1,gof1] = fit(X(:), Y(:), 'poly1');  plot(p1, 'k:'); 
fprintf('Linear: Adjusted R^2 = %.4f\n', gof1.adjrsquare);
[p2,gof2] = fit(X(:), Y(:), 'poly2');  plot(p2, 'k-'); 
fprintf('Quadratic: Adjusted R^2 = %.4f\n', gof2.adjrsquare);
legend(cat(1, string(uG), 'linear fit', 'quadratic fit'));
xlabel('Decision Time (in the WZ) [s]');
ylabel('sunk cost sensitivity');

FigureLayout

