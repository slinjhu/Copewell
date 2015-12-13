clear, clc
ids = natdir('data/*.csv');
for i = 1:length(ids)
    id = ids{i};
    
    fprintf('<option value="%s">Measure %s</option>\n', id, id);
    
end