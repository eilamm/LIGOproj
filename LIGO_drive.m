% Eilam Morag
% January 31, 2016
% Purpose: Summing up the normalized powers for specified frequency 
% patterns.
% LIGO_Type1(): expressions of type frequency = mx + b, where m is an
% integer
% LIGO_Type2(): Combs on combs. 

% clear workspace and close graphics
clear variables; 
close all;

% SET THESE VALUES
% offset = input('Enter offset from 0 (Hz): ');
% HARMONIC = input('Enter harmonic (Hz): ');
% START_FREQ = input('Enter lower bound frequency (Hz): ');
% END_FREQ = input('Enter upper bound frequency (Hz): ');


% SET START and END DATES for evaluation
% Enter as follows: START_DATE = Date([dd mm yyyy]); same for END_DATE
START_DATE = Date([1, 1, 2016]);
END_DATE = Date([31, 1, 2016]);

disp(['Start date: ', START_DATE.date2str()]);
disp(['End date: ', END_DATE.date2str()]);

% Until the constructor is made better.
% lower bound, upper bound, offset, harmonic, ID
c1 = Comb([0, 4000, 32, 16, 1]);
c2 = Comb([150, 4000, 48, 16, 2]);
c3 = Comb([1000, 4000, 0.76, 20, 3]);

c1.init_date = START_DATE;
c1.end_date = END_DATE;
c2.init_date = START_DATE;
c2.end_date = END_DATE;
c3.init_date = START_DATE;
c3.end_date = END_DATE;

c1 = c1.init();
c2 = c2.init();
c3 = c3.init();
combs = [c1; c2; c3];
% These HAVE to be multiples of 100. END_FREQ MUST be >= START_FREQ, and
% both must be <= 4000. They determine which frequency range is looked
% at, and thus which files are opened.
% NOTE: CURRENTLY selecting any START_FREQ that isn't zero will give
% inaccurate results. The functionality for indexing using the start
% variable must be changed to rely upon START_FREQ for different start
% values to work.
% START_FREQ = 0;
% END_FREQ = 4000;

% Preallocate memory for the date array
% A difference in months means a full month. The rest of rough_size is made
% up by the days we go into the last month.
num_days = END_DATE - START_DATE;
% Forty files per day; 10 seconds per file; 60 seconds per minute.
minutes = num_days/30*5; 
disp(['Working. This will take around ', num2str(minutes), ' minutes.']);
disp(['Beginning time is ', datestr(now)]);


combs = LIGO_body(combs);

% rough_size
%rough_size = 30;

% plot(1:1:rough_size, day_averages, '*');
for i = 1:1:size(combs)
    num_days = combs(i).num_days;
    day_averages = combs(i).day_avgs;
    day_errors = combs(i).day_errors;
    START_DATE = combs(i).init_date;
    END_DATE = combs(i).end_date;
    HARMONIC = combs(i).harm;
    offset = combs(i).offset;
    START_FREQ = combs(i).low_b;
    END_FREQ = combs(i).up_b;
    
    figure;
    errorbar(1:1:num_days, day_averages, day_errors, 'o');
    green_line = @(t) 1;
    hold on;
    fplot(green_line, [1 num_days], 'Color', 'g');



    %Technically it's off by one, since day 1 is the start_date. Requires
    %slight tweaking.
    xlabel(['Days since ', num2str(START_DATE.day), '/', num2str(START_DATE.month), '/', num2str(START_DATE.year)]);
    ylabel('Average normalized power');
    title(['Average normalized power for ', num2str(HARMONIC), ' Hz Harmonics with offset ', num2str(offset), ' Hz in range ', ...
        num2str(START_FREQ), '-', num2str(END_FREQ), ' Hz between ', num2str(START_DATE.month), '/', ...
        num2str(START_DATE.day), '/' , num2str(START_DATE.year), ' and ', num2str(END_DATE.month), '/', ...
        num2str(END_DATE.day), '/' , num2str(END_DATE.year)]);

    saveas(gcf, ['/home/eilam.morag/public_html/Avg_norm_pwr_for_', num2str(HARMONIC)...
        , 'Hz_offset_', num2str(offset), 'Hz_range_', num2str(START_FREQ), '_to_', num2str(END_FREQ), 'Hz_dates_', ...
        num2str(START_DATE.month), '-', num2str(START_DATE.day), '-' , num2str(START_DATE.year), ...
        '_to_', num2str(END_DATE.month), '-', num2str(END_DATE.day), '-' , num2str(END_DATE.year), ...
        '.png']);

    temp = START_DATE;

    for j = 1:1:num_days
        disp([temp.date2str(), ': ', num2str(day_averages(j))]);
        temp = temp.next_day();
    end
end
disp(['Ending time is ', datestr(now)]);
disp('DONE');
