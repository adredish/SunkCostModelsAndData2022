%% Figure 1-3
% are reprinted from Sweis, Abram, et al 2018.

%% Figure 4  Basic simulation

clear; close all; clc
R = GenerateKepecsTest;
pEarn = CalculateKepecs_pEarn(R);
[S,C] = CalculateKepecs_SunkCostSlopes(pEarn,R);
[S0,C0] = CalculateKepecs_SunkCostMeans(pEarn,R);

figure; KPShow_pEarn(pEarn, R); 
print('Figures/Fig04A', '-dsvg');

figure; KPShow_SunkCostArea(S0,C0,R,'Mean p(earn)');
print('Figures/Fig04B', '-dsvg');

figure; KPShow_SunkCostSlopes(S,R);
print('Figures/Fig04C', '-dsvg');

figure; KPShow_SunkCostArea(S,C,R, 'Slopes');
print('Figures/Fig04D', '-dsvg');

% figure; KPShow_OffersTaken(R);
disp('done');
%% Figure 5: Simulation with p(enter) = 1.0
clear; close all; clc

R = GenerateKepecsTest('offerEnterFunction', @(x)ones(size(x)));
pEarn = CalculateKepecs_pEarn(R);
[S,C] = CalculateKepecs_SunkCostSlopes(pEarn,R);
[S0,C0] = CalculateKepecs_SunkCostMeans(pEarn,R);

figure; KPShow_pEarn(pEarn, R);
print('Figures/Fig05A', '-dsvg');

figure; KPShow_SunkCostArea(S0,C0,R,'Mean p(earn)');
print('Figures/Fig05B', '-dsvg');

figure; KPShow_SunkCostSlopes(S,R);
print('Figures/Fig05C', '-dsvg');

figure; KPShow_SunkCostArea(S,C,R, 'Slopes');
print('Figures/Fig05D', '-dsvg');

figure; KPShow_OffersTaken(R);
print('Figures/Fig05E', '-dsvg');

disp('done');
%% Quit Threshold SLOPE
clear; close all; clc

R = GenerateKepecsTest('quitThresholdSlope', 1, 'quitThresholdStartFactor', 1.0);
pEarn = CalculateKepecs_pEarn(R);
[S] = CalculateKepecs_SunkCostSlopes(pEarn,R);
figure; KPShow_SunkCostSlopes(S,R); print('Figures/Fig06A', '-dsvg');
figure; KPShow_pEarn(pEarn,R); print('Figures/Fig06B', '-dsvg');

R = GenerateKepecsTest('quitThresholdSlope', 0, 'quitThresholdStartFactor', 1.0);
pEarn = CalculateKepecs_pEarn(R);
[S] = CalculateKepecs_SunkCostSlopes(pEarn,R);
figure; KPShow_SunkCostSlopes(S,R); legend off; print('Figures/Fig06C', '-dsvg');
figure; KPShow_pEarn(pEarn,R); legend off; print('Figures/Fig06D', '-dsvg');

R = GenerateKepecsTest('quitThresholdSlope', 0, 'quitThresholdStartFactor', 0.0);
pEarn = CalculateKepecs_pEarn(R);
[S] = CalculateKepecs_SunkCostSlopes(pEarn,R);
figure; KPShow_SunkCostSlopes(S,R); legend off; print('Figures/Fig06E', '-dsvg');
figure; KPShow_pEarn(pEarn,R); legend off; print('Figures/Fig06F', '-dsvg');
disp('done');
%% FIGURE 7: changing sigma N
clear; close all; clc
KPTest_ChangingSigmaN();
figure(1); print('Figures/Fig07A', '-dsvg'); 
F = findobj('type', 'figure');
for iF = 1:length(F)
    if (get(F(iF), 'Number')>1)
        print(F(iF), sprintf('Figures/Fig07-%d', iF), '-dsvg');
    end
