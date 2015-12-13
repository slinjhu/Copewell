clear, clc
!rm data_scaled/*.csv
ids = natdir('data/*.csv');
for i = 1:length(ids)
    id = ids{i};
    filename = sprintf('data/%s.csv', id);
    outfilename = sprintf('data_scaled/%s.csv', id);
    
    T = readtable(filename);
    data = T{:, 'value'};
    data(data<0) = 0;
    [data, lambda] = boxcox(data+eps);
    T{:, 'value'} = data;
    writetable(T, outfilename);
end

