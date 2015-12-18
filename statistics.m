clear, clc, close all

data_name = 'data_scaled';
fid = fopen(sprintf('public/%s.csv', data_name), 'w');
fprintf(fid, 'Measure, # entires, # zeros, Min, Max, Mean, Median, Std, Mean/Median, Std/Mean, Skewness\n');

ids = natdir([data_name, '/*.csv']);
for i = 1:length(ids)
    id = ids{i};

    % load data
    filename = sprintf('%s/%s.csv', data_name, id);
    T = readtable(filename);
    data = T{:,'value'};
    
    % calculate numbers
    fprintf(fid, '%s', id);
    fprintf(fid, ',%d', length(data));
    fprintf(fid, ',%d', sum(data==0));
    fprintf(fid, ',%3g', min(data));
    fprintf(fid, ',%3g', max(data));
    fprintf(fid, ',%3g', mean(data));
    fprintf(fid, ',%3g', median(data));
    fprintf(fid, ',%1.2f', std(data));
    fprintf(fid, ',%1.2f', mean(data) / median(data));
    fprintf(fid, ',%1.2f', std(data) / mean(data));
    fprintf(fid, ',%1.2f', skewness(data));
    fprintf(fid, '\n');
    
end
