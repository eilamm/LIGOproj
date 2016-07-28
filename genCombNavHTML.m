% Author: Eilam Morag
% July 28, 2016
% Purpose: Generates the homepage website for the program. This will list
% links to all channels that have been investigated.

function genCombNavHTML(path, channel)
       text = [ '<!DOCTYPE html>\n', ...
                '<html>\n', ...
                '<head>\n', ...
                    '<title>', channel, ': Comb Navigation</title>\n', ...
                    '<link rel="stylesheet" type="text/css" href="combNav.css"/>\n', ...
                '</head>\n', ...
                '<body>\n', ...
                    '<div class = "header">\n', ...
                        '<h1>\n', ...
                            'LIGO Spectral Line Artifact Investigation\n', ...
                        '</h1>\n', ...
                    '</div>\n', ...
                    '<h2>\n', ...
                        channel, ': Comb Navigation\n', ...
                    '</h2>\n', ...
                    '<div class = "navBlock">\n', ...
                        '<table style="width:50%">\n', ...
                            '<tr>\n', ...
                                '<th>Harmonic (Hz)</th>\n', ...
                                '<th>Offset (Hz)</th>\n', ...
                                '<th>Range (Hz)</th>\n', ...
                            '</tr>\n', ...
                            '<?php\n', ...
                                '$directories = scandir("', path, '");\n', ...
                                'foreach ($directories as $key => $folder) {\n', ...
                                    'if ($key > 1 && fnmatch("*.css", $folder) == FALSE && fnmatch("*.php", $folder) == FALSE) {\n', ...
                                        '$link = $folder.".php";\n', ...
                                        '$path = $folder . "/" . $link;\n', ...
                                        '$temp = explode("_", $folder);\n', ...
                                        '$col1 = $temp[1] ;\n', ...
                                        '$col2 = $temp[4] ;\n', ...
                                        '$col3 = $temp[7] . "-" .$temp[9] ;\n', ...
                                        'echo "<tr><a href=$path>\n', ...
                                                            '<td><a href=$path>$col1</a></td>\n', ...
                                                            '<td><a href=$path>$col2</a></td>\n', ...
                                                            '<td><a href=$path>$col3</a></td>\n', ...
                                                '</tr>";\n', ...
                                    '}\n', ...
                                '}\n', ...
                            '?>\n', ...
                        '</table>\n', ...
                    '</div>\n', ...
            '</body>\n', ...
            '</html>\n'];

        
    filename = [path, 'combNav.php'];
    disp(['Creating file ', filename]);
    fileID = fopen(filename, 'w');
    fprintf(fileID, text);
    fclose(fileID);
end