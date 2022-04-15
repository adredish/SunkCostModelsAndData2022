function y = jitter(x, varargin)

% adds random jitter around samples
%
% parms
%   randomizer = 'randn'; also knows rand
%   multiplier = 0.1;

randomizer = 'randn';
multiplier = 0.025;
process_varargin(varargin);

switch randomizer
    case 'randn'
        y = x + multiplier*randn(size(x));
    case 'rand'
        y = x + multiplier*(rand(size(x)-0.5));
    otherwise
        error('unknown distribution randomizer');
end
