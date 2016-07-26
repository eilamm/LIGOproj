% Author: Eilam Morag
% July 24, 2016
% Purpose: to clean up some of the code in LIGO_drive by bundling up the
% channel select lines. 
% Asks the user to change the channel, if he/she wants, and also
% capitalizes all lower-case letters. Also, verifies the existence of the
% channel.

function CHANNEL = selectChannel(CHANNEL)
    disp(['Current channel: ', CHANNEL]);
    channel_in = input('Select different channel? (y for yes, anything else for no): ', 's');
    if (strcmp(channel_in, 'y') == 1)
        CHANNEL = input('New channel: ', 's');
    end
    CHANNEL = upper(CHANNEL);
    
    channelExists = verifyChannel(CHANNEL);
    
    while (channelExists == 0)    
        CHANNEL = input(['Channel ', CHANNEL, ' was not found. Please enter ', ...
                'a new channel: '], 's');
        CHANNEL = upper(CHANNEL);
        channelExists = verifyChannel(CHANNEL);
    end
    
    disp(['Channel ', CHANNEL, ' exists. Continuing.']);
end