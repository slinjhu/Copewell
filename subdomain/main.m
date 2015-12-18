clear, clc
%! rm covariance/*.jpg
%! rm pairs/*.jpg

%% Begin of main
SD = load_list('../list.xlsx');

fid = fopen('index.html', 'w');
fprintf(fid, '<head><title>Covariance</title></head>');
fprintf(fid, '<h1><a href="">Covariance and Correlation</a><a href="../">Home</a></h1>');
fprintf(fid, '<link rel="stylesheet" type="text/css" href="../main.css">');
fprintf(fid, '<style type="text/css">img{height:500;}</style>');

fprintf(fid, '<table border=1>');
fprintf(fid, '<tr> <th>Covariance</th> <th>Pearson''s Correlation</th> <th>Cronbach''s alpha</th> </tr>');

fields = fieldnames(SD);
for i_toplot = 1:length(fields)
    sd = fields{i_toplot};
    [arr, measures] = fetch_data(SD.(sd));
    if length(measures) > 1
        
        fprintf(fid, '<tr>', sd);
        
        filename = plotCov(arr, measures, sd);
        fprintf(fid, td_wrap_image(filename));
        filename = plotPairs(arr, measures, sd);
        fprintf(fid, td_wrap_image(filename));
        
        % calculate Cronbach's alpha
        K = size(arr, 2);
        alpha = (K/(K-1)) * (1 - sum(std(arr).^2 ) / std(sum(arr, 2))^2 );
        fprintf(fid, td_wrap_number(0.5, alpha));
        fprintf('%s\t%1.3f\n', sd, alpha);
        
        fprintf(fid, '</tr>');
    end
end
fclose(fid);


 

