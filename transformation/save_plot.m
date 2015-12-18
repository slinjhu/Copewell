function save_plot(fid, filename)
fprintf(fid, td_wrap_image(filename));
if ~exist(filename, 'file')
    saveas(gcf, filename);
end

end