function [baseSlope, sunkNess, W] = PJCGWD0(f0)

%load('PJC-GWD-SunkCost2.mat', 'SC');
load('PJC-GWD/SunkCostByRats', 'SC');
SC.temperature = SC.wzTemperature;
SC.threshold = SC.wzThreshold;

[nTSQ, nTRQ, nSess] = size(SC.sunkLines);

assert(nTSQ==nTRQ);
x = 1:nTSQ;

b = nan(nSess,2);

for iS = 1:nSess
k = ~isnan(SC.sunkLines(1,:,iS));
b(iS,:) = polyfit(x(k), SC.sunkLines(1,k,iS),1);
end

baseSlope = b(:,1);
sunkNess = SC.SunkNess;
W = f0(SC.temperature);
W(SC.threshold > 30) = nan;