function Show_SunkCostBubble(pEarn, R)

figure; 
[x,y] = Show_pEarn(pEarn,R); 
x0 = x(1,:); yM = max(y,[],1); ym = y(1,:);
k = ~isnan(x0 + ym + yM); x0 = x0(k); yM = yM(k); ym = ym(k);
h = fill([x0 x0(end:-1:1)], [yM ym(end:-1:1)], 'k', 'FaceAlpha', 0.1); 
legend off; axis square; FigureLayout; 

end