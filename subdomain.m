%function subdomain()
clear, clc
%% Definition of print and plot functions

%% Begin of main
SD = load_list('list.xlsx');





fid = fopen('public/covvar.html', 'w');
fprintf(fid, '<head><title>Covariance</title></head>');
fprintf(fid, '<h1><a href="">Covariance and Correlation</a><a href="../">Home</a></h1>');
fprintf(fid, '<link rel="stylesheet" type="text/css" href="main.css">');
fprintf(fid, '<style type="text/css">img{height:450;}</style>');

fprintf(fid, '<table border=1>');
fprintf(fid, '<tr><th>Subdomain</th> <th>Covariance</th> <th>Correlation</th> <th>Cronbach''s alpha</th> </tr>');

fields = fieldnames(SD);
for i_toplot = 1:length(fields)
    sd = fields{i_toplot};
    [arr, measures] = fetch_data(SD.(sd));
    if length(measures) > 1
        
        fprintf(fid, '<tr><th>%s</th>', sd);
        
        fprintf(fid, plotCov(arr, measures, sd));
        fprintf(fid, plotPairs(arr, measures, sd));
        fprintf(fid, '</tr>');
        disp(sd);
    end
end
fclose(fid);


%end

