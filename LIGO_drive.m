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

% SET START and END DATES for evaluation
% Enter as follows: START_DATE = Date([dd mm yyyy]); same for END_DATE
START_DATE = Date([1, 1, 2016]);
END_DATE = Date([21, 1, 2016]);

disp(['Start date: ', START_DATE.date2str()]);
disp(['End date: ', END_DATE.date2str()]);

% Until the constructor is made better.
% lower bound, upper bound, offset, harmonic, ID
c1 = Comb([0, 70, 0, 16, 1]);
c2 = Comb([0, 3500, 0.25, 1, 2]);


% c3 = Comb([0, 4000, 16, 1, 3]);
% c4 = Comb([0, 150, 0.75, 1, 4]);
% c5 = Comb([150, 4000, 0, 1, 5]);
% c6 = Comb([150, 4000, 0.25, 1, 6]);
% c7 = Comb([150, 4000, 0.50, 1, 7]);
% c8 = Comb([150, 4000, 0.75, 1, 8]);

% Note that these are copies of c1 and c2.
combs = [c1; c2];

for x = 1:1:size(combs)
    combs(x).init_date = START_DATE;
    combs(x).end_date = END_DATE;
    combs(x) = combs(x).init();
end

combs(2) = combs(2).T2init(combs(1), 300);
% Preallocate memory for the date array
% A difference in months means a full month. The rest of rough_size is made
% up by the days we go into the last month.
num_days = END_DATE - START_DATE;
% Forty files per day; 10 seconds per file; 60 seconds per minute.
minutes = num_days/30*5; 
disp(['Working. This will take around ', num2str(minutes), ' minutes.']);
disp(['Beginning time is ', datestr(now)]);

combs = LIGO_body(combs);

% plot(1:1:rough_size, day_averages, '*');
for i = 1:1:size(combs)
    num_days = combs(i).num_days;
    day_averages = combs(i).day_avgs;
    day_errors = combs(i).day_errors;
    day_sft_errs = combs(i).day_sft_errs;
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
    hold on;
    errorbar(1:1:num_days, day_averages, day_sft_errs, 'ro');
    combs(i).plot_vlines();

    %Technically it's off by one, since day 1 is the start_date. Requires
    %slight tweaking.
    xlabel(combs(i).plot_xlabel());
    ylabel(combs(i).plot_ylabel());
    title(combs(i).plot_title());
    combs(i).saveall();
    combs(i).printTextDataToFile();
    
    temp = START_DATE;
    
    disp(' ');
    disp(' ');
    for j = 1:1:num_days
        disp([temp.date2str(), ': ', num2str(day_averages(j))]);
        temp = temp.next_day();
    end
end
disp(['Ending time is ', datestr(now)]);
disp('DONE');
