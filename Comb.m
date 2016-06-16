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
        day_sft_errs;
        bins;
        num_freq;
        start = 1;
        total = 0;
        square = 0;
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
            obj.num_freq = length(obj.bins);
            obj.num_days = obj.end_date - obj.init_date;
            obj.day_avgs = zeros(obj.num_days, 1);
            obj.day_errors = zeros(obj.num_days, 1);
            obj.day_sft_errs = zeros(obj.num_days, 1);
        end
        % plot_title: returns a string that should be used as the title of
        % the plot of the object's data
        function str = plot_title(o)
            str = ['Average normalized power for ', num2str(o.harm), ...
                    ' Hz Harmonics with offset ', num2str(o.offset), ...
                    ' Hz in range ', num2str(o.low_b), '-', ...
                    num2str(o.up_b), ' Hz between ',  ...
                    o.init_date.date2str(), ' and ',  ...
                    o.init_date.date2str()];
        end
        % plot_xlabel: returns a string that should be used for the 
        % xlabel of the plot of the object's data
        function str = plot_xlabel(o)
            str = ['Days since ', o.init_date.date2str()];
        end
        % plot_xlabel: returns a string that should be used for the 
        % ylabel of the plot of the object's data
        function str = plot_ylabel(o)
            str = 'Average normalized power';
        end
        % plot_filename: returns a string that should be used as the file
        % name for the plot
        function str = plot_filename(o)
            str = ['/home/eilam.morag/public_html/', o.combStrFile(), ...
                    '/Avg_norm_pwr_for_', 'harmonic_', num2str(o.harm), ...
                    'Hz_offset_', num2str(o.offset), 'Hz_range_', ...
                    num2str(o.low_b), '_to_', num2str(o.up_b), ...
                    'Hz_dates_', o.init_date.date2str_nospace(), ...
                    '_to_', o.end_date.date2str_nospace(), '.png'];
        end
        % plot_vlines: plots dashed magenta vertical lines at the end of
        % every month in-between the init_date and end_date of the comb
        function plot_vlines(o)
            hold on;
            temp = o.init_date;
            for i = 1:1:o.num_days
                if (temp.last_of_month() == 1)
                    line([i i], ylim, 'LineStyle', '--', 'Color', 'm', ...
                         'LineWidth', 0.85);
                end
                temp = temp.next_day();
            end
        end
        % saveall: checks for the existence of a directory for the specific
        % comb. If none exists, creates one. Then saves the plot to the
        % folder and creates an HTML script to write a webpage displaying
        % the plot.
        function saveall(o)
            if (exist(o.combStrFile(), 'dir') == 0)
                mkdir(o.combStrFile());
            end
            saveas(gcf, o.plot_filename());
                
        end
        % printCombFile: returns as a string the important comb properties in a filename
        % safe way (with underscores)
        function str = combStrFile(o)
            str = ['Harmonic', num2str(o.harm), 'Hz_offset', ...
                    num2str(o.offset), 'Hz_range', num2str(o.low_b), ...
                    '_to_', num2str(o.up_b)];
        end
        % analyze: uses the bins property to index into data and analyzes
        % it as is proper (AKA adding to the total and square properties)
%         function [total, square, start] = analyze(obj, data)
%             total = obj.total;
%             square = obj.square;
%             start = obj.start;
%             while ( (obj.start <= length(obj.bins) )&& ...
%                     (obj.bins(obj.start, 1) < freq + 100) )
%                 % Use the next value of the bins (second column, which is
%                 % the line number in the file) to index into the data
%                 % matrix. Take the value from the second column, which is
%                 % the normal power.
% %                 data(bins(start, 2), :)
%                 value = data(obj.bins(start, 2), 2);
%                 total = total + value;
%                 square = square + value^2;
%                 start = start + 1;
%             end
%         end
    end
end