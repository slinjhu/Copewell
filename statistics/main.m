clear, clc, close all
addpath(genpath('../'));
data_name = 'data_scaled';
fid = fopen(sprintf('%s.html', data_name), 'w');
fprintf(fid, '<table border="1">');

ids = natdir(sprintf('../%s/*.csv', data_name));
for i = 1:length(ids)
    id = ids{i};
    if mod(i, 20) == 1
        fprintf(fid, ['<tr><th>ID</th><th># entries</th><th># zeros</th><th>Min</th><th>Max</th>'...
            '<th>Mean</th><th>Median</th><th>STD</th><th>Mean/Median</th><th>STD/Mean</th><th>Skewness</th><tr>']);
    end
    % load data
    filename = sprintf('../%s/%s.csv', data_name, id);
    T = readtable(filename);
    data = T{:,'value'};
    
    % calculate numbers
    
    fprintf(fid, '<tr><th>%s</th>', id);
    fprintf(fid, '<td>%d</td>', length(data));
    fprintf(fid, '<td>%d</td>', sum(data==0));
    fprintf(fid, '<td>%.2g</td>', min(data));
    fprintf(fid, '<td>%.2g</td>', max(data));
    fprintf(fid, '<td>%.2g</td>', mean(data));
    fprintf(fid, '<td>%.2g</td>', median(data));
    fprintf(fid, '<td>%1.2f</td>', std(data));
    fprintf(fid, '<td>%1.2f</td>', mean(data) / median(data));
    fprintf(fid, '<td>%1.2f</td>', std(data) / mean(data));
    fprintf(fid, '<td>%1.2f</td>', skewness(data));
    fprintf(fid, '</tr>\n');
    
end
fprintf(fid, '</table>');
