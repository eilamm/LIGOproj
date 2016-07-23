% Author: Eilam Morag
% July 23, 2016
% Rounds input x to the nearest 10^n place.

% The version of matlab used by LIGO does not support the new official
% round(x, n) function, which allows rounding to different digits (such as
% the tens place). Instead, it supports an older function, roundn(x, n),
% which is not supported by the most recent versions of matlab. Since I
% can't use round(x, n), and I fear using a non-supported function such as
% roundn(x, n), I'm making this round_n(x, n) function as a replacement for
% both. 

% WARNING: input 'n' takes only integers! Also, function might work with 
% rounding to decimal places (negative n), but it isn't well-tested. 
function r = round_n(x, n)
    tens = 10^n;
    m = mod(x, tens);
    if (m < (tens)/2)
        r = x - m;
    else
        r = x + (tens - m);
    end
end