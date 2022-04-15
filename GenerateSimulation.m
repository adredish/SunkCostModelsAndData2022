function R = GenerateKepecsTest4(varargin)

%fprintf('Generating Kepecs Test...');

% --- parameters

% world
nOffers = 1e6;
maxOffer = 30;
varargin = process_varargin(varargin);

delayRange = 1:maxOffer; 

% agent
threshold = 18;
sigmaW = 5;
sigmaN = 3;
muN = 0;
maxNdeviation = inf;

quitThresholdStartFactor = 1.0; 
quitThresholdSlope = 1.0;

% % constant pQuit
% prob_Use_pQuitFunction = 0;
% pQuitFunction = [];  % to make an explicit pQuit function, use 1 input of offer length, so constant pquit = @(x)0.05

% offer enter function
offerEnterFunction = @(x)x > 0;

% delay to start
decisionTimeWZ_sigmaN = 0;
decisionTimeWZ_hardset = 0;
qTdecayThroughDT = true;
hungerW = 0;

varargin = process_varargin(varargin);
nomore_varargins(varargin);

% Stay/Skip
offer = ceil(rand(nOffers,1)*maxOffer);
W0 = threshold + randn(nOffers,1) * sigmaW + hungerW;

isStay = offerEnterFunction(W0-offer);
isSkip = ~isStay;

% Earn/Quit
isQuit = nan(size(offer));
isEarn = nan(size(offer));
TSQ = nan(size(offer));  % time spent at quit
TRQ = nan(size(offer));  % time remaining at quit

% fill W1 matrix
W1 = nan(nOffers, maxOffer);

for iO = 1:nOffers
    if isStay(iO)
        t = 1;
        W1(iO,t) = W0(iO);   
        qTwz = offer(iO) * quitThresholdStartFactor;
        done = false;
        
        while not(done)
            
            if (t > decisionTimeWZ_hardset && t > decisionTimeWZ_sigmaN) || qTdecayThroughDT
                qTwz = qTwz - 1 * quitThresholdSlope;
            end
           
            if t > decisionTimeWZ_sigmaN
                if t ==1
                    W1(iO,t) = W1(iO,t) + muN + randn*sigmaN;
                else
                    W1(iO,t) = W1(iO,t-1) + muN + randn*sigmaN;
                end
                if W1(iO,t) - W0(iO) > maxNdeviation
                    W1(iO,t) = maxNdeviation;
                end
            end
            timeLeft = offer(iO) - t;
            
            if timeLeft == 0 % earn
                isQuit(iO) = false; isEarn(iO) = true;
                done = true;
            end
            
            if (t > decisionTimeWZ_hardset) && (W1(iO,t) < qTwz) % quit
                isQuit(iO) = true; isEarn(iO) = false;
                TSQ(iO) = t; TRQ(iO) = timeLeft;
                done = true;
            end
            t = t + 1;
        end
    end
end

% package
R.offer = offer;
R.isStay = isStay;
R.isSkip = isSkip;
R.delayRange = delayRange;
R.threshold = threshold;
R.sigmaW = sigmaW;
R.sigmaN = sigmaN;

R.isQuit = isQuit;
R.isEarn = isEarn;
R.TSQ = TSQ;
R.TRQ = TRQ;

R.W0 = W0;
R.W1 = W1;

%fprintf('DONE.\n');