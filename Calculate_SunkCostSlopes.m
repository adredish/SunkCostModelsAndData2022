function [S,C] = CalculateKepecs_SunkCostSlopes(pEarn,R)

maxD = max(R.offer);
S = nan(maxD,2);
C = nan(maxD,2);

% calculate slopes
for iTSQ = 1:maxD
    if sum(~isnan(pEarn(iTSQ,:)))>3
        k = ~isnan(pEarn(iTSQ,:));
        S(iTSQ,:) = polyfit(R.delayRange(k), pEarn(iTSQ,k), 1);        
        C(iTSQ,:) = polyfit(R.delayRange(k), pEarn(1,k), 1);
    end
end
