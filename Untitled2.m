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
