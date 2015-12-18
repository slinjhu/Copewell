function filelink = plotPairs(arr, measures, subdomain)
filelink = sprintf('pairs/%s.jpg', subdomain);
filepath = ['public/', filelink];
if ~exist(filepath, 'file')
    close all
    corrplot(arr, 'varNames', measures, 'testR', 'on');
    saveas(gcf, filepath);
end
end