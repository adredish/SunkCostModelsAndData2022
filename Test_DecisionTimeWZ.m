function SCout = Test_DecisionTimeWZ(decisionTimeToTest, qTdecayThroughDT, varargin)

% KPTest Delayed Start
% if delay start by Xs, what happens?

SCout.decisionTimeWZ = 0:10;  
nBoot = 3;
process_varargin(varargin);

nD = length(SCout.decisionTimeWZ);

SCout.sc = nan(nBoot, nD, 30);
SCout.scSum = nan(nBoot, nD);

assert(islogical(qTdecayThroughDT));
switch (decisionTimeToTest)
    case 'decisionTimeWZ_sigmaN'
        SCout.T = '\sigma_N=0 for a few s';
        SCout.Lstr = '\sigma_N=0 0 for %s s';
    case 'decisionTimeWZ_hardset'
        SCout.T = 'cannot quit for a few s';
        SCout.Lstr = 'cannot quit for %s s';                
end
if qTdecayThroughDT
    SCout.T = [SCout.T, '; T_{WZ} decays at OZ entry'];
else
    SCout.T = [SCout.T, '; T_{WZ} decays after DZ'];
end

hWait = waitbar(0);
for iB = 1:nBoot
    waitbar(0, hWait, sprintf('%d/%d', iB, nBoot));
    for iD = 1:nD
        waitbar(iD/nD, hWait);

        R = GenerateSimulation(decisionTimeToTest, SCout.decisionTimeWZ(iD), ...
            'offerEnterFunction', @(x)ones(size(x)), ...
            'qTdecayThroughDT', qTdecayThroughDT);
        pEarn = Calculate_pEarn(R);
        [S,C] = Calculate_SunkCostMeans(pEarn,R);
        SCout.sc(iB, iD, :) = S(:,1) - C(:,1);
        SCout.scSum(iB, iD) = nanmax(S(:,1) - C(:,1));
    end
end

