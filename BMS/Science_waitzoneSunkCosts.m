function Science_waitzoneSunkCosts(dataset, fN)
%% wait zone sunk cost
    d=dataset.waitZoneSunkCosts.(fN);
    
    %scatters
    figure
    sunkcosts2show = [0:5 10 15 20 29];
    
    colors=BuildColorMap(length(sunkcosts2show));

    for iSunk= 1:length(sunkcosts2show) % unique(d.sunkCost)'
        hold on
        thisSunkCost = d.sunkCost==sunkcosts2show(iSunk);
        h = plot(jitter(d.timeLeft(thisSunkCost), 'multiplier', 0.0025), ...
            d.earnProb(thisSunkCost), ...
            'o','color',colors(iSunk,:));
        if iSunk==1, set(h, 'MarkerFacecolor', 'k'); end
        L{iSunk} = sprintf('%d{}s invested', sunkcosts2show(iSunk));
    end
    
    title(fN)
    
    xlabel('Time remaining (s)');
    ylabel('p(Earn)');
    yticks([0 1]);
    ylim([0 1]);
    xlim([0 30]);
    legend(L, 'Location', 'eastoutside');
    
    FigureLayout('layout', [0.5 0.5]);

end