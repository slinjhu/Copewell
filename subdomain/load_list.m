function SD = load_list(filename)
to_ID = @(name) strrep(strtrim(name), ' ', '');
[~,~,raw] = xlsread(filename);
SD = [];
for i = 2:size(raw, 1)
    direction = raw{i, 5};
    id = num2str(raw{i, 1});
    idstr = sprintf('%s%s', strtrim(direction), strtrim(id));
    subdomain = to_ID(raw{i, 4});
    if isfield(SD, subdomain)
        SD.(subdomain) = [SD.(subdomain), ' ', idstr];
    else
        SD.(subdomain) = idstr;
    end
end
end