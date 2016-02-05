function x = trans_log(x)
% Log transform positive data and remove others
x(x<0) = [];
x(x==0) = [];

x = log(x);
x = (x - min(x)) / range(x); % scale to [0,1]
end