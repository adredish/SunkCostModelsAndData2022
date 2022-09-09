% assumes you are starting in SunkCostModelsAndData2022
clear; close all; clc
addpath(genpath(pwd))

%% Figure 1 - tasks
% Both a and b are reprinted from Sweis, Abram, et al 2018.

%% Figure 2 - escalations
% b is reprinted from Sweis, Abram, et al 2018

%% 2c, f
clear; close all hidden; 
load('BMS/ScienceDataset.mat', 'dataset');
Science_waitzoneSunkCosts(dataset, 'mousePrimaryLate1to30');
Science_replotSunkByOffer(dataset, 'mousePrimaryLate1to30');
myPrintAll('Fig02-');
disp('done');

%% Figure 3 Quits are corrections
clear; close all hidden; 

bmsds = load('BMS/sunkByValue.mat');
for iG = fieldnames(bmsds)'
    PEVD.(iG{1}) = nan;
    PEVD.(iG{1}) = BMS_Data2PEV(bmsds.(iG{1}));
end
load('Huynh/PEV_Huynh');
     PEVD.Huynh = PEV_Huynh;
     PEVD.Prolific = PEV_Prolific;

DSfn = fieldnames(PEVD); nDS = length(DSfn);
for iDS = 1:nDS
    [f1,f2] = Show_pEarnXvalue(PEVD.(DSfn{iDS}), 'nBins', 20);
    figure(f1); axis square; set(gca, 'FontSize', 50); 
    figure(f2); title(DSfn{iDS}); legend off;
    set(f2, 'units', 'normalized','outerposition', [0 0 1 1]); set(gca, 'FontSize', 50);     
end
myPrintAll('Fig03-');
disp('done');

%% Figure 4  Basic simulation
% equivalent to Ott et al 2021
clear; close all hidden; clc
R = GenerateSimulation;
figure; Show_OffersTaken(R); 
figure; pEarn = Calculate_pEarn(R); Show_pEarn(pEarn, R); set(gca, 'FontSize', 36);
figure; H = Show_AttritionBias(R, 'maxW', 40); yticks([1 40]); xticks([1 10 20 30]); FigureLayout; axis square; set(gca, 'FontSize', 40);
figure; plot(1:40, H(10,:) , 'm', 1:40, H(20,:), 'k', 'LineWidth', 2); 
   legend('10s', '20s'); xlabel('Distribution over W_0'); ylabel('proportion'); ylim([0 0.15]); title('Attrition bias'); 
   FigureLayout; yticks([0 0.1]); set(gca, 'FontSize', 40);
PEV = Calculate_pEarnXvalue(R);
[f1,f2] = Show_pEarnXvalue(PEV);
figure(f1); axis square; set(gca, 'FontSize', 50);
figure(f2); legend off; title('Simulation');  set(gca, 'FontSize', 40);
set(f2, 'units', 'normalized','outerposition', [0 0 1 1]); 

myPrintAll('Fig04A-');
disp('done');

%% 
% take every offer (no preference selection effect)
clear; close all hidden; clc

R = GenerateSimulation('offerEnterFunction', @(x)true(size(x)));
figure; Show_OffersTaken(R); 
figure; pEarn = Calculate_pEarn(R); Show_pEarn(pEarn, R); set(gca, 'FontSize', 36);
figure; H = Show_AttritionBias(R, 'maxW', 40); yticks([1 40]); xticks([1 10 20 30]); FigureLayout; axis square; set(gca, 'FontSize', 40);
figure; plot(1:40, H(10,:) , 'm', 1:40, H(20,:), 'k', 'LineWidth', 2); 
   legend('10s', '20s'); xlabel('Distribution over W_0'); ylabel('proportion'); ylim([0 0.15]); title('Attrition bias'); 
   FigureLayout; yticks([0 0.1]); set(gca, 'FontSize', 40);
PEV = Calculate_pEarnXvalue(R);
[f1,f2] = Show_pEarnXvalue(PEV);
figure(f1); axis square; set(gca, 'FontSize', 50);
figure(f2); legend off; title('Simulation');  set(gca, 'FontSize', 40);
set(f2, 'units', 'normalized','outerposition', [0 0 1 1]); 

myPrintAll('Fig04B-');
disp('done');

