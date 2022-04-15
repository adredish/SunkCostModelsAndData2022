function SCout = Test_Range(nB, varargin)


sigmaN = [5 3 2 0]; 
sigmaW = [20 10 8 5 3 1 0.5 0.25 0]; 
showMainFigure = true;
showAttritionBiasFigures = true;
showpEarnXvalueFigures = true;

process_varargin(varargin);

SCout.sigmaN = sigmaN; nN = length(SCout.sigmaN);
SCout.sigmaW = sigmaW; nW = length(SCout.sigmaW);

[sN, sW] = ndgrid(SCout.sigmaN, SCout.sigmaW);
SCout.baseSlope = nan(nB, nN, nW);
SCout.sunkCost = nan(nB, nN, nW);
SCout.threshold = nan(nB, nN, nW);
SCout.temperature = nan(nB, nN, nW);

if showMainFigure
    hF = figure;
end

hWait = waitbar(0);
for iB = 1:nB
    waitbar(0, hWait, sprintf('%d/%d', iB, nB));
    for iS = 1:(nN*nW)
        waitbar(iS/(nN*nW), hWait);
        
        R = GenerateSimulation('sigmaN', sN(iS), 'sigmaW', sW(iS));
        pEarn = Calculate_pEarn(R);
        [S,C] = Calculate_SunkCostSlopes(pEarn,R);
        
        SCout.baseSlope(iB,iS) = S(1);
        SCout.sunkCost(iB,iS) = nansum(S(:,1) - C(:,1));
        
        b = glmfit(R.offer, R.isStay, 'binomial','link', 'probit');
        [SCout.threshold(iB,iS), SCout.temperature(iB,iS)] = unpackProbit(b);
        
        if sW(iS) < 1
            MSG = sprintf('\\sigma_W = %.2f       \\sigma_N = %.0f', sW(iS), sN(iS));
        else
            MSG = sprintf('\\sigma_W = %.0f       \\sigma_N = %.0f', sW(iS), sN(iS));
        end
        
        if iB == 1 && showMainFigure           
            figure(hF); set(gcf, 'units', 'normalized','outerposition', [0.5 0 0.5 1]);
            subplot(nW, nN, iS);
            h = Show_pEarn(pEarn, R);
            set(h, 'Marker', '.');
            legend off;
            if sW(iS)==SCout.sigmaW(end)
                xlabel('Time Remaining');
            else
                xlabel('');
                xticks([]);
            end
            ylim([0 1]);
            if sN(iS)== SCout.sigmaN(1)
                ylabel('p(Earn)');
            else
                yticks([]);
                ylabel('');
            end
            text(1,0.25,MSG);

            drawnow;
        end
        
        if iB==1 && showAttritionBiasFigures            
            figure
            Show_AttritionBias(R);
            ylim([0.5 70.5]);
            title(MSG);
            FigureLayout;
            drawnow;
        end       
        
        if iB==1 && showpEarnXvalueFigures            
            PEV = Calculate_pEarnXvalue(R);
            Show_pEarnXvalue(PEV);
            ylim([-0.1 0.5]);
            title(MSG);
            FigureLayout;
            drawnow;
        end                

    end
end

[~,SCout.N,SCout.W] = ndgrid(1:nB, SCout.sigmaN, SCout.sigmaW);

end

%%

