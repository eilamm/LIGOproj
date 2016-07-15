% Eilam Morag
% July 12, 2016
% The main body of the program, in DEBUG mode. Tests that the data
% retrieved matches the frequencies given.


% Calculate all the frequencies we want to look at. 
% Argument c is the combs array
function c = LIGO_body_debug(c)
    fileA = 0;
    fileZ = 4000 - 100;
    % Enter outer loop. Goes through each file for a day.
    date = c(1).init_date;
    for i = 1:c(1).num_days
        d = date.day;
        m = date.month;
        y = date.year;
        % Enter middle loop. Goes through frequency range per day.
        for freq = fileA:100:fileZ
            [data, file_exists, path] = read_data_new(d, m, y, freq);
            if (file_exists == 1)
                % Third loop. Iterates through all of the Comb objects
                % contained in the combs container.
                for j = 1:1:size(c) 
                    total = c(j).total;
                    square = c(j).square;
                    start = c(j).start;           
                    % Inner loop. Uses the pre-calculated bins of frequencies to
                    % index into the data matrix and calculate the total sum for
                    % the specific 100 Hz frequency range.
                    while ( (start <= length(c(j).bins)) && ...
                            (c(j).bins(start, 1) < freq + 100) )
                        
                        % DEBUG PART BELOW
                        % Test to make sure that the frequency in the bins
                        % is the same frequency retrieved from the data
                        % file. If they're not the same, check to see if
                        % the retrieved frequency is the best option (e.g.
                        % if the harmonics are non-integer and the
                        % frequency in the bins doesn't exist in the data)
                        if (data(c(j).bins(start, 2), 1) ~= c(j).bins(start, 1))
                            s = sprintf('%s%i%s%i%s%d%s%d', 'Unequal for Comb ', c(j).ID, ...
                                ': index of ', start, ', comb frequency requested is ', c(j).bins(start, 1), ...
                                ', actual frequency retrieved is ', data(c(j).bins(start, 2), 1));
                            disp(s);
                            
                            DB_freq = c(j).bins(start, 1);
                            DEBUG_arr = [abs(DB_freq - data( c(j).bins(start, 2) - 1, 1 )); ...
                                         abs(DB_freq - data( c(j).bins(start, 2), 1 )); ...
                                         abs(DB_freq - data( c(j).bins(start, 2) + 1, 1 ))];
                            % If the index calculated by Comb.init_bins
                            % does not give the closest frequency to the
                            % frequency caluclated by Comb.init_bins, then
                            % print an error message.
                            if (DEBUG_arr(2) ~= min(DEBUG_arr))
                                s = sprintf('%s%f\n%s', 'Looking for ', DB_freq, 'Selected frequency is NOT best local option:');
                                disp(s);
                                DEBUG_arr
                                disp('');
                            else
                                s = sprintf('%s\n', 'Selected frequency is best local option');
                                disp(s);
                            end
                            
                        end
                        % DEBUG PART ABOVE

                        % DEBUG PART BELOW
                        % Test if the frequencies are constantly
                        % increasing, which they should be.
                        if (c(j).bins(start, 1) <= c(j).DEBUG_lastf)
                            s = sprintf('%s%i%s%s%i', 'Comb ', c(j).ID, ' frequencies ' ...
                                , 'not strictly increasing at index ', start);
                            error(s);
                        else
                            c(j).DEBUG_lastf = c(j).bins(start, 1);
                        end
                        % DEBUG PART ABOVE
                        value = data(c(j).bins(start, 2), 2);
                        total = total + value;
                        square = square + value^2;
                        start = start + 1; 
                    end
                    c(j).total = total;
                    c(j).square = square;
                    c(j).start = start;
                end
            else
%                 n_err = n_err + 1;
%                 error_arr = [error_arr;error_msg(d, m, y, freq)];
                for j = 1:1:size(c)
                    c(j).total = -1;
                end
                break;
                % File doesn't exist, skip inner loop
            end
        end
        % Save values for day and prepare constants for next day
        for k = 1:1:size(c)
            if (c(k).total == -1)
                avg = NaN;
            else
                avg = c(k).total/c(k).num_freq;
            end
            c(k).day_avgs(i) = avg;

            avg_of_square = c(k).square/c(k).num_freq;
            c(k).day_errors(i) = ...
                calc_errbars(stddev(avg_of_square, avg), c(k).num_freq);

            c(k).day_sft_errs(i) = SFTErr(path, c(k).num_freq);
            c(k).total = 0;
            c(k).square = 0;
            c(k).start = 1;
            c(k).DEBUG_lastf = -1;
        end
        date = date.next_day();
    end
end