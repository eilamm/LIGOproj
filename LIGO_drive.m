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

firstTimeSetup();

%%%%%%%%%%%%%%%%%%%%%%%%%%%% CHANGE DATES AND CHANNEL %%%%%%%%%%%%%%%%%%%%
% SET START and END DATES for evaluation
% Enter as follows: START_DATE = Date([dd mm yyyy]); same for END_DATE
START_DATE = Date([4, 7, 2016]);
END_DATE = Date([5, 7, 2016]);
% You may hard-code the CHANNEL name here instead of entering it at the
% beginning of the program's execution. Capitalization does not matter,
% lower-case will be converted to upper-case.
% CHANNEL = 'H1_CAL-DELTAL_EXTERNAL_DQ';
CHANNEL = 'H1_PEM-EX_MAG_VEA_FLOOR_X_DQ';
CHANNEL = selectChannel(CHANNEL);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

selfCheck = input('Run in self-check mode? (y for yes, anything else for no): ', 's');

disp(['Start date: ', START_DATE.date2str()]);
disp(['End date: ', END_DATE.date2str()]);



%%%%%%%%%%%%%%%%%%%%%%%%% CHANGE COMBS IN getCombs.m %%%%%%%%%%%%%%%%%%%%%
combs = getCombs();
combs = initCombs(combs, START_DATE, END_DATE);
% combs(2) = combs(2).T2init(combs(1), 300);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Preallocate memory for the date array
% A difference in months means a full month. The rest of rough_size is made
% up by the days we go into the last month.
num_days = END_DATE - START_DATE;
% Forty files per day; 10 seconds per file; 60 seconds per minute.
minutes = num_days/30*5; 
disp(['Working. This will take around ', num2str(minutes), ' minutes.']);
disp(['Beginning time is ', datestr(now)]);

%%%%%%%%%%%%%%%%%%%%%%%% LIGO_BODY (MAIN PROGRAM) %%%%%%%%%%%%%%%%%%%%%%%%
% Self-check or not
if (strcmp(selfCheck, 'y') == 1) 
    disp('SELF CHECK MODE');
    combs = LIGO_body(combs, CHANNEL, 1);
else
    combs = LIGO_body(combs, CHANNEL, 0);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

newChannel(CHANNEL);

%%%%%%%%%%%%%%%%%%%%%%%%%%% PLOTS AND SAVING FILES %%%%%%%%%%%%%%%%%%%%%%%

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

    % plot_xlabel also modifies the x-axis so it looks good. That's why the
    % green line is plotted after it is called.
    xlabel(combs(i).plot_xlabel());
    hold on;
    fplot(green_line, xlim, 'Color', 'g');
    % plot_ylabel also modifies the y-axis so it looks good. That's why the
    % vertical purple lines are plotted after it is called.
    ylabel(combs(i).plot_ylabel());
    combs(i).plot_vlines();
    set(gcf, 'PaperUnits', 'points');
    set(gcf, 'PaperPosition', [0 0 667 500]);
    title(combs(i).plot_title());
    combs(i).saveall(CHANNEL);
    
    temp = START_DATE;
    
    disp(' ');
    disp(' ');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(['Ending time is ', datestr(now)]);
disp('DONE');
