function [slopes] = Calculate_PEV_slopes(PEV, varargin)

[nV, nTSQ] = size(PEV.pEarnV);

x = repmat(PEV.values', 1, nTSQ);
y = PEV.pEarnV - PEV.pEarnV(:,1);
t = repmat(PEV.TSQ, nV, 1);

k = ~isnan(y);
x = x(k(:));
y = y(k(:));
t = t(k(:));

% marker = '*';
% scatter(x,y,10,t, marker); hold on
[slopes.mu, slopes.x, slopes.se] = GroupMean(y, x, varargin{:});
% errorbar(slopes.x, slopes.mu, slopes.se)
% line([0 0], ylim, 'color', 'k');

% prevmdlR = 0;
% for iP = 1:10
%     switch (iP)
%         case 1
%             wilkinson = 'y ~ x1 + x2';
%         otherwise
%             wilkinson = sprintf('y ~ x1^%d + x2', iP);
%     end
%     mdl = fitlm([x t],y,wilkinson);
%     fprintf('^%d : %.2f\n', iP, mdl.Rsquared.Ordinary - prevmdlR);
%     prevmdlR = mdl.Rsquared.Ordinary;
%     plot(-15:15, mdl.feval(-15:15, 10));    
% end