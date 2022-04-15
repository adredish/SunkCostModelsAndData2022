function b = Show_OffersTaken(R)
% returns slope of offer

subplot(2,1,1);
Hmu = accumarray(R.offer, R.isStay, [], @nanmean, nan);
Hse = accumarray(R.offer, R.isStay, [], @nanstderr, nan);
shadederrorbar(R.delayRange, Hmu, Hse, 'color', 'b');
ylabel('p(Accept)'); ylim([0 1]);
FigureLayout
line(R.threshold*[1 1], ylim, 'color', 'k');

subplot(2,1,2);
Hmu = accumarray(R.offer, R.isQuit, [], @nanmean, nan);
Hse = accumarray(R.offer, R.isQuit, [], @nanstderr, nan);
shadederrorbar(R.delayRange, Hmu, Hse, 'color', 'r');
xlabel('Offer (s)');
ylabel('p(Quit | Accept)'); ylim([0 1]);
FigureLayout
line(R.threshold*[1 1], ylim, 'color', 'k');

FigureLayout('layout', [0.5 0.75]);