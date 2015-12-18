% Study transformation methods.
clear, clc
addpath(genpath('../'));
%% Load data and try transformations
fid = fopen('index.html', 'w');
fprintf(fid, '<head><title>Transformations</title></head>');
fprintf(fid, '<h1><a href="">Transformations</a><a href="../">Home</a></h1>');
fprintf(fid, '<link rel="stylesheet" type="text/css" href="../main.css">');
fprintf(fid, '<style type="text/css">img{height:220;}</style>');

fprintf(fid, '<table border="1">');
ids = natdir('../data/*.csv');

for i = 1:length(ids)
    id = ids{i};
    disp(id);
    filename = sprintf('../data/%s.csv', id);
    T = readtable(filename);
    data = T{:,'value'};
    
    %% Print
    fprintf(fid, '<tr>');
    
    % Original
    plot_hist(data, sprintf('[%s] Original',id) );
    save_plot(fid, sprintf('figures/%s_org.jpg', id));
    
    % Box-Cox and +- 3.5std
    [bcdata, lambda] = trans_boxcox(data);
    plot_hist(trunc_both(bcdata), sprintf('[%s] Box-Cox & truncated with \\pm3.5 std', id));
    save_plot(fid, sprintf('figures/%s_boxcoxstd.jpg', id));
    
    % +3.5std
    plot_hist(trunc_right(data), sprintf('[%s] Truncated with +3.5 std', id));
    save_plot(fid, sprintf('figures/%s_+3std.jpg', id));
    
    % +-3.5std
    plot_hist(trunc_right(data), sprintf('[%s] Truncated with \\pm3.5 std', id));
    save_plot(fid, sprintf('figures/%s_+-3std.jpg', id));
    
    % log
    plot_hist(trans_log(data), sprintf('[%s] Log transformed', id));
    save_plot(fid, sprintf('figures/%s_log.jpg', id));
    
    % Box-Cox
    plot_hist(bcdata, sprintf('[%s] Box Cox (\\lambda=%1.3f)', id, lambda));
    save_plot(fid, sprintf('figures/%s_boxcox.jpg', id));
    
    fprintf(fid, '</tr>');
    
end
fprintf(fid, '</table>');
fclose(fid);
