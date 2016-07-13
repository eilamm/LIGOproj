% Eilam Morag
% July 12, 2016
% The main body of the program, in DEBUG mode. Tests that the data
% retrieved matches the frequencies given.


% Calculate all the frequencies we want to look at. 
% Argument c is the combs array
function c = LIGO_body_debug(c)
    % Calculate all the bins to be looked at
%     bins = calc_bins(HARMONIC, offset, START_FREQ, END_FREQ);
%     num_freq = length(bins);
    % start is a counter used to know which value of bins we are on.
    % Increases with each iteration of the inner loop. Important to reset
    % to 1 after a day is complete (each iteration of the outer loop)
%     start = 1;
    
    % Number of days we are inspecting. Used to preallocate day_averages
    
    % Will contain the averaged normalized power for each day.
%     day_averages = zeros(num_days, 1);
%     day_errors = zeros(num_days, 1);
    
    % Initialize the total value (to be averaged later) to zero.
%     total = 0;
    % Initialize the square value (for std. dev) to zero
%     square = 0;
    
    
    
%     fileA = START_FREQ - mod(START_FREQ, 100);
%     fileZ = END_FREQ - 100;
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
                        % Use the next value of the bins (second column, which is
                        % the line number in the file) to index into the data
                        % matrix. Take the value from the second column, which is
                        % the normal power.
        %                 data(bins(start, 2), :)
        
        
                        % WHERE YOU LEFT OFF. Apparently moving this fixed
                        % a bug? Investigate.
                        % DEBUG PART BELOW
                        if (data(c(j).bins(start, 2), 1) ~= c(j).bins(start, 1))
                            sprintf('%s%i%s%i%s%d%s%d\n', 'Unequal for Comb ', c(j).ID, ...
                                ': index of ', start, ', comb frequency requested is ', c(j).bins(start, 1), ...
                                ', actual frequency retrieved is ', data(c(j).bins(start, 2), 1))
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
        end
        date = date.next_day();
    end
%     disp('Errors');
%     error_arr
end