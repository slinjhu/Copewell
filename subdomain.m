%function subdomain()
clear, clc
%! rm public/covariance/*.jpg
%! rm public/pairs/*.jpg

%% Begin of main
SD = load_list('list.xlsx');

fid = fopen('public/covvar.html', 'w');
fprintf(fid, '<head><title>Covariance</title></head>');
fprintf(fid, '<h1><a href="">Covariance and Correlation</a><a href="../">Home</a></h1>');
fprintf(fid, '<link rel="stylesheet" type="text/css" href="main.css">');
fprintf(fid, '<style type="text/css">img{height:300;}</style>');

fprintf(fid, '<table border=1>');
fprintf(fid, '<tr> <th>Covariance</th> <th>Pearson''s Correlation</th> <th>Cronbach''s alpha</th> </tr>');

fields = fieldnames(SD);
for i_toplot = 1:length(fields)
    sd = fields{i_toplot};
    [arr, measures] = fetch_data(SD.(sd));
    if length(measures) > 1
        
        fprintf(fid, '<tr>', sd);
        
        filelink = plotCov(arr, measures, sd);
        fprintf(fid, td_wrap_image(filelink));
        filelink = plotPairs(arr, measures, sd);
        fprintf(fid, td_wrap_image(filelink));
        
        % calculate Cronbach's alpha
        K = size(arr, 2);
        alpha = (K/(K-1)) * (1 - sum(std(arr).^2 ) / std(sum(arr, 2))^2 );
        fprintf(fid, td_wrap_number(0.7, alpha));
        
        fprintf(fid, '</tr>');
        disp(sd);
    end
end
fclose(fid);


%end

