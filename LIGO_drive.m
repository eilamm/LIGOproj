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

debug = input('Enter "db" for debug mode; enter anything to continue normally: ', 's');

% SET START and END DATES for evaluation
% Enter as follows: START_DATE = Date([dd mm yyyy]); same for END_DATE
START_DATE = Date([8, 7, 2016]);
END_DATE = Date([10, 7, 2016]);

disp(['Start date: ', START_DATE.date2str()]);
disp(['End date: ', END_DATE.date2str()]);

% Until the constructor is made better.
% lower bound, upper bound, offset, harmonic, ID
c1 = Comb([0, 150, 0, 16, 1]);
c2 = Comb([0, 4000, 0, 16, 2]);
c3 = Comb([150, 4000, 0, 16, 3]);

c4 = Comb([0, 150, 0, 1, 4]);
c5 = Comb([0, 4000, 0, 1, 5]);
c6 = Comb([150, 4000, 0, 1, 6]);

c7 = Comb([0, 150, 0.25, 1, 7]);
c8 = Comb([0, 4000, 0.25, 1, 8]);
c9 = Comb([150, 4000, 0.25, 1, 9]);

c10 = Comb([0, 150, 0.50, 1, 10]);
c11 = Comb([0, 4000, 0.50, 1, 11]);
c12 = Comb([150, 4000, 0.50, 1, 12]);

c13 = Comb([0, 150, 0.75, 1, 13]);
c14 = Comb([0, 4000, 0.75, 1, 14]);
c15 = Comb([150, 4000, 0.75, 1, 15]);

c16 = Comb([10, 110, 1, 2, 16]);

c17 = Comb([0, 4000, 0, 2, 17]);

c18 = Comb([9, 175, 0.999951, 1.999951, 18]);
c19 = Comb([0, 4000, 12.47285, 12.28695, 19]);
c20 = Comb([2000, 3000, 58.3332, 3.57381, 20]);


% Note that these are copies of c1 and c2.
combs = [c1; c2; c3; c4; c5; c6; c7; c8; c9; c10; c11; c12; c13; c14; c15; c16; c17; c18; c19; c20];
% combs = [c18; c19; c20];

for x = 1:1:size(combs)
    combs(x).init_date = START_DATE;
    combs(x).end_date = END_DATE;
    combs(x) = combs(x).init();
    s = sprintf('%s%d%s', 'Comb ', combs(x).ID, ' is good.');
    disp(s);
end

% combs(2) = combs(2).T2init(combs(1), 300);
% Preallocate memory for the date array
% A difference in months means a full month. The rest of rough_size is made
% up by the days we go into the last month.
num_days = END_DATE - START_DATE;
% Forty files per day; 10 seconds per file; 60 seconds per minute.
minutes = num_days/30*5; 
disp(['Working. This will take around ', num2str(minutes), ' minutes.']);
disp(['Beginning time is ', datestr(now)]);

if (strcmp(debug, 'db') == 1)
    disp('Debug mode'); 
    combs = LIGO_body_debug(combs);
else
    combs = LIGO_body(combs);
end

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
    errorbar(0:1:num_days-1, day_averages, day_errors, 'o');
    green_line = @(t) 1;
    hold on;
    errorbar(0:1:num_days-1, day_averages, day_sft_errs, 'ro');
    combs(i).plot_vlines();

    % plot_xlabel also modifies the x-axis so it looks good. That's why the
    % green line is plotted after it is called.
    xlabel(combs(i).plot_xlabel());
    hold on;
    fplot(green_line, xlim, 'Color', 'g');
    ylabel(combs(i).plot_ylabel());
    title(combs(i).plot_title());
    combs(i).saveall();
    combs(i).printTextDataToFile();
    
    temp = START_DATE;
    
    disp(' ');
    disp(' ');
end
disp(['Ending time is ', datestr(now)]);
disp('DONE');
