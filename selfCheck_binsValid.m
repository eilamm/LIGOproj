% Author: Eilam Morag
% July 15, 2016
% Sanity-check function. Test to make sure that the frequency in the bins
% is the same frequency retrieved from the data file. If they're not the 
% same, check to see if the retrieved frequency is the best option (e.g.
% if the harmonics are non-integer and the frequency in the bins doesn't 
% exist in the data)
function selfCheck_binsValid(data, comb, start)
if (data(comb.bins(start, 2), 1) ~= comb.bins(start, 1))
    s = sprintf('%s%i%s%i%s%d%s%d', 'Unequal for Comb ', comb.ID, ...
        ': index of ', start, ', comb frequency requested is ', comb.bins(start, 1), ...
        ', actual frequency retrieved is ', data(comb.bins(start, 2), 1));
    disp(s);

    DB_freq = comb.bins(start, 1);
    
    if (comb.bins(start, 2) - 1 >= 1 && comb.bins(start, 2) + 1 <= length(data))
        DEBUG_arr = [abs(DB_freq - data( comb.bins(start, 2) - 1, 1 )); ...
                     abs(DB_freq - data( comb.bins(start, 2), 1 )); ...
                     abs(DB_freq - data( comb.bins(start, 2) + 1, 1 ))];
    end
    
    % If the index calculated by Comb.init_bins
    % does not give the closest frequency to the
    % frequency caluclated by Comb.init_bins, then
    % print an error message.
    if (DEBUG_arr(2) ~= min(DEBUG_arr))
        error('%s%f\n%s', 'Looking for ', DB_freq, 'Selected frequency is NOT best local option:');
    else
        s = sprintf('%s\n', 'Selected frequency is best local option');
        disp(s);
    end

end
% DEBUG PART ABOVE