% Eilam Morag
% June 2, 2016
% A class for date types. 
classdef Date
    properties
        day
        month
        year
    end
    methods
        function obj = Date(c)
            if nargin > 0
                if isa(c, 'Date')
                    obj.day = c.day;
                    obj.month = c.month;
                    obj.year = c.year;
                else
                    obj.day = c(1);
                    obj.month = c(2);
                    obj.year = c(3);
                end
            else
                obj.day = 2;
                obj.month = 6;
                obj.year = 2016;
            end
        end
        function date = next_month(obj)
            date = Date();
            date.day = 1;
            if (obj.month == 12)
                date.month = 1;
                date.year = obj.year + 1;
            else
                date.month = obj.month + 1;
                date.year = obj.year;
            end
        end
        function date = date2str(obj)
            switch obj.month
                case 1
                    m = 'Jan';
                case 2
                    m = 'Feb';  
                case 3
                    m = 'Mar';
                case 4
                    m = 'Apr';
                case 5
                    m = 'May';
                case 6
                    m = 'Jun';
                case 7
                    m = 'Jul';
                case 8
                    m = 'Aug';
                case 9
                    m = 'Sep';
                case 10
                    m = 'Oct';
                case 11
                    m = 'Nov';
                case 12
                    m = 'Dec';
                otherwise
                    m = ['ERROR WITH MONTH: NOT IN RANGE 1-12; value is ', ...
                        num2str(obj.month)];
            end
            date = [m, ' ', num2str(obj.day), ', ', num2str(obj.year)];
        end
        function print(obj)
            disp(date2str(obj));
        end
        % function days_in_month: returns the number of days in a month
        function days = days_in_month(obj)
            switch (obj.month)
                case 1
                    days = 31;
                case 2
                    days = 28;
                case 3 
                    days = 31;
                case 4
                    days = 30;
                case 5
                    days = 31;
                case 6
                    days = 30;
                case 7
                    days = 31;
                case 8
                    days = 31;
                case 9
                    days = 30;
                case 10
                    days = 31;
                case 11
                    days = 30;
                case 12 
                    days = 31;
                otherwise 
                    days = -1;
                    disp(['ERROR WITH days_in_month: obj.month is not '...
                        ' in range 1 - 12; value of obj.month is ', ...
                        num2str(obj.month)]);
            end
        end
        % function not equal: returns 1 if not equal, 0 if equal
        function r = ne(obj1, obj2)
            obj1 = Date(obj1);
            obj2 = Date(obj2);
            r = 0; 
            if (obj1.year ~= obj2.year)
                r = 1;
            elseif (obj1.month ~= obj2.month)
                r = 1;
            elseif (obj1.day ~= obj2.day)
                r = 1;
            end
        end
        % date2jdn: convert calendar date to Julian Day Number. Thanks to 
        % http://quasar.as.utexas.edu/BillInfo/JulianDatesG.html for the
        % algorithm. Used for date arithmetic in O(1) time.
        function jdn = date2jdn(date)
            A = floor(date.year/100);
            B = floor(A/4);
            C = 2 - A + B;
            D = floor(365.25*(date.year + 4716));
            E = floor(30.6001*(date.month + 1));
            jdn = C + D + E + date.day - 1524.5;
        end
        % minus: The first date MUST be equal to or later than the second!
        % Also note, this gives you the number of days between the earlier
        % and the later date, INCLUSIVE (that is why there is the +1)
        function r = minus(date1, date2)
            r = date2jdn(date1) - date2jdn(date2) + 1;
        end
        % lt: Overwriting the less-than "<" operator. Returns true if date1
        % is less than date 2
        function r = lt(date1, date2)
            r = NaN;
            if (date1.year < date2.year)
                r = 1;
                return;
            elseif (date1.year > date2.year)
                r = 0;
                return;
            else
                if (date1.month < date2.month)
                    r = 1;
                    return;
                elseif (date1.month > date2.month)
                    r = 0;
                    return;
                else
                    if (date1.day < date2.day)
                        r = 1;
                        return;
                    elseif (date1.day > date2.day)
                        r = 0;
                        return;
                    else
                        r = 0;
                        return;
                    end
                end
            end
        end
        % le: Overwriting the less-than-or-equal-to "<=" operator. Returns 
        % true if date1 is less than or equal to date 2
        function r = le(date1, date2)
            r = NaN;
            if (date1 ~= date2)
                if (date1 < date2)
                    r = 1;
                else
                    r = 0;
                end
            else % equal
                r = 1;
            end
        end
        % gt: Overwriting the greater-than ">" operator. Returns true if 
        % date1 is greater than date 2
        function r = gt(date1, date2)
            r = NaN;
            if (date1 ~= date2)
                if (date1 < date2)
                    r = 0;
                else
                    r = 1;
                end
            else
                r = 0;
            end
        end
        % ge: Overwriting the greater-than-or-equal-to ">=" operator. 
        % Returns true if date1 is greater than or equal to date 2
        function r = ge(date1, date2)
            r = NaN;
            if (date1 ~= date2)
                if (date1 < date2)
                    r = 0;
                else
                    r = 1;
                end
            else
                r = 1;
            end
        end
        %
        % last_of_month: Returns a 1 if the object's day is the last of the
        % month. Returns a zero otherwise. 
        function r = last_of_month(obj)
            if (obj.month == 2 && obj.day == 28)
                r = 1;
            elseif ((obj.day == 30) && (obj.month == 4 || obj.month == 6 ...
                    || obj.month == 9 || obj.month == 11))
                r = 1;
            elseif (obj.day == 31)
                r = 1;
            else
                r = 0;
            end
                
        end
        % next_day: Increments the date by one day and returns as a new
        % Date object.
        function date = next_day(obj)
            date = Date(obj);
            if (last_of_month(obj) == 1)
                date = next_month(obj);
            else
                date.day = date.day + 1;
            end
        end
        % add_days: adds the integer number of 'days' to the date. Returns
        % the new date as a Date object. CURRENTLY NOT WORKING FOR THE YEAR
        % 2016 FOR UNKNOWN REASONS.
%         function date = add_days(obj, days)
%             date = jdn2date(date2jdn(obj) + days + 2);
%         end

    end
end

% jdn2date: convert Julian Day Numbers to calendar dates. Thanks to 
% http://quasar.as.utexas.edu/BillInfo/JulianDatesG.html for the
% algorithm. Used for date arithmetic in O(1) time, specifically for
% add_days.
function date = jdn2date(jdn)
    Q = jdn + 0.5;
    Z = floor(Q);
    W = floor((Z - 1867216.25)/36524.25);
    X = floor(W/4);
    A = Z + 1 + W - X;
    B = A + 1524;
    C = floor((B - 122.1)/365.25);
    D = floor(365.25*C);
    E = floor((B-D)/30.6001);
    F = floor(30.6001*E);
    Day = B - D - F + (Q - Z);
    Month = E - 1;
    if (Month > 12)
        Month = E - 13;
    end
    if (Month == 1 || Month == 2)
        Year = C - 4715;
    else
        Year = C - 4716;
    end
    date = Date([Day Month Year]);
end