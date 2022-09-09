function BMS_ShowAccrual

outlierLimit = 15;

%% Delay to accrual figure

R = load('accrualdata');

        c = [1 0 0 0.1;
            1 0 1 0.1;
            0 1 1 0.4;
            0 0 1 0.25];

%% plot data
uG = unique(R.group); nG = length(uG);

%keep only certain cohorts for simplicity
kcohort = (R.cohort=="plos bio") | (R.cohort=="pnas") | (R.cohort=="yannick & brandy") | (R.cohort=="nick, colin, & sophie");
%
ShowSunkCostbyTSQ(kcohort & R.species == "rat");
ShowSunkCostbyTSQ(kcohort & R.species == "mouse");

    function ShowSunkCostbyTSQ(k)
        figure;
        clf; hold on;
        h = []; L = {};
        for iG = 1:nG
            inGroup = R.group==uG(iG) & k;
            if any(inGroup)
                plot(0:28, R.SC(inGroup,:), 'color', c(iG,:))
                h(end+1) = shadederrorbar(0:28, nanmean(R.SC(inGroup,:)), nanstderr(R.SC(inGroup,:)), 'color', c(iG,1:3));
                L{end+1} = string(uG(iG));
            end
        end
        line(xlim, [0 0], 'color', 'k');
        legend(h, L, 'location', 'eastoutside');
        xlabel('time already waited');
        ylabel('sunk cost sensitivity');
        ylim([-0.1 0.5]); yticks([-0.1 0 0.5]);
        FigureLayout
    end

%% figure
% figure;
% histogram(R.latencyToAccrues(kcohort & (R.species=="mouse")), 'Normalization', 'cdf', 'DisplayStyle', 'stairs')
% hold on
% histogram(R.latencyToAccrues(kcohort & (R.species=="rat")), 'Normalization', 'cdf', 'DisplayStyle', 'stairs')
% legend('mouse', 'rat');
% xlabel('Latency to accrual')
% ylabel('cumulative proportion')

LT15 = R.latencyToAccrues < outlierLimit;
fprintf('outlier analysis\n');
fprintf('n(latency2accrue | rat) > %d = %d\n', outlierLimit, nansum(R.latencyToAccrues(kcohort & (R.species=="rat")) > outlierLimit));
fprintf('p(latency2accrue | rat) > %d = %.2f\n', outlierLimit, nanmean(R.latencyToAccrues(kcohort & (R.species=="rat")) > outlierLimit));
fprintf('range(latency2accrue | rat) = [%d to %d], mean=%.1f, std=%.f1, outlierLimit @ %.2f z\n', ...
    nanmin(R.latencyToAccrues(LT15 & kcohort & (R.species=="rat"))), nanmax(R.latencyToAccrues(LT15 & kcohort & (R.species=="rat"))), ...
    nanmean(R.latencyToAccrues(LT15 & kcohort & (R.species=="rat"))), nanstd(R.latencyToAccrues(LT15 & kcohort & (R.species=="rat"))), ...
    (outlierLimit - nanmean(R.latencyToAccrues(kcohort & (R.species=="rat"))))/nanstd(R.latencyToAccrues(kcohort & (R.species=="rat"))));

fprintf('n(latency2accrue | mouse) > %d = %d\n', outlierLimit, nansum(R.latencyToAccrues(kcohort & (R.species=="mouse")) > outlierLimit));
fprintf('p(latency2accrue | mouse) > %d = %.2f\n', outlierLimit, nanmean(R.latencyToAccrues(kcohort & (R.species=="mouse")) > outlierLimit));
fprintf('range(latency2accrue | mouse) = [%d to %d], mean=%.1f, std=%.1f, outlierLimit @ %.2f z\n', ...
    nanmin(R.latencyToAccrues(LT15 & kcohort & (R.species=="mouse"))), nanmax(R.latencyToAccrues(LT15 & kcohort & (R.species=="mouse"))), ...
    nanmean(R.latencyToAccrues(LT15 & kcohort & (R.species=="mouse"))), nanstd(R.latencyToAccrues(LT15 & kcohort & (R.species=="mouse"))), ...
    (outlierLimit - nanmean(R.latencyToAccrues(LT15 & kcohort & (R.species=="mouse"))))/nanstd(R.latencyToAccrues(LT15 & kcohort & (R.species=="mouse"))));

fprintf('n rats: %d\n', sum(kcohort & (R.species=="rat") & R.latencyToAccrues < outlierLimit));
fprintf('n mice: %d\n', sum(kcohort & (R.species=="mouse") & R.latencyToAccrues < outlierLimit));
%%
% uC = unique(R.cohort(k));
% for iC = 1:length(uC)
%     CompareFits(R.cohort==uC(iC), string(uC(iC)));
% end
 
% CompareFits(kcohort);
CompareFits(kcohort & (R.species=="rat") & R.latencyToAccrues < outlierLimit, "Rats w/ no offer zone")
CompareFits(kcohort & (R.species=="mouse") & R.latencyToAccrues < outlierLimit, "Mice")
% 
    function CompareFits(k0, T)
        figure
        X = R.latencyToAccrues; Y = R.peakMagnitude; G = R.group;
        k = k0 & ~isnan(X) & ~isnan(Y);
        X = X(k); Y = Y(k); G = G(k);
        
        gscatter(X + 0.1*randn(size(X)), Y, G, c)
        hold on
        [p1,gof1] = fit(X(:), Y(:), 'poly1');  plot(p1, 'k:');
        fprintf('%s: Linear: Adjusted R^2 = %.4f\n', T, gof1.adjrsquare);
        [p2,gof2] = fit(X(:), Y(:), 'poly2');  plot(p2, 'k-');
        fprintf('%s: Quadratic: Adjusted R^2 = %.4f\n', T, gof2.adjrsquare);
        legend('location', 'eastoutside');
        xlabel('Decision Time (in the WZ) [s]');
        ylabel('sunk cost sensitivity');
        title(T);
        
        FigureLayout
    end

end