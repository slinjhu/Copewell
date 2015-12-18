function x = trunc_right(x)
% Truncation in right end using 3.5std
right_target = mean(x) + 3.5*std(x);
x(x > right_target) = right_target;
end