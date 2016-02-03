function filename = plotPairs(arr, measures, subdomain)
filename = sprintf('pairs/%s.jpg', subdomain);

if ~exist(filename, 'file')
    close all
    corrplot(arr, 'varNames', measures, 'testR', 'on');
    set(gcf, 'PaperPositionMode', 'Auto');
    saveas(gcf, filename);
end
end