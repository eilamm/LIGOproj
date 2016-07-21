% Author: Eilam Morag
% July 21, 2016
% Useful for distinguishing between integer and non-integer harmonics and
% offsets so as to better name directories and plots

% Returns a 1 if x is an integer VALUE -- x may be of a non-integer type
% and the function could still return a 1. For example, isint(16) == 1,
% isint(16.00000) == 1, isint(16.5) == 0, isint(16.0001) == 0
function r = isint(x)
    if (mod(x, 1) == 0)
        r = 1;
    else
        r = 0;
    end
end