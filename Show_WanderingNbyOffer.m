function KPShowWanderingNbyOffer(R, varargin)

maxN = ceil(nanmax(R.W1(:))/10)*10;
maxO = max(R.offer);
process_varargin(varargin);
H = nan(maxO,maxO,maxN);

nAccepted = nan(maxO,1);
for iO = 1:maxO
    isOffer = R.offer == iO;
    nAccepted(iO) = sum(isOffer & R.isStay);
    for iTS = 1:maxO
        H(iO,iTS,:) = histcounts(R.W1(isOffer,iTS), 0.5:1:(maxN+0.5));
        H(iO,iTS,:) = H(iO,iTS,:) ./nansum(H(iO,iTS,:));
    end
end
        
clf; colormap copper
offers2show = [5 10 15 20 25 30];
tiledlayout(2,3);
for iPlot = 1:length(offers2show)
    nexttile
    imagescWnan(squeeze(H(offers2show(iPlot),:,:))');
    text(1, maxN-5, sprintf('# trials entered = %d', nAccepted(offers2show(iPlot))), 'color', 'red', 'FontSize', 18);
    axis xy
    caxis([0 0.05]);
    ylim([0 maxN]+0.5);  % need the +0.5 because of imagesc
    title(sprintf('offer = %d',offers2show(iPlot)));
    FigureLayout
    xlabel('Time spent (s)');
    ylabel('W_N');
    if iPlot < 4, xlabel(''); xticklabels(''); end
    if (iPlot ~= 1) && (iPlot ~= 4), ylabel(''); yticklabels(''); end
        
        
end

cb = colorbar;
cb.Layout.Tile = 'east';
cb.Limits = [0 0.05];
ylabel(cb, 'Proportion');
cb.Ticks = [0 0.05];

fH = gcf; fH.WindowState = 'maximized';
