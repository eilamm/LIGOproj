% Author: Eilam Morag
% June 13, 2016
% Purpose: calculate another set of error bars, produced by calculating 
% 1/sqrt(#SFTs_that_day * #teeth_in_comb)

function e = SFTErr(path, teeth)
    temp = '/sfts/tmp/*.sft';
    path = [path, temp];
    listOfSFTs = dir(path);
    numSFTs = numel(listOfSFTs);
    
    e = 1/sqrt(numSFTs*teeth);
    if (e == 0)
        e = NaN;
    end
end