% Author: Eilam Morag
% July 24, 2016
% Purpose: parses the input channel name to return a path to the channel
% directory.

function path = channelPath(CHANNEL)
    if (isempty(strfind(CHANNEL, 'DELTA')) == 0)
        path = ['/home/pulsar/public_html/fscan/H1_DUAL_ARM/H1_DUAL_ARM_HANN/',...
               'H1_DUAL_ARM_HANN/'];
    elseif (isempty(strfind(CHANNEL, 'PEM')) == 0)
        path = '/home/pulsar/public_html/fscan/H1_DUAL_ARM/H1_PEM/H1_PEM/';
    else 
        path = '';
    end
end