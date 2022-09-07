function [S,C] = Calculate_SunkCostSlopes(pEarn,R)

if nargin==1
    maxD = length(pEarn);
    delayRange = 1:maxD;
elseif isstruct(R)
    maxD = max(R.offer);
    delayRange = R.delayRange;
else
    maxD = R;
    delayRange = 1:maxD;
end

S = nan(maxD,2);
C = nan(maxD,2);

% calculate slopes
for iTSQ = 1:maxD
    if sum(~isnan(pEarn(iTSQ,:)))>3
        k = ~isnan(pEarn(iTSQ,:));
        S(iTSQ,:) = polyfit(delayRange(k), pEarn(iTSQ,k), 1);        
        C(iTSQ,:) = polyfit(delayRange(k), pEarn(1,k), 1);
    end
end
