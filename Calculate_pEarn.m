function pEarn = CalculateKepecs_pEarn(R)

k = R.isStay(:)==1;
R0.offer = R.offer(k);
R0.timeSpentAtQuit = R.TSQ(k);
R0.isEarn = R.isEarn(k)==1;
R0.isQuit = R.isQuit(k)==1;
R0.maxD = max(R.delayRange);

[pEarn, ~] = CalculateSunkCostInWZ(R0);
