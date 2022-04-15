function [baseSlope, sunkCost] = RK0(f0)
% ADD_RK_DATA(fH)

%% ADD RK data to slope / sunkcost plot
load X

%%
baseSlope = nan(2,1);
sunkCost = nan(2,1);

clear Z
for iA = 0:1
    isAG = X.AttnGroup == iA;
    k = ~isnan(X.QuitEarn) & isAG;
    Z.offer = X.Delay(k);
    Z.isQuit = X.QuitEarn(k)==1;
    Z.isEarn = X.QuitEarn(k)==0;
    Z.maxD = 30;
    Z.delayRange = 1:30;
    Z.timeSpentAtQuit = X.Delay(k) - (X.Thresholds(k) - X.ValueQuit(k));
    Z.timeSpentAtQuit(Z.isEarn) = nan;
    pEarn = CalculateSunkCostInWZ(Z);
    [S,C] = Calculate_SunkCostSlopes(pEarn, Z);
    baseSlope(iA+1) = S(1);
    sunkCost(iA+1) = nansum(S(:,1) - C(:,1));
    %figure; KPShow_SunkCostSlopes(S,Z);title(sprintf('AttentionGroup = %d', iA));
    %ylim([0.9 1.01]);
end

