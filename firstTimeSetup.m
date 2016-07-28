% Author: Eilam Morag
% July 27, 2016
% Purpose: perform first-time setup tasks, such as creating the home
% directory for the program output, and creating the home website. Path it
% will create: /home/<linux username>/public_html/CombInv/Channels
%              channelNav.php
%              channelNav.css

function firstTimeSetup()
    uid = getenv('USER');
    path = ['/home/', uid, '/public_html/CombInv/Channels/'];
    if (exist(path, 'dir') == 0)
        disp('First time setup running.');
        disp(['Creating directory', path]);
        mkdir(path);
        genChanNavHTML(path);
        genChanNavCSS(path);
        disp('First time setup complete.');
    end
end