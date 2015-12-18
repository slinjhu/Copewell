function x = trans_log(x)
% Log transform positive data and set others to zero
x(x<0) = 0;
x(x>0) = log(x(x>0));
x = (x - min(x)) / range(x); % scale to [0,1]
end