end
disp('done');
%% FIGURE 8: changing sigma W
clear; close all; clc
KPTest_ChangingSigmaW();
figure(1); print('Figures/Fig08A', '-dsvg'); 
F = findobj('type', 'figure');
for iF = 1:length(F)
    if (get(F(iF), 'Number')>1)
        print(F(iF), sprintf('Figures/Fig08-%d', iF), '-dsvg');
    end
end
disp('done');

%% Figure 12
clear; close all; clc
KPTest_DecisionTimeWZ()
figure(1); ylim([0 0.025]); yticks([0 0.025]); KPFigureLayout
print('Figures/Fig12A', '-dsvg');
figure(2); ylim([0 0.05]); yticks([0 0.05]);KPFigureLayout
print('Figures/Fig12B', '-dsvg');

%% Figure 14/15
clear; close all; clc
R = GenerateKepecsTest('maxOffer', 15);
figure; KPShow_OffersTaken(R);
print('Figures/Fig14A', '-dsvg');

pEarn = CalculateKepecs_pEarn(R); 
figure; KPShow_pEarn(pEarn,R); legend off;  KPFigureLayout;
print('Figures/Fig14B', '-dsvg');
[S0,C0] = CalculateKepecs_SunkCostMeans(pEarn,R);
figure; KPShow_SunkCostArea(S0,C0,R,'Mean p(earn)'); KPFigureLayout;
print('Figures/Fig14C', '-dsvg');

[S,C] = CalculateKepecs_SunkCostSlopes(pEarn,R);
figure; KPShow_SunkCostSlopes(S,R); KPFigureLayout
print('Figures/Fig14D', '-dsvg');
figure; KPShow_SunkCostArea(S,C,R, 'accept all 1-15s offers'); KPFigureLayout
print('Figures/Fig14E', '-dsvg');

R = GenerateKepecsTest('maxOffer', 15, 'offerEnterFunction', @(x)ones(size(x)));
figure; KPShow_OffersTaken(R);
print('Figures/Fig15A', '-dsvg');

pEarn = CalculateKepecs_pEarn(R); 
figure; KPShow_pEarn(pEarn,R); legend off;  KPFigureLayout;
print('Figures/Fig15B', '-dsvg');
[S0,C0] = CalculateKepecs_SunkCostMeans(pEarn,R);
figure; KPShow_SunkCostArea(S0,C0,R,'Mean p(earn)'); KPFigureLayout;
print('Figures/Fig15C', '-dsvg');

[S,C] = CalculateKepecs_SunkCostSlopes(pEarn,R);
figure; KPShow_SunkCostSlopes(S,R); KPFigureLayout
print('Figures/Fig15D', '-dsvg');
figure; KPShow_SunkCostArea(S,C,R, 'S'); KPFigureLayout
print('Figures/Fig15E', '-dsvg');

%% FIGURE 16
clear; close all; clc
R = GenerateKepecsTest('quitThresholdSlope', -1);
pEarn = CalculateKepecs_pEarn(R);
[S0,C0] = CalculateKepecs_SunkCostMeans(pEarn,R);
[S,C] = CalculateKepecs_SunkCostSlopes(pEarn,R);

figure; KPShow_pEarn(pEarn,R); legend('location', 'northeast');
print('Figures/Fig16A', '-dsvg');
figure; KPShow_SunkCostArea(S0,C0,R,'Mean p(earn)'); KPFigureLayout;  legend('location', 'northwest');
print('Figures/Fig16B', '-dsvg');
figure; KPShow_SunkCostSlopes(S,R); legend('location', 'northeast');
print('Figures/Fig16C', '-dsvg');
figure; KPShow_SunkCostArea(S,C,R,'Slopes'); KPFigureLayout; legend('location', 'southwest');
print('Figures/Fig16D', '-dsvg');

%% FIGURE 18
clear; close all; clc
R = GenerateKepecsTest;
PEV = CalculateKepecs_pEarnXvalue(R);
KPShow_pEarnXvalue(PEV);
print('Figures/Fig18', '-dsvg');
