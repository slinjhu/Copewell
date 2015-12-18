function filename = plotCov(arr, measures, subdomain)
filename = sprintf('covariance/%s.jpg', subdomain);

if ~exist(filename, 'file')
    N = size(arr, 2);
    close all, hold on;
    colormap jet
    imagesc(1:N, 1:N, cov(arr), [-0.05, 0.05]);
    colorbar
    set(gca, 'FontSize', 20);
    set(gca, 'XTick', 1:N);
    set(gca, 'YTick', 1:N);
    set(gca, 'XTickLabel', measures);
    set(gca, 'YTickLabel', measures);
    title(subdomain);
    saveas(gcf, filename);
end

end