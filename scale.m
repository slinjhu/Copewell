clear, clc, close all
!rm data_scaled/*.csv
ids = natdir('data/*.csv');
for i = 1:length(ids)
    id = ids{i};
    filename = sprintf('data/%s.csv', id);
    outfilename = sprintf('data_scaled/%s.csv', id);
    
    T = readtable(filename);
    flag_neg = (T{:, 'value'} <= 0);
    T(flag_neg, :) = [];
    
    x = T{:, 'value'};
    
    % Box Cox transformation    
    [x, lambda] = boxcox(x);
    
    % Truncation in both ends using 3 std
    right_target = mean(x) + 3.5*std(x);
    left_target = mean(x) - 3.5*std(x);
    x(x > right_target) = right_target;
    x(x < left_target) = left_target;
    
    % scale to [0,1]
    x = (x - min(x)) / range(x);
    
    T{:, 'value'} = x;
    writetable(T, outfilename);
    disp(filename);
end

