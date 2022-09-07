function [H, AB] = Show_AttritionBias(R, varargin)

[H,AB, results] = Calculate_AttritionBias(R, varargin{:});

imagesc(H');
axis xy
hold on;
errorbar(1:30, results.mu, results.se, 'k');
xlabel('TimeSpent');
ylabel('W0');

caxis([0 0.1]);
C = colorbar;
C.Label.String = 'Proportion';
C.Label.Position(1) = 2;
C.Ticks = [0 0.1];

title(sprintf('Attrition slope = %.2f', AB));