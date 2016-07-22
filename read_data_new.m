% Eilam Morag
% February 21, 2016
% Reads in the frequency data for a given day, month, year and frequency
% range (give the first frequency in the range). Returns the data in vector data
function [data, file_exists, folder_path] = read_data_new(day, month, year, first_val)
% UNCOMMENT OUT THIS PATH TO RETURN TO NORMAL CHANNEL - JULY 22, 2016
%     path = ['/home/pulsar/public_html/fscan/H1_DUAL_ARM/H1_DUAL_ARM_HANN/',...
%            'H1_DUAL_ARM_HANN/'];
    path = '/home/pulsar/public_html/fscan/H1_DUAL_ARM/H1_PEM/H1_PEM/';
    y = num2str(year);
    if (month < 10)
        m = ['0', num2str(month)];
    else
        m = num2str(month);
    end
    if (day < 10)
        d = ['0', num2str(day)];
    else
        d = num2str(day);
    end
    
    temp = ['/home/pulsar/public_html/fscan/H1_DUAL_ARM/H1_PEM/H1_PEM/',...
           'fscans_', y, '_', m, '_', d, '*'];
    folder = dir(temp);
    path = [path, folder.name];
        
    path = [path, '/H1_PEM-EX_MAG_VEA_FLOOR_X_DQ/'];
    temp = [path, 'spec_', num2str(first_val), '.00_', ...
            num2str(first_val + 100), '.00_*.txt'];
        
    folder_path = path; % Return directory where the files are.
        
    folder = dir(temp);
    if (isempty(folder))
        file_exists = 0;
        data = 0;
    else
        path = [path, folder(1).name];
        fileID = fopen(path);
        file_exists = 1;
        formatSpec = '%f %f';
        sizeA = [2 Inf]; % Dimensions of matrix A. Infinite rows, 3 columns.
        data = fscanf(fileID, formatSpec, sizeA);
        data = data';
        fclose(fileID);
    end
    
end