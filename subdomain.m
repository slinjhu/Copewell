function subdomain()
%% Definition of print and plot functions
format_img = @(filename) sprintf('<a href="%s" target=_blank><img src="%s"></a>', filename, filename);
    function plotCov(arr, measures, subdomain)
        filelink = sprintf('covariance/%s.jpg', subdomain);
        filepath = ['public/', filelink];
        if ~exist(filepath, 'file')
            N = size(arr, 2);
            clf, hold on;
            imagesc(1:N, 1:N, cov(arr));
            colorbar
            set(gca, 'FontSize', 20);
            set(gca, 'XTick', 1:N);
            set(gca, 'YTick', 1:N);
            set(gca, 'XTickLabel', measures);
            set(gca, 'YTickLabel', measures);
            title(subdomain);
            saveas(gcf, filepath);
        end
        fprintf(fid, '<td>%s</td>', format_img(filelink));
    end

    function plotPairs(arr, measures, subdomain)
        filelink = sprintf('pairs/%s.jpg', subdomain);
        filepath = ['public/', filelink];
        if ~exist(filepath, 'file')
            clf, hold on;
            corrplot(arr, 'varNames', measures);
            saveas(gcf, filepath);
        end
        fprintf(fid, '<td>%s</td>', format_img(filelink));
    end
    function [arr, measureList] = fetch_data(measures)
        measureList = strsplit(measures);
        for i = 1:length(measureList)
            id = measureList{i};
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
%% Begin of main
toplot = {{'3 4 5 6', 'Economy'};
    {'7 8 9 10', 'Education'};
    {'11 12 14 68', 'Food and Water'};
    {'15 16 17 18', 'Government'};
    {'19 20 21 22', 'Housing'};
    {'23 24 25a 25b 26', 'Medicine and Healthcare'};
    {'30 31 32', 'Nurturing and Care'};
    {'42 43 44', 'Well being'};
    {'45 51 52 48 49 50a 50b 54', 'Engineered Systems'};
    {'55 56 57 60', 'Vulnerability'};
    {'64 65 66 67 69', 'Deprivation'};
    {'73 74 75 76 77 78', 'Social Cohesion'}};

fid = fopen('public/covvar.html', 'w');
fprintf(fid, '<head><title>Covariance</title></head>');
fprintf(fid, '<h1><a href="">Covariance and Correlation</a><a href="../">Home</a></h1>');
fprintf(fid, '<link rel="stylesheet" type="text/css" href="main.css">');
fprintf(fid, '<style type="text/css">img{height:350;}</style>');

fprintf(fid, '<table border=1>');
fprintf(fid, '<tr><th>Subdomain</th> <th>Covariance</th> <th>Correlation</th> <th>Cronbach''s alpha</th> </tr>');

for i_toplot = 1:length(toplot)
    [arr, measures] = fetch_data(toplot{i_toplot}{1});
    subdomain = toplot{i_toplot}{2};
    fprintf(fid, '<tr><th>%s</th>', subdomain);
    
    plotCov(arr, measures, subdomain);
    plotPairs(arr, measures, subdomain);
    fprintf(fid, '</tr>');
    disp(subdomain);
end
fclose(fid);


end

