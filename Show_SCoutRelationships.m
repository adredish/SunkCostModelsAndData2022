function Show_SCoutRelationships(SCout)

close all hidden
sq = @squeeze;

% sunkcost
ShowOneFigure('sunkCost', 1);
ShowOneFigure('attritionBias', 1);
ShowOneFigure('baseSlope', 2);

    function ShowOneFigure(d, nSig)
        figure; colormap(jet)
        scatter(sq(5-SCout.N(:)), sq(SCout.W(:)), 75, sq(SCout.(d)(:)), 's', 'filled')
        axis([-0.25 5.25 -0.5 21]);
        xticks(sort(SCout.sigmaN)); xticklabels({5 3 2 0});
        yticks(sort(SCout.sigmaW)); set(gca, 'yscale', 'log');
        
        cx = caxis; cx = round(cx*10^nSig)/10^nSig; caxis(cx);
        C = colorbar; set(C, 'ytick', caxis); 
        xlabel('S_N');
        ylabel('S_W');
        FigureLayout('layout', [0.5 0.5]); set(gca, 'FontSize', 8*3);
        axis square
        title(d);
    end
end