function [dSC, dBS] = Compare_SunknessSlopes(bs, sc, gn, Wwz, model)

% compares the sunkness and slope between data and model
% for each data point, finds closest model point with same sigmaW

nSubj = length(bs);
assert(length(sc)==nSubj);
assert(length(Wwz)==nSubj);

dW = nan(nSubj,1);
dSC = nan(nSubj,1);
dBS = nan(nSubj,1);

for iSubj = 1:nSubj
    [dW(iSubj),iW] = min(abs(model.sigmaW - Wwz(iSubj)));
    W = model.sigmaW(iW);
    [~,iN] = min((model.sunkCost(model.W(:)==W)-sc(iSubj)).^2 + (abs(model.baseSlope(model.W(:)==W) - bs(iSubj))).^2);
    N = model.N(iN);
    dSC(iSubj) = mean(model.sunkCost(model.W(:)==W & model.N(:)==N) - sc(iSubj));
    dBS(iSubj) = mean(model.baseSlope(model.W(:)==W & model.N(:)==N) - bs(iSubj));
end

fprintf('%s: dSC is 0: p=%.5f\n', gn, signrank(dSC));
fprintf('%s: dBS is 0: p=%.5f\n', gn, signrank(dBS));