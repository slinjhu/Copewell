clear, clc, close all
!rm ../data_scaled/*.csv

[~,~,raw] = xlsread('../list.xlsx');
for i = 2:size(raw, 1)
    
    direction = raw{i, 5};
    id = num2str(raw{i, 1});
    filename = sprintf('../data/%s.csv', id);
    outfilename = sprintf('../data_scaled/%s.csv', id);
    
    T = readtable(filename);
    flag_neg = (T{:, 'value'} <= 0);
    T(flag_neg, :) = [];
    
    x = T{:, 'value'};
    if strcmp(id, '902')
        x = (x - min(x)) / range(x);
    else
        
        
        % Box Cox transformation
        [x, lambda] = boxcox(x);
        
        % Truncation in both ends using 3 std
        right_target = mean(x) + 3.5*std(x);
        left_target = mean(x) - 3.5*std(x);
        x(x > right_target) = right_target;
        x(x < left_target) = left_target;
        
        % scale to [0,1]
        x = (x - min(x)) / range(x);
        
        if direction == '-'
            x = 1 -x;
        end
    end
    T{:, 'value'} = x;
    writetable(T, outfilename);
    disp(filename);
end

