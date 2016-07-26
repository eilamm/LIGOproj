% Author: Eilam Morag
% July 24, 2016
% Purpose: Verifies that the channel exists. Returns a 1 if the channel
% exists, and a 0 if it does not.

function exists = verifyChannel(CHANNEL)
    path = channelPath(CHANNEL);
    if (isempty(path))
        disp('Program only recognizes PEM or DELTAL channels.');
        exists = 0;
    else
        directory = [path, 'fscans_2016_07_09_06_00_01_PDT_Sat/', CHANNEL];
        if (exist(directory, 'dir') == 1)
            exists = 1;
        else
            exists = 0;
        end
    end
end