function [S,C] = CalculateKepecs_SunkCostMeans(pEarn,R)

maxD = max(R.offer);
S = nan(maxD,2);
C = nan(maxD,2);

% calculate slopes
for iTSQ = 1:maxD
    if sum(~isnan(pEarn(iTSQ,:)))>3
        k = ~isnan(pEarn(iTSQ,:));
        S(iTSQ,:) = mean(pEarn(iTSQ,k), 2);        
        C(iTSQ,:) = mean(pEarn(1,k), 2);
    end
end
