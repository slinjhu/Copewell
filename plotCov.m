 function toprint = plotCov(arr, measures, subdomain)
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
        format_img = @(filename) sprintf('<a href="%s" target=_blank><img src="%s"></a>', filename, filename);
        toprint = sprintf('<td>%s</td>', format_img(filelink));
    end