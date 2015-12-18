function plot_hist(data, titlename)
close all
hist(data, 100);
h = findobj(gca,'Type','patch');
h.FaceColor = [0.5 0.5 1];
h.EdgeColor = [0.2 0.2 0.6];
hold on
scatter(mean(data), 0, 'MarkerEdgeColor','k', 'MarkerFaceColor','r');
scatter(mean(data) + 3*std(data), 0, 'MarkerEdgeColor','k', 'MarkerFaceColor','y');
scatter(mean(data) - 3*std(data), 0, 'MarkerEdgeColor','k', 'MarkerFaceColor','y');
set(gca, 'XLim', [min(data), max(data)]);
set(gca, 'FontSize', 20);
title(titlename);
end