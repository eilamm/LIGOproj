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
offset = input('Enter offset from 0 (Hz): ');
HARMONIC = input('Enter harmonic (Hz): ');
START_FREQ = input('Enter lower bound frequency (Hz): ');
END_FREQ = input('Enter upper bound frequency (Hz): ');


% SET START and END DATES for evaluation
% Enter as follows: START_DATE = Date([dd mm yyyy]); same for END_DATE
START_DATE = Date([1, 1, 2016]);
END_DATE = Date([31, 1, 2016]);

disp(['Start date: ', START_DATE.date2str()]);
disp(['End date: ', END_DATE.date2str()]);


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


[day_averages, day_errors] = LIGO_body(HARMONIC, offset, START_DATE, ...
                                        num_days , START_FREQ, END_FREQ);

% rough_size
%rough_size = 30;

% plot(1:1:rough_size, day_averages, '*');
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

% for i = 1:1:num_days
%     disp([temp.date2str(), ': ', num2str(day_averages(i))]);
%     temp = temp.next_day();
% end
disp(['Ending time is ', datestr(now)]);
disp('DONE');