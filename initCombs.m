% Author: Eilam Morag
% July 28, 2016
% Purpose: To clean up the beginning of LIGO_drive. Initializes the combs
% by setting their initial and end dates, and by calling their init
% functions.

function combs = initCombs(combs, START_DATE, END_DATE)
    for x = 1:1:size(combs)
        combs(x).init_date = START_DATE;
        combs(x).end_date = END_DATE;
        combs(x) = combs(x).init();
        s = sprintf('%s%d%s', 'Comb ', combs(x).ID, ' is good.');
        disp(s);
    end
end