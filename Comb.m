% Author: Eilam Morag
% June 10, 2016
% This class, Comb, will be used to contain information and methods for
% individual combs (processes) that should be investigated in a run.
% Creation of multiple objects of this class-type will allow a single run
% to investigate multiple combs at once.

classdef Comb
    properties
        init_date@Date = Date();   % Initial date to be investigated in range
        end_date@Date = Date();    % Last date to be investigated in range
        low_b = 0;       % Frequencies below this lower bound are ignored
        up_b = 4000;     % Frequencies above this upper bound are ignored
        offset = 0;      % Freq harmonics will be offset from 0 by this value
        harm = 16;       % Value of the frequency harmonics for this comb
        ID = 1;          % Used to uniquely identify each comb
        num_days = 0;
        day_avgs;
        day_errors;
        bins;
    end
    
    methods
        % constructor
        function obj = Comb(c)
            if (nargin > 0)
                if isa(c, 'Comb')
                    obj.init_date = c.init_date;
                    obj.end_date = c.end_date;
                    obj.low_b = c.low_b;
                    obj.up_b = c.up_b;
                    obj.offset = c.offset;
                    obj.harm = c.harm;
                    obj.ID = c.ID;
                else
                    obj.low_b = c(1);
                    obj.up_b = c(2);
                    obj.offset = c(3);
                    obj.harm = c(4);
                    obj.ID = c(5);
                end
            else
                disp('Object properties initialized to default values');
            end
        end
        % verify: verifies that the properties of the object make sense;
        % that the init_date is the same or before the end_date, that the
        % lower bound is less than the upper_bound.
        function verify(obj)            
            if (obj.end_date < obj.init_date)
                error(['Verification of Comb ', num2str(obj.ID), ...
                    ' failed. The end date, ', obj.end_date.date2str(), ...
                    ' is earlier than the initial date, ', ...
                    obj.init_date.date2str()]);
            elseif (obj.up_b <= obj.low_b)
                error(['Verification of Comb ', num2str(obj.ID), ...
                    ' failed. The lower bound, ', num2str(obj.low_b), ...
                    ' is not less than the upper bound, ', ...
                    num2str(obj.up_b)]);
            end
            disp(['Comb ', num2str(obj.ID), ' is good.']);
        end
        % init_bins: A copy of the old "calc_bins", does the exact same
        % thing, although the input arguments have been replaced by object
        % properties (and slightly renamed).
        function bins = init_bins(obj) 
            % Calculate the number of frequencies, for preallocation.
            too_low = 0;
            num_bins = 0;
            for i = obj.offset:obj.harm:obj.up_b
                if (i > obj.low_b)
                    num_bins = num_bins + 1;
                else
                    too_low = too_low + 1;
                end
            end
            bins = zeros(num_bins, 1);
            row = 1;
            for i = too_low:(too_low + num_bins - 1)
                freq = obj.offset + i*obj.harm;
                if (freq >= obj.low_b)
                    bins(row, 1) = freq;
                    % Store the index (line number) each frequency will have in its
                    % respective file. For example, frequency 400 will be the first
                    % frequency in the 400-500 Hz file, so it will have index 1.
                    bins(row, 2) = round(mod(freq, 100)*1800 + 1);
                    row = row + 1;
                else
                    % If the the frequency is less than the lower bound, then skip
                    % it, aka, do nothing.
                end
            end
        end
        % DIR: Stands for Date In Range. Returns a 1 if "date" is between
        % the init and end date of the object.
        function r = DIR(obj, date)
            if (date < obj.init_date)
                r = 0;
            elseif (date > obj.end_date)
                r = 0;
            else
                r = 1;
            end
        end
        % init: Calls verify. Preallocates memory for the day averages and
        % error arrays. Calculates the bins to be looked at.
        function obj = init(obj)
            obj.verify();
            obj.bins = init_bins(obj);
            obj.num_days = obj.end_date - obj.init_date;
            obj.day_avgs = zeros(obj.num_days, 1);
            obj.day_errors = zeros(obj.num_days, 1);
        end
    end
end