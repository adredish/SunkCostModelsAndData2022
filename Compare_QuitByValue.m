clear; clc; clf
%%
load('Huynh/PEV_Huynh');
bmsds = load('BMS/sunkByValue.mat');
for iG = fieldnames(bmsds)'
    PEVD.(iG{1}) = nan;
    PEVD.(iG{1}) = BMS_Data2PEV(bmsds.(iG{1}));
end
PEVD.Huynh = PEV_Huynh;
PEVD.Prolific = PEV_Prolific;
%%
DSfn = fieldnames(PEVD);
nDS = length(DSfn);
for iDS = 1:nDS
    sPEVD.(DSfn{iDS}) = Calculate_PEV_slopes(PEVD.(DSfn{iDS}), 'nBins', 20);
end
%%
ksmatrix = nan(nDS);
for iDS = 1:nDS
    for jDS = 1:nDS
        [~,p] = kstest2(sPEVD.(DSfn{iDS}).mu, sPEVD.(DSfn{jDS}).mu);
        ksmatrix(iDS,jDS) = p;
    end
end
k0 = tril(ksmatrix,-1);
k0(k0==0) = [];
%%
load SCout
assert(size(SCout.slopes.mu,3) == length(sPEVD.Huynh.mu));
nM = size(SCout.slopes.mu,2);
ksmodelmatrix = nan(nDS, nM);
for iDS = 1:nDS
    for iM = 1:nM
        [~,p] = kstest2(sPEVD.(DSfn{iDS}).mu, squeeze(SCout.slopes.mu(1,iM,:)));
        ksmodelmatrix(iDS, iM) = p;
    end
end
%%
clf
histogram(ksmodelmatrix(:), 0:0.01:0.1)
hold on
histogram(k0(:),0:0.01:1)
line([0.05 0.05], ylim, 'color','r')
%%
for iDS = 1:nDS
    ShowOneFigure(SCout, ksmodelmatrix(iDS,:))
    title(DSfn{iDS})
end

function ShowOneFigure(SCout, d)
sq = @squeeze;
figure;
scatter(sq(5-SCout.N(:)), sq(SCout.W(:)), 75, d, 's', 'filled')
axis([-0.25 5.25 -0.5 21]);
xticks(sort(SCout.sigmaN)); xticklabels({5 3 2 0});
yticks(sort(SCout.sigmaW)); set(gca, 'yscale', 'log');


C = colorbar; set(C, 'ytick', caxis);
xlabel('S_N');
ylabel('S_W');
FigureLayout('layout', [0.5 0.5]); set(gca, 'FontSize', 8*3);
axis square
end