%% Figure 5 parameter explorations over sigma_N and sigma_W
% the model is very stable for each given output so only running one sample
% of each.  

clear; close all hidden; clc
SCout = Test_Range(1);  % takes ~3 hrs on my machine
save SCout.mat SCout
savefig(1, 'Fig05--1')
savefig(2, 'Fig05--2')
savefig(3, 'Fig05--3')
myPrintAll('Fig05-');
disp('done');

%% =======================================================================
clc; close all hidden
load SCout
Show_SCoutRelationships(SCout);

fprintf('AttritionBias ~ SunkCost:\n');
mdl = fitlm(SCout.attritionBias(:), SCout.sunkCost(:));

mdl = fitlm([SCout.W(:), SCout.N(:)], SCout.attritionBias(:));
fprintf('AttritionBias ~ W + N:\n\t AdjR2 = %f;\n\t F-stat(AB | W)=%f (p=%f);\n\t F-stat(AB | N)=%f (p=%f)\n', ...
    mdl.Rsquared.Adjusted, mdl.anova.F(1), mdl.anova.pValue(1), mdl.anova.F(2), mdl.anova.pValue(2));

mdl = fitlm([SCout.W(:), SCout.N(:)], SCout.sunkCost(:));
fprintf('SunkCost ~ W + N:\n\t AdjR2 = %f;\n\t F-stat(SC | W)=%f (p=%f);\n\t F-stat(SC | N)=%f (p=%f)\n', ...
    mdl.Rsquared.Adjusted, mdl.anova.F(1), mdl.anova.pValue(1), mdl.anova.F(2), mdl.anova.pValue(2));

mdl = fitlm([SCout.W(:), SCout.N(:)], SCout.baseSlope(:));
fprintf('BaseSlope ~ W + N:\n\t AdjR2 = %f;\n\t F-stat(BS | W)=%f (p=%f);\n\t F-stat(BS | N)=%f (p=%f)\n', ...
    mdl.Rsquared.Adjusted, mdl.anova.F(1), mdl.anova.pValue(1), mdl.anova.F(2), mdl.anova.pValue(2));

% calculations we're doing
R = GenerateSimulation;
pEarn = Calculate_pEarn(R); 
figure; Show_pEarn(pEarn,R); 
[S,C] = Calculate_SunkCostSlopes(pEarn,R);
plot(0:30, polyval(S(1,:), 0:30), 'k-', 'LineWidth', 3);
legend off; axis square; FigureLayout; 

Show_SunkCostBubble(pEarn, R);

figure; [H,AB,z] = Show_AttritionBias(R); legend off; axis square; FigureLayout;
plot(1:30, polyval(z.z, 1:30), 'w', 1:30, polyval(z.z, 1:30), 'r:', 'LineWidth', 3);

myPrintAll('Fig05b-');

disp('done');
%% Figure 06 Quit Threshold SLOPE
clear; close all hidden; clc

R = GenerateSimulation('quitThresholdSlope', 1, 'quitThresholdStartFactor', 1.0);
pEarn = Calculate_pEarn(R);
figure; Show_pEarn(pEarn,R); legend off; title('QT slope = -1'); axis square; FigureLayout; 
figure; Show_AttritionBias(R, 'maxW', 40); title('QT slope = -1'); axis square; FigureLayout;
%
R = GenerateSimulation('quitThresholdSlope', 0, 'quitThresholdStartFactor', 1.0);
pEarn = Calculate_pEarn(R);
figure; Show_pEarn(pEarn,R); legend off; title('QT slope = 0; QT=Offer'); axis square; FigureLayout;
figure; Show_AttritionBias(R, 'maxW', 40); title('QT slope = 0; QT=Offer'); axis square; FigureLayout;
%
R = GenerateSimulation('quitThresholdSlope', 0, 'quitThresholdStartFactor', 0.0);
pEarn = Calculate_pEarn(R); 
figure; Show_pEarn(pEarn,R); legend off; title('QT slope = 0; QT=0'); axis square; FigureLayout;
figure; Show_AttritionBias(R, 'maxW', 40); title('QT slope = 0; QT=0'); axis square; FigureLayout;
%
R = GenerateSimulation('quitThresholdSlope', -1);
pEarn = Calculate_pEarn(R);
figure; Show_pEarn(pEarn,R); legend off; title('QT slope = +1'); axis square; FigureLayout;
figure; Show_AttritionBias(R, 'maxW', 40); title('QT slope = +1'); axis square; FigureLayout;

