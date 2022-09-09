function Show_Range(SCout, f0)

[nB, nN, nW] = size(SCout.baseSlope);

[~, sN, sW] = ndgrid(1:nB, SCout.sigmaN, SCout.sigmaW);

xy = nan(nN, nW, 2);
c = nan(nN, nW, 1);
for iN = 1:nN
    for iW = 1:nW
        xy(iN,iW,1) = nanmean(SCout.baseSlope(sN(:) == SCout.sigmaN(iN) & sW(:) == SCout.sigmaW(iW)));
        xy(iN,iW,2) = nanmean(SCout.sunkCost(sN(:) == SCout.sigmaN(iN) & sW(:) == SCout.sigmaW(iW)));
        c(iN,iW) = SCout.sigmaW(iW);
    end
end

MakeMesh();
nP = size(SCout.baseSlope(:),1);
potentialSymbols = '*ospsv^<>h'; 
potentialSymbols = potentialSymbols(1:nN);
colors = nan(nP, 1); symbols = nan(nP,1);
for iP = 1:nP
    iW = SCout.sigmaW == SCout.W(iP);
    iN = SCout.sigmaN == SCout.N(iP);
    colors(iP) = c(iN,iW);
    symbols(iP) = potentialSymbols(iN);
end
for iN = 1:nN
    k = SCout.N(:) == SCout.sigmaN(iN);
    scatter(SCout.baseSlope(k), SCout.sunkCost(k), 25, colors(k), potentialSymbols(iN));
end

hold on
h = nan(nN,1);
for iN = 1:nN
    h(iN) = plot(nan,nan, ['k' potentialSymbols(iN)]);
end
labels = arrayfun(@(x)sprintf('s_N = %d',x), SCout.sigmaN, 'uniformoutput', false);
legend(h,labels, 'location','best');

FigureLayout;


%%
clear h L

% RK
[bs,sc] = RK0;  
MakeMesh();
h(1) = plot(bs(1), sc(1), 'bo', 'MarkerSize', 10, 'MarkerFaceColor', 'b'); L{1} = 'no-attn-check';
h(2) = plot(bs(2), sc(2), 'co', 'MarkerSize', 10, 'MarkerFaceColor', 'c'); L{2} = 'with-attn-check';
legend(h,L);
title('RK 2020: humans online');
FinishFig();
colorbar off

% BMS
[bs,sc,gn, Wwz] = BMS0(f0, 'mouse'); 
MakeMesh();
scatter(bs{1}, sc{1}, 20, Wwz{1}, 'filled', 'Marker', 's');
Compare_SunknessSlopes(bs{1}, sc{1}, gn{1}, Wwz{1}, SCout);
scatter(bs{2}, sc{2}, 20, Wwz{2}, 'filled', 'Marker', 'p');
Compare_SunknessSlopes(bs{2}, sc{2}, gn{2}, Wwz{2}, SCout);
h(1) = plot(nan,nan, 'ks', 'MarkerFaceColor', 'k');
h(2) = plot(nan,nan, 'kp', 'MarkerFaceColor', 'k');
title('mice [BMS 2018-2022]');
legend(h, 'early in training', 'late in training');
FinishFig();

pushdir('BMS'); [bs,sc,gn, Wwz] = BMS0(f0, 'rat'); popdir;
MakeMesh();
scatter(bs{1}, sc{1}, 20, Wwz{1}, 'filled', 'Marker', 's');
Compare_SunknessSlopes(bs{1}, sc{1}, gn{1}, Wwz{1}, SCout);
scatter(bs{2}, sc{2}, 20, Wwz{2}, 'filled', 'Marker', 'p');
Compare_SunknessSlopes(bs{2}, sc{2}, gn{2}, Wwz{2}, SCout);


% add PJC-GWD
pushdir('PJC-GWD');  [bs,sc,W] = PJCGWD0(f0); popdir;
plot(bs(isnan(W)), sc(isnan(W)), 'ko', 'MarkerSize', 2, 'MarkerFaceColor', 'k');
scatter(bs, sc, 10, W, 'filled', 'Marker', 'o');  title('Rats with OZ [PJC/GWD 2021]');
Compare_SunknessSlopes(bs, sc, 'PJCGWD0', W, SCout);
h(1) = plot(nan,nan, 'ks', 'MarkerFaceColor', 'k');
h(2) = plot(nan,nan, 'kp', 'MarkerFaceColor', 'k');
h(3) = plot(nan,nan, 'ko', 'MarkerFaceColor', 'k');
title('rats [Redish Lab 2016-2018]');
legend(h, 'BJS/YAB: WZ only', '2018 data: OZ rats', 'PJC/GWD');
FinishFig();

% finish up

    function MakeMesh()
        figure
        clf; hold on
        mesh(xy(:,:,1), xy(:,:,2), c, 'LineWidth', 2, 'FaceColor', 'none');
        shading interp;
        
        colormap jet
        caxis([0 20])
        C = colorbar;
        C.Ticks = [0 20];
        ylabel(C, 'fit s_W');

        xlabel('Slope at 0s');
        ylabel('Sunk Cost Total');
        xlim([-0.06 0.01]); ylim([-0.5 1]);
        xticks([-0.05 0]); yticks([0 1]);
   
    end

    function FinishFig()      
        FigureLayout('scaling', 3);
    end
end