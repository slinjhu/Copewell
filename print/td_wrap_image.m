function out = td_wrap_image(filename)
template = ['<td><a href="%s" target=_blank>'...
    '<img src="%s">'...
    '</a></td>'];

out = sprintf(template, filename, filename);

