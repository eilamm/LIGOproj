% Author: Eilam Morag
% June 10, 2016
% This class, Comb, will be used to contain information and methods for
% individual combs (processes) that should be investigated in a run.
% Creation of multiple objects of this class-type will allow a single run
% to investigate multiple combs at once.

classdef Comb
    properties
        init_date   % Initial date to be investigated in range
        end_date    % Last date to be investigated in range
        low_b       % Frequencies below this lower bound are ignored
        up_b        % Frequencies above this upper bound are ignored
        offset      % Freq harmonics will be offset from 0 by this value
        harm        % Value of the frequency harmonics for this comb
        ID          % Used to uniquely identify each comb
    end
    
    methods
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
        
    end
end