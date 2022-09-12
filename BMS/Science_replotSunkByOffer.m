function Science_replotSunkByOffer(dataset, fN)
%% wait zone sunk cost
cohort=dataset.waitZoneSunkCosts.(fN);%% setup colors and matrix for resorted probabilities

colors=jet(30);

probByOffer=nan(30,30);

%% sort and generate figure

figure
for iO=1:30 %for 1-30s offer range
    L{iO} = sprintf('Offer %d seconds', iO);
    num2subtrFromEnd=(30-iO); %for 1-30s offer range
    for iS=0:29 %for 1-30s offer range
        if iS>=iO
            continue
        end
        sunkList=cohort.earnProb(cohort.sunkCost==iS);
        sunkList=sunkList(isfinite(sunkList));
        probByOffer(iO,iS+1)=sunkList(end-num2subtrFromEnd);
    end
    hold on
    h(iO) = plot([NaN,(probByOffer(iO,:))],'o-', 'color',(colors(iO,:)));
end
xlim([0 31]) %for 1-30s offer range
axis square
ylabel 'p(earn)'
xlabel 'time spent (s)'
title('');
k = [1 5 10 15 20 25 30];
legend(h(k), L(k), 'Location', 'eastoutside');
FigureLayout;

%% resort and generate derivative figure with same color scheme

figure
for iO=1:30 %for 1-30s offer range
    num2subtrFromEnd=(30-iO); %for 1-30s offer range
    for iS=0:29 %for 1-30s offer range
        if iS>=iO
            continue
        end
        sunkList=cohort.earnProb(cohort.sunkCost==iS);
        sunkList=sunkList(isfinite(sunkList));
        probByOffer(iO,iS+1)=sunkList(end-num2subtrFromEnd);
    end
    hold on
    plot([NaN,diff(probByOffer(iO,:))],'o-','color',(colors(iO,:)))    
end
xlim([0 31]) %for 1-30s offer range
axis square
ylabel 'one-step diff of p(earn)'
xlabel 'time spent (s)'
title('');
FigureLayout;