myPrintAll('Fig06-');
disp('done');
%% Figure 07 Limiting ability to wander away
close all; clear; clc
R = GenerateSimulation; 
figure; pEarn = Calculate_pEarn(R); Show_pEarn(pEarn, R);  title('base'); legend off;  axis square; FigureLayout; 
figure; Show_WanderingNbyOffer(R, 'maxN', 60); FigureLayout('layout', [1 1], 'scaling', 1/0.15);

R = GenerateSimulation('quitThresholdSlope', 0);
figure; pEarn = Calculate_pEarn(R); Show_pEarn(pEarn, R);  title('quitThresholdSlope = 0/s'); legend off;  axis square; FigureLayout; 
figure; Show_WanderingNbyOffer(R, 'maxN', 60);   FigureLayout('layout', [1 1], 'scaling', 1/0.15);

R = GenerateSimulation('maxNdeviation', 0);
figure; pEarn = Calculate_pEarn(R); Show_pEarn(pEarn, R);  title('DW <= 0'); legend off;   axis square; FigureLayout; 
figure; Show_WanderingNbyOffer(R, 'maxN', 60); FigureLayout('layout', [1 1], 'scaling', 1/0.15);

R = GenerateSimulation('maxNdeviation', 0, 'quitThresholdSlope', 0);
figure; pEarn = Calculate_pEarn(R); Show_pEarn(pEarn, R);  title('quitThresholdSlope = 0/s & DW <= 0'); legend off;  axis square; FigureLayout; 
figure; Show_WanderingNbyOffer(R, 'maxN', 60);  FigureLayout('layout', [1 1], 'scaling', 1/0.15);

myPrintAll('Fig07-');
disp('done');


%%

%% Figure 8
popdir all
clear; close all; clc
SC10 = Test_Range(20, 'calcAttritionBias', false, 'calcPEV', false, 'showFigures', false);
save SC10 SC10
%%
clear; close all; clc
load SC10
figure
[nS,nN,nW] = size(SC10.temperature);  nS = nS*nN;
X = repmat(SC10.sigmaW, nS, 1); X = X(:);
Y = SC10.temperature; Y = Y(:);
g0 = fittype('a + b/x');
[f0,gof1] = fit(Y,X,g0);
xW = 0:0.01:1;
plot(Y, X, 'ko', xW, f0(xW), 'r-');
legend('data',sprintf('fit: %.2f + %.2f/x', f0.a, f0.b));
xlabel('Tangent of the probit fit at threshold [t]');
ylabel('s_W');
ylim([0 20]); xlim([0 1]);
FigureLayout

Show_Range(SC10, f0);
myPrintAll('Fig08-');
disp('done');
%% Figure 9
clear; close all; clc; 
% QT decays through decision time
SCout1 = Test_DecisionTimeWZ('decisionTimeWZ_hardset', true, 'nBoot', 1);
Show_DecisionTimeWZTestResult(SCout1);

% QT decay starts after decision time
SCout2 = Test_DecisionTimeWZ('decisionTimeWZ_hardset', false, 'nBoot', 1);
Show_DecisionTimeWZTestResult(SCout2);

myPrintAll('Fig09-');
%% 
clear; close all; clc
load('BMS/dataset.mat', 'dataset');
Science_waitzoneSunkCosts(dataset, 'mousePrimaryEarly1to30'); title('mice')
Science_waitzoneSunkCosts(dataset, 'rat1zone'); title('rats')
BMS_ShowAccrual;

myPrintAll('Fig10-');
%%
close all hidden
disp('Completed');
%%
function myPrint(fn)
disp(fn);
print(sprintf('Figures/%s', fn), '-dsvg','-painters');
print(sprintf('Figures/%s', fn), '-dpng');
end

function myPrintAll(fn)
f = findobj('Type', 'figure');
for iF = 1:length(f)
    figure(f(iF)); myPrint(sprintf('%s-%d', fn, iF)); 
end
end