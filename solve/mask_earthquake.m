% Remove counties with little earthquake event. 
clear, clc
%% Get event data
T = readtable('../data_domain/all.csv');
fips = T(T.Event>0.2, 'fips');

files = dir('results_earthquake/*.csv');
for i = 1:length(files)
    filename = ['results_earthquake/', files(i).name];
    T = readtable(filename);
    T = innerjoin(T, fips);
    writetable(T, filename);
end