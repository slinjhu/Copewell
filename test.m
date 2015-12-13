clear, clc
ids = natdir('data/*.csv');
for i = 1:length(ids)
    id = ids{i};
    
    fprintf('mapdraw("#map%s", "../data/%s.csv", "Measure %s");\n', id, id, id);
    
end