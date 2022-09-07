%% Figure 1
% A-C are reprinted from Sweis, Abram, et al 2018.
addpath(genpath(pwd))
%% 1D-F
clear; close all hidden; clc;

pushdir('BMS');
load('ScienceDataset.mat', 'dataset');

Science_waitzoneSunkCosts(dataset, 'mousePrimaryLate1to30');
FigureLayout; title('');
popdir;
myPrint('OriginalMouseData');
disp('done');

%% FIGURE 2-1 pEarn x Value for Sweis 2018 science paper

clear; close all hidden; clc
bmsds = load('BMS/sunkByValue.mat');
BMS_ShowByValue(bmsds.sunkByValue2StepMicePlosBiolLate); 
   set(gcf, 'units', 'normalized','outerposition', [0 0 1 1]); legend off; title('Mice (Sweis 2018)'); myPrint('Fig2A'); close
   set(gcf, 'units', 'normalized','outerposition', [0 0 1 1]); axis square; legend off; title('Mice (Sweis 2018)'); myPrint('Fig2A1'); close
BMS_ShowByValue(bmsds.sunkByValue2StepMiceSocialDefeatLate); 
   set(gcf, 'units', 'normalized','outerposition', [0 0 1 1]); legend off; title('Mice (Cuttoli 2022)'); myPrint('Fig2B'); close
   set(gcf, 'units', 'normalized','outerposition', [0 0 1 1]); axis square; legend off; title('Mice (Cuttoli 2022)'); myPrint('Fig2B1'); close
BMS_ShowByValue(bmsds.sunkByValue2StepRats); 
   set(gcf, 'units', 'normalized','outerposition', [0 0 1 1]); legend off; title('Rats (Sweis 2018)'); myPrint('Fig2C'); close
   set(gcf, 'units', 'normalized','outerposition', [0 0 1 1]); axis square; legend off; title('Rats (Sweis 2018)'); myPrint('Fig2C1'); close
BMS_ShowByValue(bmsds.sunkByValue2StepHumans); 
   set(gcf, 'units', 'normalized','outerposition', [0 0 1 1]); legend off; title('Humans (Sweis 2018)'); myPrint('Fig2D'); close
   set(gcf, 'units', 'normalized','outerposition', [0 0 1 1]); axis square; legend off; title('Humans (Sweis 2018)'); myPrint('Fig2D1'); close
disp('done');  
%% FIGURE 2-2 pEarn x Value from Huynh paper
close all; 
load('Huynh/PEV_Huynh');

[f1,f2] = Show_pEarnXvalue(PEV_Huynh);
   figure(f1); legend off; axis square; 
   set(f1, 'units', 'normalized','outerposition', [0 0 1 1]); xlim([-30 30]); xticks([-30 -20 -10 0 10 20 30]); ylim([0.5 1]); line([0 0], ylim, 'color', 'k', 'LineWidth', 2); 
   myPrint('Fig2E'); 
   figure(f2); legend off;  
   set(f2, 'units', 'normalized','outerposition', [0 0 1 1]); xlim([-30 30]); xticks([-30 -20 -10 0 10 20 30]);  ylim([-0.2 0.3]); line([0 0], ylim, 'color', 'k', 'LineWidth', 2); 
   myPrint('Fig2E1'); 
[f1,f2] = Show_pEarnXvalue(PEV_Prolific);
   figure(f1); legend off; axis square; 
   set(f1, 'units', 'normalized','outerposition', [0 0 1 1]); xlim([-30 30]); xticks([-30 -20 -10 0 10 20 30]); ylim([0.5 1]); line([0 0], ylim, 'color', 'k', 'LineWidth', 2); 
   myPrint('Fig2F'); ;
   figure(f2); legend off;  
   set(f2, 'units', 'normalized','outerposition', [0 0 1 1]); xlim([-30 30]); xticks([-30 -20 -10 0 10 20 30]);  line([0 0], ylim, 'color', 'k', 'LineWidth', 2); 
   myPrint('Fig2F1'); ;

disp('done');

%% Figure 3-1  Basic simulation

