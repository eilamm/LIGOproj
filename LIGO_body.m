
% Calculate all the frequencies we want to look at. 
function [day_averages, day_errors] = LIGO_body(HARMONIC, offset, ...
                            START_DATE, num_days, START_FREQ, END_FREQ)
    % Calculate all the bins to be looked at
    bins = calc_bins(HARMONIC, offset, START_FREQ, END_FREQ);
    num_freq = length(bins);
    % start is a counter used to know which value of bins we are on.
    % Increases with each iteration of the inner loop. Important to reset
    % to 1 after a day is complete (each iteration of the outer loop)
    start = 1;
    
    % Number of days we are inspecting. Used to preallocate day_averages
    
    % Will contain the averaged normalized power for each day.
    day_averages = zeros(num_days, 1);
    day_errors = zeros(num_days, 1);
    
    % Initialize the total value (to be averaged later) to zero.
    total = 0;
    % Initialize the square value (for std. dev) to zero
    square = 0;
    
    error_arr = [];
    n_err = 0;
    
    fileA = START_FREQ - mod(START_FREQ, 100);
    fileZ = END_FREQ - 100;
    % Enter outer loop. Goes through each file for a day.
    date = START_DATE;
    for i = 1:num_days
        d = date.day;
        m = date.month;
        y = date.year;
        % Enter middle loop. Goes through frequency range per day.
        for freq = fileA:100:fileZ
            [data, file_exists] = read_data_new(d, m, y, freq);
            if (file_exists == 1)
                % Inner loop. Uses the pre-calculated bins of frequencies to
                % index into the data matrix and calculate the total sum for
                % the specific 100 Hz frequency range.
                while (start <= length(bins) && bins(start, 1) < freq + 100)
                    % Use the next value of the bins (second column, which is
                    % the line number in the file) to index into the data
                    % matrix. Take the value from the second column, which is
                    % the normal power.
    %                 data(bins(start, 2), :)
                    value = data(bins(start, 2), 2);
                    total = total + value;
                    square = square + value^2;
                    start = start + 1;
                end
            else
%                 n_err = n_err + 1;
%                 error_arr = [error_arr;error_msg(d, m, y, freq)];
                total = -1;
                break;
                % File doesn't exist, skip inner loop
            end
        end
        if (total == -1)
            avg = NaN;
        else
            avg = total/num_freq;
        end
        day_averages(i) = avg;
        
        avg_of_square = square/num_freq;
        day_errors(i) = calc_errbars(stddev(avg_of_square, avg), num_freq);
        
        total = 0;
        square = 0;
        start = 1;
        date = date.next_day();
    end
%     disp('Errors');
%     error_arr
end