function pEarn = BMS_Data2pEarn(d)

nT = length(d.timeLeft);
assert(nT == length(d.sunkCost));
assert(nT == length(d.earnProb));

TRQ = d.timeLeft; 
TSQ = d.sunkCost+1; 

offer = TRQ + TSQ;
maxD = max(offer);

pEarn = accumarray([TSQ TRQ], d.earnProb, [maxD maxD], @nanmean, nan);

        