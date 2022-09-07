function Show_pEarn(pEarn, R, varargin)
filled = false;
process_varargin(varargin);

if nargin==1
    maxD = length(pEarn);
elseif isstruct(R)
    maxD = max(R.offer);
else
    maxD = R;
end
    

maxTSQ2show = 15;

hold on;
c = BuildColorMap(maxTSQ2show,5);

%TSQs = [1:5 10:5:(maxD-1)];
TSQs = 1:maxTSQ2show;
% calculate slopes
for iTSQ = 1:length(TSQs)
       h = plot(1:maxD,pEarn(TSQs(iTSQ),:), 'o', 'color', c(TSQs(iTSQ),:));
    if filled
        set(h, 'MarkerFaceColor', c(iTSQ,:));
    end
end
legend off

xlabel('Time remaining (s)');
ylabel('p(Earn)');
yticks([0 1]);
ylim([0 1]);
xlim([0 30]);
legend(arrayfun(@(x) sprintf('%.0fs invested', x), TSQs, 'UniformOutput', false), ...
    'Location', 'eastoutside');
