function [x, lambda] = trans_boxcox(x)
% Replace negative with zero, and transform using Box Cox
%         flag_pos = (x>0);
%         [xpos, lambda] = boxcox(x(flag_pos));
%         x(~flag_pos) = min(xpos);
%         x(flag_pos) = xpos;
[x, lambda] = boxcox(x(x>0));
end