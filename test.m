clear, close all, clc
addpath(genpath('.'));
SD = load_list('list.xlsx');
fields = fieldnames(SD);
for i_toplot = 2
    sd = fields{i_toplot};
    [arr, measures] = fetch_data(SD.(sd));
    
    %plotPairs(arr, measures, sd);
    plotCov(arr, measures, sd);
end


