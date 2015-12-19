function [arr, measureList] = fetch_data(measures)
measureList = strsplit(measures);
for i = 1:length(measureList)
    direction = measureList{i}(1);
    id = measureList{i}(2:end);
    filename = sprintf('data_scaled/%s.csv', id);
    
    T = readtable(filename);
    
    T.Properties.VariableNames{'value'} = ['measure', id];
    if i == 1
        Tall = T;
    else
        Tall = innerjoin(Tall, T);
    end
end
arr = table2array(Tall);
arr = arr(:, 2:end);
end