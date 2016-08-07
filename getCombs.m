% Author: Eilam Morag
% July 28, 2016
% Purpose: To clean up the beginning of LIGO_drive, and also to make it a
% bit easier to know where to insert new combs and how. 
% The comb creation process is a bit non-intuitive but is still simple. 
% To create a comb, use the format:
%   c# = Comb([lower bound, upper bound, offset, spacing/harmonic, ID]);
% As an example:
%   c3 = Comb([1000, 2000, 1, 2, 3]);
% As a final (but very important) step, add this new comb to the "combs" array. 

function combs = getCombs()
%     c1 = Comb([0, 150, 0, 16, 1]);
    % c2 = Comb([0, 4000, 0, 16, 2]);
    % c3 = Comb([150, 4000, 0, 16, 3]);
    % 
    % c4 = Comb([0, 150, 0, 1, 4]);
    % c5 = Comb([0, 4000, 0, 1, 5]);
    % c6 = Comb([150, 4000, 0, 1, 6]);

    % c7 = Comb([0, 150, 0.25, 1, 7]);
    % c8 = Comb([0, 4000, 0.25, 1, 8]);
    % c9 = Comb([150, 4000, 0.25, 1, 9]);
    % 
    % c10 = Comb([0, 150, 0.50, 1, 10]);
    % c11 = Comb([0, 4000, 0.50, 1, 11]);
    % c12 = Comb([150, 4000, 0.50, 1, 12]);
    % 
    % c13 = Comb([0, 150, 0.75, 1, 13]);
    % c14 = Comb([0, 4000, 0.75, 1, 14]);
    % c15 = Comb([150, 4000, 0.75, 1, 15]);
    % 
    % c16 = Comb([10, 110, 1, 2, 16]);
    % 
    % c17 = Comb([0, 4000, 0, 2, 17]);

    c18 = Comb([9, 175, 1.999951/2.0, 1.999951, 18]);
    % c19 = Comb([0, 4000, 12.47285, 12.28695, 19]);
    % c20 = Comb([2000, 3000, 58.3332, 3.57381, 20]);
    
    % combs = [c1; c2; c3; c4; c5; c6; c7; c8; c9; c10; c11; c12; c13; c14; c15; c16; c17; c18; c19; c20];
    combs = [c18];
end