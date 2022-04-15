load X.mat
%%

value = X.Thresholds - X.Delay;
[valueBin,E] = discretize(value, -30:3:30);
early = X.TrialNum<50; late = X.TrialNum>=50;
mRT0 = accumarray(valueBin(early), X.zRTOfferZone(early), [length(E)-1 1], @nanmean);
mRT1 = accumarray(valueBin(late), X.zRTOfferZone(late), [length(E)-1 1], @nanmean);

sRT0 = accumarray(valueBin(early), X.zRTOfferZone(early), [length(E)-1 1], @nanstderr);
sRT1 = accumarray(valueBin(late), X.zRTOfferZone(late), [length(E)-1 1], @nanstderr);

x = (E(1:(end-1))+E(2:end))/2;
plot(x, mRT0, x, mRT1);
hold on
ShadedErrorbar(x, mRT0, sRT0, 'color', 'r');
ShadedErrorbar(x, mRT1, sRT1, 'color', 'b');
line([0 0], ylim, 'color', 'k');
