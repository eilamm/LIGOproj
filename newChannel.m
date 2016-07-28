% Author: Eilam Morag
% July 28, 2016
% Purpose: perform first-time setup tasks, such as creating the home
% directory for the program output, and creating the home website. Path it
% will create: /home/<linux
%                   username>/public_html/CombInv/Channels/<Channel name>

function newChannel(channel)
    uid = getenv('USER');
    path = ['/home/', uid, '/public_html/CombInv/Channels/', channel, '/'];
    if (exist(path, 'dir') == 0)
        disp(['New channel: ', channel]);
        disp(['Creating directory ', path]);
        mkdir(path);
        genCombNavHTML(path, channel);
        genCombNavCSS(path);
        disp('New channel setup complete.');
    end
end

