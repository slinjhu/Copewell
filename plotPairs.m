 function toprint = plotPairs(arr, measures, subdomain)
        filelink = sprintf('pairs/%s.jpg', subdomain);
        filepath = ['public/', filelink];
        if ~exist(filepath, 'file')
            clf, hold on;
            corrplot(arr, 'varNames', measures);
            saveas(gcf, filepath);
        end
        format_img = @(filename) sprintf('<a href="%s" target=_blank><img src="%s"></a>', filename, filename);
        
        toprint = sprintf('<td>%s</td>', format_img(filelink));
    end