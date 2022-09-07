function Compare_DataToModel(pEarn, PEV, SCout)

v = [38 30];
maxOffer = length(pEarn);

[S,C] = Calculate_SunkCostSlopes(pEarn, maxOffer);

% calculate baseslope and difference to each model
sunkCost = nansum(S(:,1) - C(:,1));

% calculate baseslope and difference to each model
baseSlope = S(1);

% calculate correlation between PEV slopes to each model
slopes = Calculate_PEV_slopes(PEV, 'nBins', SCout.slopes.nBins);
nM = size(SCout.slopes.mu,2);
ksmodelmatrix = nan(nM,1);
for iM = 1:nM
    [~,p] = kstest2(slopes.mu, squeeze(SCout.slopes.mu(1,iM,:)));
    ksmodelmatrix(iM) = p;
end
    
% plot in 3D 
clf; hold on
k = ksmodelmatrix < 0.05;
scatter3(SCout.sunkCost(k), SCout.baseSlope(k), ksmodelmatrix(k), 25, SCout.attritionBias(k), 'o');
scatter3(SCout.sunkCost(~k), SCout.baseSlope(~k), ksmodelmatrix(~k), 25, SCout.attritionBias(~k), 'o', 'filled');
axis square; %axis([-0.2 0.5 -0.2 0.5 0 0.02])
line(xlim, [0 0], [0 0], 'color', 'k')
line([0 0], ylim, [0 0], 'color', 'k')
line([0 0], [0 0], zlim, 'color', 'k')
hold on
xl = xlim; yl = ylim; fill3(xl([1 2 2 1]), yl([1 1 2 2]), repmat(0.05,4,1), [0 0 0], 'FaceAlpha', 0.25);


line(sunkCost*[1 1], baseSlope*[1 1], zlim, 'Color', 'r', 'LineWidth', 2);

xlabel('SunkCost'); ylabel('BaseSlope'); zlabel('PEV comparison (p(kstest))');
view(v);