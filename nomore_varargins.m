function nomore_varargins(V)

if ~isempty(V)
    fprintf('incompletely processed varargins:\n')
    for iV = 1:2:length(V)
        fprintf('%s', V(iV));        
        disp(V(iV+1));
    end
    error('incompletely processed varargins');
end