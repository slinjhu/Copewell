function save_data(filename, data)
T = readtable('../data_domain/all.csv');
T2 = T(:, 'fips');
T2{:, 'value'} = data;
writetable(T2, ['results/', filename], 'WriteRowNames', true);
