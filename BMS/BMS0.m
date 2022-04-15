function [baseSlope, sunkNess, groupName, Wwz, Woz] = BMS0(f0)

Z = load('MasterDataSet2');

Z.wzTemp = Z.probitWZTemperature; Z.Wwz = f0(Z.wzTemp);
Z.ozTemp = Z.probitOZTemperature; Z.Woz = f0(Z.ozTemp);

uG = unique(Z.group); nG = length(uG);
for iG = 1:nG
    baseSlope{iG} = Z.slopeOf0sAlreadyWaited(Z.group==uG(iG));
    sunkNess{iG} = Z.sunkness(Z.group==uG(iG));
    groupName{iG} = uG(iG);
    
    Wwz{iG} = Z.Wwz(Z.group==uG(iG));    
    Woz{iG} = Z.Woz(Z.group==uG(iG));
end


