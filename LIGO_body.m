% Eilam Morag
% January 31, 2016
% The main body of the program.


% Calculate all the frequencies we want to look at. 
% Argument c is the combs array
function c = LIGO_body(c, channel, selfCheck)
    chanPath = channelPath(channel);
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
            [data, file_exists, path] = read_data_new(d, m, y, freq, channel, chanPath);
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
                        % This if-statement only runs in self-check mode
                        if (selfCheck == 1)
                            selfCheck_binsValid(data, c(j), start);
                            c(j).DEBUG_lastf = selfCheck_binsIncreasing( ...
                                c(j).bins(start, 1), c(j).DEBUG_lastf, ...
                                c(j).ID, start);
                        end
                        % Use the next value of the bins (second column, which is
                        % the line number in the file) to index into the data
                        % matrix. Take the value from the second column, which is
                        % the normal power.
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
                fileLowLimit = freq;
                fileUpLimit = freq + 100;
                for j = 1:1:size(c)
                    combLastBin = c(j).bins(c(j).num_freq, 1);
                    combFirstBin = c(j).bins(1, 1);
                    
                    % If this file does not contain any of the comb's teeth
                    if (fileLowLimit > combLastBin || ...
                            fileUpLimit < combFirstBin) 
                        % Do nothing
                    % Else if this file does contain some teeth of the comb
                    else
                        % Disregard its data for the data by setting its 
                        % day's total to NaN
                        c(j).total = NaN;
                    end
                end
                
                % File doesn't exist, skip inner loop
            end
        end
        for k = 1:1:size(c)
            avg = c(k).total/c(k).num_freq;
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