function [baseSlope, sunkNess, groupName, Wwz, Woz] = BMS0(f0, species)

Z = load('BMS/MasterDataSet2');
Z0 = load('BMS/accrualdata');

Z.wzTemp = Z.probitWZTemperature; Z.Wwz = f0(Z.wzTemp);
Z.ozTemp = Z.probitOZTemperature; Z.Woz = f0(Z.ozTemp);

%k = true(size(Z.group));
k = Z0.cohort=="plos bio" | Z0.cohort=="pnas" | Z0.cohort=="creb" | Z0.cohort=="nick, colin, & sophie" | Z0.cohort=="yannick & brandy";
k = k & Z0.species==species;
uG = unique(Z.group(k)); nG = length(uG);
for iG = 1:nG
    baseSlope{iG} = Z.slopeOf0sAlreadyWaited(Z.group==uG(iG));
    sunkNess{iG} = Z.sunkness(Z.group==uG(iG));
    groupName{iG} = uG(iG);
    
    Wwz{iG} = Z.Wwz(Z.group==uG(iG));    
    Woz{iG} = Z.Woz(Z.group==uG(iG));
end


