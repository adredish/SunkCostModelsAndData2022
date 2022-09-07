function [H, AB, results] = Calculate_AttritionBias(R, varargin)

maxW = 80;
process_varargin(varargin);

assert(all(isnan(R.isEarn)==isnan(R.isQuit)));
k = isnan(R.isEarn);
R.isEarn(k) = false; R.isQuit(k) = false; R.TSQ(k) = -5;

H = nan(30,maxW);
mu = nan(30,1);
se = nan(30,1);

x = []; y = [];
for iTS = 1:30
    stillAt = ~k & (R.isEarn & (R.offer > iTS)) | (R.isQuit & (R.TSQ > iTS));
    H(iTS,:) = histcounts(R.W0(stillAt),0.5:1:(maxW+0.5));
    H(iTS,:) = H(iTS,:) ./ sum(H(iTS,:), 'omitnan');
    mu(iTS) = mean(R.W0(stillAt));
    se(iTS) = nanstderr(R.W0(stillAt));
    
    x = cat(1, x, repmat(iTS, sum(stillAt), 1));
    y = cat(1, y, R.W0(stillAt));
end

z = polyfit(x,y,1);
AB = z(1);

results.x = x;
results.y = y;
results.mu = mu;
results.se = se;