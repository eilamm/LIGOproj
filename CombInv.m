% Eilam Morag
% January 31, 2016
% Purpose: Summing up the normalized powers for specified comb frequencies.


% clear workspace and close graphics
clear variables; 
close all;

firstTimeSetup();

%%%%%%%%%%%%%%%%%%%%%%%%%%%% CHANGE DATES AND CHANNEL %%%%%%%%%%%%%%%%%%%%
% SET START and END DATES for evaluation
% Enter as follows: START_DATE = Date([dd mm yyyy]); same for END_DATE
START_DATE = Date([2, 26, 2015]);
END_DATE = Date([7, 29, 2016]);
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
    
    combs(i).printTextDataToFile(CHANNEL);
    combs(i) = combs(i).outlierControl();

    combs(i).plotCombData();
    combs(i).saveall(CHANNEL);
    
    disp(' ');
    disp(' ');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(['Ending time is ', datestr(now)]);
disp('DONE');
