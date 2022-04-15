function h = ShadedErrorbar(X, Y, E, varargin)

% ShadedErrorbar(X, Y, E, parms)
% 
% INPUTS 
%   X = x-data
%   Y = y-data
%   E = errors (assumed to be symmetric)
%   
% PARMS
%   color = 'k'
%   marker = '.'
%   L = E
%   U = E
%  
% If you want non-symmetric errorbars, redefine L and U.

color = 'k';
marker = '.';
lineStyle = '-';
lineWidth = 2;
L = E;
U = E;
process_varargin(varargin);

% make sure all are n x 1
if size(X,1)==1, X = X'; end
if size(Y,1)==1, Y = Y'; end
if size(L,1)==1, L = L'; end
if size(U,1)==1, U = U'; end

H = ishold; 
hold on

keep = ~isnan(X + L + U);
X = X(keep); L = Y(keep)-L(keep); U = Y(keep)+U(keep); Y = Y(keep);
h0 = patch([X; X(end:-1:1); X(1)], [L; U(end:-1:1); L(1)], color);
set(h0, 'FaceColor', color, 'EdgeColor', 'None', 'FaceAlpha', 0.25);
h = plot(X, Y, 'Color', color, 'Marker', marker, 'LineWidth', lineWidth, 'LineStyle', lineStyle);

if H; hold on; else hold off; end
	


