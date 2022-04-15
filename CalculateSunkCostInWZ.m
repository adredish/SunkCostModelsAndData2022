function [pEarn,sunkNess] = CalculateSunkCostInWZ(varargin)

%fprintf('Calculating Sunk Cost in WZ...');

% [pEarn,sunkNess] = CalculateSunkCostInWZ(varargin)
%
%this function calculates a time invested X time remaining matrix of earn
%probability (pEarn) along with an overall measure of sunk cost (sunkNess).
%The sunk cost measure is the average difference in pEarn between X s time
%invested (2-29 s invested) and control (1 s invested). Positive values indicate
%evidence of sunk cost (with higher values indiacting stronger sunk cost).
%
%inputs:
%the following variables are needed:
%   1) offer = Offer delay for each WZ entry (1 X nEncounters)
%   2) timeSpentAtQuit = Time to quit for each WZ entry. NaN for earned
%                        encounters (1 X nEncounters)
%   3) isEarn = Logical indicating whether reward was earned (earn = true) 
%               for each encounter (1 X nEncounters)
%   4) isQuit = Logican indicating whether a quit occured (quit = true) 
%               for each encounter (1 X nEncounters)
%   5) maxD = Maximum delay
%
%these variables can be fields within a structure (with field names
%identical to the list above) or they can be separate vectors. IF
%VARIABLES ARE GIVEN AS SEPARATE VECTORS, THE ORDER IN WHICH THEY ARE GIVEN
%IS CRITICAL. 1st input = offer. 2nd input = timeSpentAtQuit. 3rd input =
%isEarn. 4th input = isQuit. 5th input = maxD.
%
%outputs:
%   1) pEarn = maxD X maxD matrix of pEarn. 1st dimension is time invested while
%              2nd dimension is time remaining
%   2) sunkNess = difference in pEarn between X s invested and control (1 s
%                 invested) averaged across X s invested


% % % % % % % % % % % % % % % % % % %
%                                   %
% Unpack variables & quality check  %    
%                                   %
% % % % % % % % % % % % % % % % % % % 

if nargin == 1  %input was a structure containing variables in fields
    R = varargin{1};
    
    fieldNames = {'offer','timeSpentAtQuit','isEarn','isQuit','maxD'};

    for iF = 1:length(fieldNames)
        curField = fieldNames{iF};
        assert(isfield(R,curField),'Incorrect field names in R');
    end
    
    offer = R.offer;
    timeSpentAtQuit = ceil(R.timeSpentAtQuit);
    isEarn = R.isEarn;
    isQuit = R.isQuit;
    maxD = R.maxD;
    
elseif nargin == 5   %input was 5 separate vectors (in correct order!)
    
    offer = varargin{1};
    timeSpentAtQuit = ceil(varargin{2});
    isEarn = varargin{3};
    isQuit = varargin{4};
    maxD = varargin{5};
    
else
    error('Must input: offer, timeSpentAtQuit, isEarn, isQuit, and maxD variables (separately or as fields in structure)')
end

assert(islogical(isEarn) & islogical(isQuit),'isEarn & isQuit must be logicals');
assert(sum(~isnan(timeSpentAtQuit)) == sum(isQuit),'timeSpentAtQuit & isQuit do not agree on # of quits');
assert(sum(isnan(timeSpentAtQuit)) == sum(isEarn),'timeSpentAtQuit & isEarn do not agree on # of earns');

% % % % % % % % % % % % % % % % % % %
%                                   %
% Get earn probability for offer    %    
% delay X time invested             %
%                                   %
% % % % % % % % % % % % % % % % % % % 

nT = length(offer);
didEarn = nan(nT,maxD,maxD); %encounters X offer delay X time invested

for iT = 1:nT
    if isEarn(iT)
        didEarn(iT,offer(iT),1:offer(iT)) = true;
    elseif isQuit(iT)
        if timeSpentAtQuit(iT) > 0
            didEarn(iT,offer(iT),1:timeSpentAtQuit(iT)) = false;
        end
    end
end


% % % % % % % % % % % % % % % % % % % % % % % 
%                                           %
% Get earn probability for time invested    %    
% X time waited                             %
%                                           %
% % % % % % % % % % % % % % % % % % % % % % % 

pEarn = nan(maxD,maxD); %time invested X time remaining

for iDelay = 1:maxD
    for tWaited = 1:(iDelay-1)
        tRemaining = iDelay - tWaited;
        pE = squeeze(nanmean(didEarn(:,iDelay,tWaited)));
        pEarn(tWaited,tRemaining) = pE;
    end
end

if nargout > 1
    % % % % % % % % % % %
    %                   %
    % Compute SunkNess  %
    %                   %
    % % % % % % % % % % %
    
    pEarnDiff = nan(maxD,1); %1st element = 1 s invested; 2nd element = 2 s invested...
    ctrlLine = pEarn(1,:); %all pEarn differences are taken from 1 s invested as a control line
    
    
    for iD = 1:(maxD-1) %1 s invested through 29 s invested
        curLine = pEarn(iD,:);
        curDelayDiff = curLine - ctrlLine;
        pEarnDiff(iD) = nanmean(curDelayDiff);
    end
    
    pEarnDiff(1) = nan; % this value will always be 0 because of ctrl slope definition
    sunkNess = nanmean(pEarnDiff);
end

%fprintf('DONE.\n');