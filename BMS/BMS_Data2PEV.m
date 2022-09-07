function PEV = BMS_Data2PEV(d)

n2invest = 15;
x = repmat(-30:30, n2invest,1);
y = nan(n2invest, 61);
for iV = 1:n2invest
    y(iV,:) = d.investedQuits.(sprintf('invested%d',iV));
end
ts = repmat((1:n2invest)', 1, 61);

PEV.pEarnV = y';
PEV.values = x(1,:);
PEV.TSQ = ts(:,1)';