clear; close all hidden; clc
R = GenerateSimulation;
figure; Show_OffersTaken(R); myPrint('Fig-2B');
pEarn = Calculate_pEarn(R);
figure; Show_pEarn(pEarn, R); myPrint('Fig-2C');
figure; H = Show_AttritionBias(R, 'maxW', 40); myPrint('Fig-2D');
figure; plot(1:40, H(10,:) , 'm', 1:40, H(20,:), 'k', 'LineWidth', 2); 
   legend('10s', '20s'); xlabel('Distribution over W_0'); ylabel('proportion'); ylim([0 0.15]); title('Attrition bias'); 
   FigureLayout; yticks([0 0.1]); myPrint('Fig-2D1');
PEV = Calculate_pEarnXvalue(R);
[f1,f2] = Show_pEarnXvalue(PEV);
figure(f1); legend off; axis square; ylim([0 1]); xlim([-15 20]); line([0 0], ylim, 'color', 'k', 'LineWidth', 2); FigureLayout; myPrint('Fig-2E');
figure(f2); legend off; ylim([-0.1 0.8]); yticks([0 0.4 0.8]);
set(f2, 'units', 'normalized','outerposition', [0 0 0.5 0.5]); xlim([-15 20]); line([0 0], ylim, 'color', 'k', 'LineWidth', 2); FigureLayout; myPrint('Fig-2F');
disp('done');

%% Figure 3-2 Basic simulation no OZ
clear; close all hidden; clc

R = GenerateSimulation('offerEnterFunction', @(x)true(size(x)));
figure; Show_OffersTaken(R); myPrint('Fig-2G');

pEarn = Calculate_pEarn(R);
figure; Show_pEarn(pEarn, R); myPrint('Fig-2H');
figure; H = Show_AttritionBias(R, 'maxW', 40); myPrint('Fig-2I');
figure; plot(1:40, H(10,:) , 'm', 1:40, H(20,:), 'k', 'LineWidth', 2); 
    legend('10s', '20s'); xlabel('Distribution over W_0'); ylabel('proportion'); ylim([0 0.15]);title('Attrition bias'); 
    FigureLayout; yticks([0 0.1]); myPrint('Fig-2I1');
PEV = Calculate_pEarnXvalue(R);
[f1,f2] = Show_pEarnXvalue(PEV); 
figure(f1); legend off; axis square; ylim([0 1]); xlim([-15 20]); line([0 0], ylim, 'color', 'k', 'LineWidth', 2); FigureLayout; myPrint('Fig-2J');
figure(f2); legend off; ylim([-0.1 0.8]); set(f2, 'units', 'normalized','outerposition', [0 0 0.5 0.5]); xlim([-15 20]); line([0 0], ylim, 'color', 'k', 'LineWidth', 2); FigureLayout; myPrint('Fig-2K');

disp('done');
%% Figure 03 
clear; close all hidden; clc
SCout = Test_Range(10, 'showpEarnXvalueFigures', false);
mdl = fitlm(SCout.sunkCost(:), SCout.attritionBias(:))

myPrintAll('Fig03');
close all hidden
disp('done');
%% Figure 04 Quit Threshold SLOPE
clear; close all hidden; clc

R = GenerateSimulation('quitThresholdSlope', 1, 'quitThresholdStartFactor', 1.0);
pEarn = Calculate_pEarn(R);
figure; Show_pEarn(pEarn,R); legend off; title('QT slope = -1'); myPrint('Fig-04A2');
figure; Show_AttritionBias(R, 'maxW', 40); title('QT slope = -1'); myPrint('Fig-04A3');
%
R = GenerateSimulation('quitThresholdSlope', 0, 'quitThresholdStartFactor', 1.0);
pEarn = Calculate_pEarn(R);
figure; Show_pEarn(pEarn,R); legend off; title('QT slope = 0; QT=Offer'); myPrint('Fig-04B2');
figure; Show_AttritionBias(R, 'maxW', 40); title('QT slope = 0; QT=Offer'); myPrint('Fig-04B3');
%
R = GenerateSimulation('quitThresholdSlope', 0, 'quitThresholdStartFactor', 0.0);
pEarn = Calculate_pEarn(R);
figure; Show_pEarn(pEarn,R); legend off; title('QT slope = 0; QT=0'); myPrint('Fig-04C2');
figure; Show_AttritionBias(R, 'maxW', 40); title('QT slope = 0; QT=0'); myPrint('Fig-04C3');
%
R = GenerateSimulation('quitThresholdSlope', -1);
pEarn = Calculate_pEarn(R);
figure; Show_pEarn(pEarn,R); legend off; title('QT slope = +1'); myPrint('Fig-S3D2');
figure; Show_AttritionBias(R, 'maxW', 40); title('QT slope = +1'); myPrint('Fig-S3D3');
%
disp('done');
%% Fig 05 Limiting ability to wander away
close all; clear; clc
R = GenerateSimulation; 
figure; pEarn = Calculate_pEarn(R); Show_pEarn(pEarn, R);  title('base'); legend off;  myPrint('Fig-05A1');
figure; Show_WanderingNbyOffer(R, 'maxN', 60); 
myPrint('Fig-05A2');

