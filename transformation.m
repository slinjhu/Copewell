% Study transformation methods.
function transformation()
clc
%% Define scale and transformation functions
scale01 = @(x)(x - min(x)) / range(x); % scale to [0,1]
    function x = trunc_right(x)
        % Truncation in right end using 3std
        right_target = mean(x) + 3*std(x);
        x(x > right_target) = right_target;
    end
    function x = trunc_both(x)
        % Truncation in both ends using 3 std
        right_target = mean(x) + 3*std(x);
        left_target = mean(x) - 3*std(x);
        x(x > right_target) = right_target;
        x(x < left_target) = left_target;
    end
    function x = trans_log(x)
        % Log transform positive data and set others to zero
        x(x<0) = 0;
        x(x>0) = scale01(log(x(x>0)));
    end
    function [x, lambda] = trans_boxcox(x)
        % Replace negative with zero, and transform using Box Cox
        flag_pos = (x>0);
        [xpos, lambda] = boxcox(x(flag_pos));
        x(~flag_pos) = min(xpos);
        x(flag_pos) = xpos;
    end

%% Define function in printing html
get_style = @()'<style type="text/css">img{height:200; margin:3px;}</style>';
    function print_number(name, value, filter)
        flag = value > filter;
        if flag
            bgcolor = 'bgcolor="#5ecc91"';
        else
            bgcolor = '';
        end
        fprintf(fid, '<td %s>%s</br>%1.1f</td>', bgcolor, name, value);
    end

%% Define the plotting function
    function plot_hist(data, titlename)
        clf, hold on
        hist(data, 100);
        h = findobj(gca,'Type','patch');
        h.FaceColor = [0.5 0.5 1];
        h.EdgeColor = [0.2 0.2 0.6];
        
        scatter(mean(data), 0, 'MarkerEdgeColor','k', 'MarkerFaceColor','r');
        scatter(mean(data) + 3*std(data), 0, 'MarkerEdgeColor','k', 'MarkerFaceColor','y');
        scatter(mean(data) - 3*std(data), 0, 'MarkerEdgeColor','k', 'MarkerFaceColor','y');
        set(gca, 'XLim', [min(data), max(data)]);
        set(gca, 'FontSize', 20);
        title(sprintf('[%s] %s',id, titlename));
    end
    function save_plot(type)
        filelink = sprintf('hist/%s_%s.jpg', type, id);
        filepath = ['public/', filelink];
        if ~exist(filepath, 'file')
            saveas(gcf, filepath);
        end
        td = sprintf('<td><a href="%s" target=_blank><img src="%s"></a></td>', filelink, filelink);
        fprintf(fid, td);
    end
%% Load data and try transformations
fid = fopen('public/transformation.html', 'w');
fprintf(fid, get_style());
fprintf(fid, '<table border="1">');
ids = natdir('data/*.csv');

for i = 1:length(ids)
    id = ids{i};
    disp(id);
    filename = sprintf('data/%s.csv', id);
    T = readtable(filename);
    data = T{:,'value'};
    
    %% Print
    fprintf(fid, '<tr>');    
    fprintf(fid, '<th>ID</br>%s</th>', id);
    print_number('Coef. Var', std(data)/mean(data), 1);
    print_number('Skew', skewness(data), 1);
    
    % Original
    plot_hist(data, 'Original');
    save_plot('org');
    
    % Box-Cox and +- 3std
    [bcdata, lambda] = trans_boxcox(data);
    plot_hist(trunc_both(bcdata), 'Box-Cox & truncated with \pm3std');
    save_plot('boxcoxstd');
    
    % +3std
    plot_hist(trunc_right(data), 'Truncated with +3std');
    save_plot('+3std');
    
    % +-3std
    plot_hist(trunc_both(data), 'Truncated with \pm3std');
    save_plot('+-3std');
    
    % log
    plot_hist(trans_log(data), 'Log transformed');
    save_plot('log');
    
    % Box-Cox
    plot_hist(bcdata, sprintf('Box Cox (\\lambda=%1.3f)', lambda));
    save_plot('boxcox');

    fprintf(fid, '</tr>');
    
end
fprintf(fid, '</table>');
fclose(fid);
end