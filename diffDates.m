% Author: Eilam Morag
% July 29, 2016
% Purpose: An alternate method (albeit slower) of calculating the number of
% days between two dates (INCLUSIVE)

function numDays = diffDates(date1, date2)
    if (~isa(date1, 'Date') || ~isa(date2, 'Date'))
        error(['The function diffDates(date1, date2) takes only Date ', ...
                'type arguments as input.']);
    end
    if (date2 < date1)
        temp = date1;
        date1 = date2;
        date2 = temp;
    end
    numDays = 1;
    while (date1 ~= date2)
        date1 = next_day(date1);
        numDays = numDays + 1;
    end
end