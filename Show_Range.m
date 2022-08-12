function Show_Range(SCout, f0)

if nargin == 0
    pushdir('E:\adr\DATA\KepecsResponse\SunkCostModels-Redish2021');
    load('SC_RangeTest.mat', 'SC_RangeTest');
    SCout = SC_RangeTest;
    popdir;
end

[nB, nN, nW] = size(SCout.baseSlope);

[~, sN, sW] = ndgrid(1:nB, SCout.sigmaN, SCout.sigmaW);

figure;
clf; hold on
xy = nan(nN, nW, 2);
for iN = 1:nN
    for iW = 1:nW
        xy(iN,iW,1) = nanmean(SCout.baseSlope(sN(:) == SCout.sigmaN(iN) & sW(:) == SCout.sigmaW(iW)));
        xy(iN,iW,2) = nanmean(SCout.sunkCost(sN(:) == SCout.sigmaN(iN) & sW(:) == SCout.sigmaW(iW)));
    end
end
mesh(xy(:,:,1), xy(:,:,2), zeros(nN, nW), 'EdgeColor', [0 0 0], 'FaceColor', 'none');

%
c = repmat(jet(nW), [nN, 1]);
potentialSymbols = '*ospsv^<>h';
s = repmat(potentialSymbols(1:nN), [nW,1]);
gscatter(SCout.baseSlope(:), SCout.sunkCost(:), {sN(:),sW(:)},c,s(:));
xlabel('Slope at 0s');
ylabel('Sunk Cost Total');
FigureLayout;

hold on
h = nan(nN,1);
for iN = 1:nN
    h(iN) = plot(nan,nan, ['k' potentialSymbols(iN)]);
end
labels = arrayfun(@(x)sprintf('\\sigma_N = %d',x), 1:nN, 'uniformoutput', false);
legend(h,labels, 'location','best');

mW = max(SCout.sigmaW);
C = colorbar;  colormap(jet); caxis([0 mW]);
C.Limits = [0 mW];
C.Ticks = sort(unique(SCout.sigmaW));
ylabel(C, '\sigma_W');

xlim([-0.06 0.01]); ylim([-0.5 1]);
xticks([-0.05 0]); yticks([0 1]);
FigureLayout;


%%
clear h c L
% RK
pushdir('RK');  [bs,sc] = RK0(f0);  popdir;
MakeMesh();
h(1) = plot(bs(1), sc(1), 'bo', 'MarkerSize', 10, 'MarkerFaceColor', 'b'); L{1} = 'no-attn-check';
h(2) = plot(bs(2), sc(2), 'co', 'MarkerSize', 10, 'MarkerFaceColor', 'c'); L{2} = 'with-attn-check';
legend(h,L);
title('RK 2020: humans online');
FinishFig();
colorbar off

% BMS
pushdir ('BMS');  [bs,sc,gn, Wwz] = BMS0(f0, 'mouse'); popdir;
MakeMesh();
scatter(bs{1}, sc{1}, 20, Wwz{1}, 'filled', 'Marker', 's');
scatter(bs{2}, sc{2}, 20, Wwz{2}, 'filled', 'Marker', 'p');
h(1) = plot(nan,nan, 'ks', 'MarkerFaceColor', 'k');
h(2) = plot(nan,nan, 'kp', 'MarkerFaceColor', 'k');
title('mice [BMS 2018-2022]');
legend(h, 'early in training', 'late in training');
FinishFig();

pushdir('BMS'); [bs,sc,gn, Wwz] = BMS0(f0, 'rat'); popdir;
MakeMesh();
scatter(bs{1}, sc{1}, 20, Wwz{1}, 'filled', 'Marker', 's');
scatter(bs{2}, sc{2}, 20, Wwz{2}, 'filled', 'Marker', 'p');

% add PJC-GWD
pushdir('PJC-GWD');  [bs,sc,W] = PJCGWD0(f0); popdir;
plot(bs(isnan(W)), sc(isnan(W)), 'ko', 'MarkerSize', 2, 'MarkerFaceColor', 'k');
scatter(bs, sc, 10, W, 'filled', 'Marker', 'o');  title('Rats with OZ [PJC/GWD 2021]');
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
        mesh(xy(:,:,1), xy(:,:,2), zeros(nN, nW), 'EdgeColor', [0.5 0.5 0.5], 'FaceColor', 'none');
    end

    function FinishFig()
        caxis([0 20]); colormap jet;
        C = colorbar;
        
        C.Ticks = [0 20];
        ylabel(C, 'fit \sigma_W');

        xlabel('Slope at 0s');
        ylabel('Sunk Cost Total');
        xlim([-0.06 0.01]); ylim([-0.5 1]);
        xticks([-0.05 0]); yticks([0 1]);
        
        FigureLayout('layout', [0.33 0.5]);
    end
end