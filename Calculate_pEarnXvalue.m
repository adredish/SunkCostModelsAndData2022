function PEV = CalculateKepecs_pEarnXvalue(R, varargin)

k = R.isStay(:)==1;
R0.offer = R.offer(k);
R0.TSR = R.offer(k) - R.TSQ(k);
R0.TSQ = R.TSQ(k);
R0.isEarn = R.isEarn(k)==1;
R0.isQuit = R.isQuit(k)==1;

values = -30:30;
nV = length(values);
nT = length(R0.offer);

V = nan(nT,nV);
TS = nan(nT,nV);
allTrials = nan(nT, nV);
for iT = 1:nT
    starting_value = R.threshold - R0.offer(iT);
    iV0 = starting_value - values(1) + 1;    
    if isnan(R0.TSQ(iT)) || R0.TSR(iT)==0 % earn
        iV1 = iV0 + R0.offer(iT)-1;
        allTrials(iT, iV0:iV1) = 1;
        V(iT,iV0:iV1) = values(iV0:iV1);
        TS(iT,iV0:iV1) = 1:R0.offer(iT);
    else
        iV1 = iV0 + R0.TSQ(iT)-1;
        allTrials(iT, iV0:iV1) = 0;
        V(iT,iV0:iV1) = values(iV0:iV1);
        TS(iT,iV0:iV1) = 1:R0.TSQ(iT);
    end
end

pEarnV = nan(nV, 30);
for iQ = 1:30
    fprintf('.');
    for iV = 1:nV
        pEarnV(iV,iQ) = nanmean(allTrials(V==values(iV) & TS==iQ));
    end    
end
fprintf('\n');

PEV.pEarnV = pEarnV;
PEV.values = values;
PEV.TSQ = 1:30;




    
