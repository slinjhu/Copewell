function x = trunc_both(x)
% Truncation in both ends using 3.5 std
right_target = mean(x) + 3.5*std(x);
left_target = mean(x) - 3.5*std(x);
x(x > right_target) = right_target;
x(x < left_target) = left_target;
end