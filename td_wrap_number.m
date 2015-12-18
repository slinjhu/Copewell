function out = td_wrap_number(filter, value)
if value > filter
    colorcode = 'bgcolor="#2ecc71"';
else
    colorcode = '';
end

out = sprintf('<td %s>%1.3g</td>', colorcode, value);
