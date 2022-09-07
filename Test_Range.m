function SCout = Test_Range(nB, varargin)


sigmaN = [5 3 2 0]; 
sigmaW = [20 10 8 5 3 1 0.5 0.25 0]; 
process_varargin(varargin);

SCout.sigmaN = sigmaN; nN = length(SCout.sigmaN);
SCout.sigmaW = sigmaW; nW = length(SCout.sigmaW);

[sN, sW] = ndgrid(SCout.sigmaN, SCout.sigmaW);
SCout.baseSlope = nan(nB, nN, nW);
SCout.sunkCost = nan(nB, nN, nW);
SCout.threshold = nan(nB, nN, nW);
SCout.temperature = nan(nB, nN, nW);
SCout.attritionBias = nan(nB, nN, nW);

SCout.slopes.xrange = [-30 30];
SCout.slopes.nBins = 20;
SCout.slopes.x = nan(nB, nN*nW, SCout.slopes.nBins);
SCout.slopes.mu = nan(nB, nN*nW, SCout.slopes.nBins);
SCout.slopes.se = nan(nB, nN*nW, SCout.slopes.nBins);

[~,SCout.N, SCout.W] = ndgrid(1:nB, SCout.sigmaN, SCout.sigmaW);

for iB = 1:nB
    hSC = figure; set(hSC, 'units', 'normalized','outerposition', [0.5 0 0.5 1]);
    hAB = figure; set(hAB, 'units', 'normalized','outerposition', [0.5 0 0.5 1]);
    hPV = figure; set(hPV, 'units', 'normalized','outerposition', [0.5 0 0.5 1]);

    t = nan(nN*nW,1);
    for iS = 1:(nN*nW)
        tic;
        fprintf('[%.2f, %.2f]: ', sW(iS), sN(iS));
        
        R = GenerateSimulation('sigmaN', sN(iS), 'sigmaW', sW(iS));
        
        fprintf(' pEarn ');
        pEarn = Calculate_pEarn(R);
        [S,C] = Calculate_SunkCostSlopes(pEarn,R);
        SCout.baseSlope(iB,iS) = S(1);
        SCout.sunkCost(iB,iS) = nansum(S(:,1) - C(:,1));
        
        fprintf(' AttritionBias ');
        [~,SCout.attritionBias(iB,iS)] = Calculate_AttritionBias(R);
       
        fprintf(' PEV ');
        PEV = Calculate_pEarnXvalue(R);
        slopes = Calculate_PEV_slopes(PEV, ...
            'nBins', SCout.slopes.nBins, 'xrange', SCout.slopes.xrange);
        SCout.slopes.x(iB,iS,:) = slopes.x;
        SCout.slopes.mu(iB,iS,:) = slopes.mu;
        SCout.slopes.se(iB,iS,:) = slopes.se;
                
        fprintf(' probit ');
        b = glmfit(R.offer, R.isStay, 'binomial','link', 'probit');
        [SCout.threshold(iB,iS), SCout.temperature(iB,iS)] = unpackProbit(b);
               
        if sW(iS) < 1
            MSG = sprintf('\\sigma_W = %.2f \\sigma_N = %.0f', sW(iS), sN(iS));
        else
            MSG = sprintf('\\sigma_W = %.0f \\sigma_N = %.0f', sW(iS), sN(iS));
        end

        fprintf(' drawing ');
        % SunkCosts
        figure(hSC); 
        subplot(nW, nN, iS);
        Show_pEarn(pEarn, R, 'filled', false);
        legend off; title(''); 
        text(1,0.05,sprintf('%s: SC=%.2f, BS=%.2f', MSG, SCout.sunkCost(iB,iS), SCout.baseSlope(iB,iS)));
        drawnow;
        
        % attritionbias
        figure(hAB); subplot(nW, nN, iS);
        [~,AB] = Show_AttritionBias(R);
        legend off; title('');
        text(1,5,sprintf('%s, AB = %.2f', MSG, AB), 'color', 'w');
        drawnow;
        
        % pEarnXvalue
        figure(hPV); subplot(nW, nN, iS); 
        Show_pEarnXvalue2(PEV); legend off
        text(-25, -0.2, MSG);
        drawnow;
        
        t(iS) = toc;
        fprintf('%.0f sec (%.0f sec to go)\n', t(iS), nanmean(t(iS)) * (nN*nW - iS));
    end
end

end

%%

