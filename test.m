clear, clc
ids = natdir('data/*.csv');
fid = fopen('test.html', 'w');
for i = 1:length(ids)
    id = ids{i};
    
    fprintf(fid, '<a href="data/%s.csv">%s</a>, ', id, id);
    
end
fclose(fid);