R = GenerateSimulation('quitThresholdSlope', 0);
figure; pEarn = Calculate_pEarn(R); Show_pEarn(pEarn, R);  title('quitThresholdSlope = 0/s'); legend off;  myPrint('Fig-05B1');
figure; Show_WanderingNbyOffer(R, 'maxN', 60);   
myPrint('Fig-05B2');

R = GenerateSimulation('maxNdeviation', 0);
figure; pEarn = Calculate_pEarn(R); Show_pEarn(pEarn, R);  title('\Delta{}W <= 0'); legend off;   myPrint('Fig-05C1');
figure; Show_WanderingNbyOffer(R, 'maxN', 60); 
myPrint('Fig-05C2');

R = GenerateSimulation('maxNdeviation', 0, 'quitThresholdSlope', 0);
figure; pEarn = Calculate_pEarn(R); Show_pEarn(pEarn, R);  title('quitThresholdSlope = 0/s & \Delta{}W <= 0'); legend off;  myPrint('Fig-05D1');
figure; Show_WanderingNbyOffer(R, 'maxN', 60);  
myPrint('Fig-05D2');


%%

%% Figure 7
clear; close all hidden; clc
SCout = Test_Range(20, 'showMainFigure', false, 'showAttritionBiasFigures', false, 'showpEarnXvalueFigures', false);
save SCout SCout;
%%
popdir all
clear; close all; clc

load SCout
figure
[nS,nN,nW] = size(SCout.temperature);  nS = nS*nN;
X = repmat(SCout.sigmaW, nS, 1); X = X(:);
Y = SCout.temperature; Y = Y(:);
g0 = fittype('a + b/x');
[f0,gof1] = fit(Y,X,g0);
xW = 0:0.01:1;
plot(Y, X, 'ko', xW, f0(xW), 'r-');
legend('data',sprintf('fit: %.2f + %.2f/x', f0.a, f0.b));
xlabel('Tangent of the probit fit at threshold [\tau]');
ylabel('\sigma_W');
ylim([0 20]); xlim([0 1]);
FigureLayout

Show_Range(SCout, f0);
myPrintAll('Fig07');
disp('done');
%% Figure 8
clear; close all; clc; 

pushdir('BMS');
load('dataset.mat', 'dataset');

Science_waitzoneSunkCosts(dataset, 'mousePrimaryEarly1to30');
Science_waitzoneSunkCosts(dataset, 'rat1zone');

BMS_ShowAccrual;
popdir;


SCout1 = Test_DecisionTimeWZ('decisionTimeWZ_hardset', true);
Show_DecisionTimeWZTestResult(SCout1);

SCout2 = Test_DecisionTimeWZ('decisionTimeWZ_hardset', false);
Show_DecisionTimeWZTestResult(SCout2);

myPrintAll('Fig08');
%%
close all hidden
disp('Completed');
%%
function myPrint(fn)
disp(fn);
print(sprintf('Figures/%s', fn), '-dsvg');
print(sprintf('Figures/%s', fn), '-dpng');
end

function myPrintAll(fn)
f = findobj('Type', 'figure');
for iF = 1:length(f)
    figure(f(iF)); myPrint(sprintf('%s-%d', fn, iF)); 
end
end