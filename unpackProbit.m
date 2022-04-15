function [threshold, temperature] = unpackProbit(b)
threshold = -b(1)/b(2);
temperature = glmval(b, threshold-0.5, 'probit') - glmval(b, threshold+0.5, 'probit');
end