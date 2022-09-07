function Science_waitzoneSunkCosts(dataset, fN)
%% wait zone sunk cost
    d=dataset.waitZoneSunkCosts.(fN);
    
    %scatters
    sunkcosts2show = [0:5 10 15];
    
    colors=BuildColorMap(15);

    %%
    figure             
   plot(d.timeLeft(d.sunkCost==0), ...
            d.earnProb(d.sunkCost==0), ...
            'o','color','k', 'MarkerFaceColor', 'k');
        L{1} = '0s invested';

    for iSunk= 2:length(sunkcosts2show) % unique(d.sunkCost)'
        hold on
        thisSunkCost = d.sunkCost==sunkcosts2show(iSunk);
        plot(jitter(d.timeLeft(thisSunkCost), 'multiplier', 0.0025), ...
            d.earnProb(thisSunkCost), ...
            'o','color',colors(sunkcosts2show(iSunk),:), 'MarkerFaceColor', colors(sunkcosts2show(iSunk),:));
        L{iSunk} = sprintf('%d{}s invested', sunkcosts2show(iSunk));
    end
    
    title(fN)
    
    xlabel('Time remaining (s)');
    ylabel('p(Earn) in Wait Zone');
    yticks([0 1]);
    ylim([0 1]);
    xlim([0 30]);
    title('');
    legend(L, 'Location', 'eastoutside');
    
    FigureLayout('layout', [0.5 0.5]);

end