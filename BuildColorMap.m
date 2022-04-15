function c = BuildColorMap(n,m)

%c = jet(n); c = c(end:-1:1,:); c = c.^3;

%c = varycolor(n-1);
if nargin==1
    m = floor(n/2);
end

r = [zeros(1,m), linspace(0,1,n-m)];
g = [linspace(1,0,m).^2, zeros(1,n-m)];
b = [linspace(0,1,m), linspace(1,0,n-m)];

c = [r;g; b]';
c=vertcat([0 0 0], c);


