function H = Show_AttritionBias(R, varargin)

maxW = 80;
process_varargin(varargin);

assert(all(isnan(R.isEarn)==isnan(R.isQuit)));
k = isnan(R.isEarn);
R.isEarn(k) = false; R.isQuit(k) = false; R.TSQ(k) = -5;

H = nan(30,maxW);
mu = nan(30,1);
se = nan(30,1);

for iTS = 1:30
    stillAt = ~k & (R.isEarn & (R.offer > iTS)) | (R.isQuit & (R.TSQ > iTS));
    H(iTS,:) = histcounts(R.W0(stillAt),0.5:1:(maxW+0.5));
    H(iTS,:) = H(iTS,:) ./ sum(H(iTS,:), 'omitnan');
    mu(iTS) = mean(R.W0(stillAt));
    se(iTS) = nanstderr(R.W0(stillAt));
end

clf;
imagesc(H');
axis xy
hold on;
errorbar(1:30, mu, se, 'k');
xlabel('TimeSpent');
ylabel('W0');

caxis([0 0.1]);
C = colorbar;
C.Label.String = 'Proportion';
C.Label.Position(1) = 2;
C.Ticks = [0 0.1];

FigureLayout('layout', [0.4 0.5]);