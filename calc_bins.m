% Eilam Morag
% February 20, 2016
% Calculate the frequency bins of interest within the range 0-4000 Hz,
% given the harmonic and offset.
function bins = calc_bins(HARMONIC, offset, start_freq, end_freq)   
    % Calculate the number of frequencies, for preallocation.
%     num_freq = ceil((end_freq - offset)/HARMONIC) - ...
%                floor((start_freq - offset)/HARMONIC);
    too_low = 0;
    num_bins = 0;
    for i = offset:HARMONIC:end_freq
        if (i > start_freq)
            num_bins = num_bins + 1;
        else
            too_low = too_low + 1;
        end
    end
    bins = zeros(num_bins, 1);
    row = 1;
    for i = too_low:(too_low + num_bins - 1)
        freq = offset + i*HARMONIC;
        if (freq >= start_freq)
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
%     for i = 0: num_bins
%         freq = offset + i*HARMONIC;
%         if (freq >= start_freq)
%             bins(row, 1) = freq;
%             % Store the index (line number) each frequency will have in its
%             % respective file. For example, frequency 400 will be the first
%             % frequency in the 400-500 Hz file, so it will have index 1.
%             bins(row, 2) = round(mod(freq, 100)*1800 + 1);
%             row = row + 1;
%         else
%             % If the the frequency is less than the lower bound, then skip
%             % it, aka, do nothing.
%         end
%     end
end