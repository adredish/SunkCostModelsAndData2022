function imagescWnan(varargin)
% imagescWnan - draws an imagesc but shows nans as W
% imagescWnan(z) = imagesc(z)
% imagescWnan(x,y,z) = imagesc(x,y,z)
%
% does this by setting alpha(nans) to 0 and using a white background

switch(nargin)
    case 1
        z = varargin{1};
        x = 1:size(z,1);
        y = 1:size(z,2);
    case 3
        x = varargin{1};
        y = varargin{2};
        z = varargin{3};
    otherwise
        error('unknown call to imagescWnan');
end               

imAlpha = ones(size(z));
imAlpha(isnan(z)) = 0;
imagesc(y,x,z, 'AlphaData', imAlpha);

end

