% Author: Eilam Morag
% June 16, 2016
% Purpose: this function will generate an HTML script and thus create a
% webpage for each comb type. Input argument c should be a comb.

function genHTML(c)
    if (isa(c, 'Comb') == 0)
        error('genHTML only accepts Comb types.');
    end
    harm = num2str(c.harm);
    off = num2str(c.offset);
    low_b = num2str(c.low_b);
    up_b = num2str(c.up_b);
    d1 = c.init_date.date2str();
    d2 = c.end_date.date2str();
    
    text = ['<!DOCTYPE html>\n', ...
            '<html>\n', ...
            '<head>\n', ...
            '    <title>Comb Webpage</title>\n', ...
            '    <meta charset="utf-8"/>\n', ...
            '</head>\n', ...
            '<body>\n', ...
            '    <h1>\n', ...
            '        Comb Properties: ', harm, ' Hz Harmonics, ', off, ...
            ' Hz Offset, in Range ', low_b, ' to ', up_b , ' Hz, ', ...
            ' Between ', d1, ' and ', d2, '\n', ...
            '    </h1>\n', ...
            '    <div class="date">\n', ...
            '        <h2>\n', ...
            '            Dates\n', ...
            '        </h2>\n', ...
            '        <ul>\n', ...
            '            <?php\n', ...
            '                foreach (glob("*.png") as $name) {\n', ...        
            '                        echo "<p onclick=\\"changeDate(''$name'')\\">$name</p>";\n', ...
            '                }\n', ...
            '            ?>\n', ...
            '        </ul>\n', ...
            '    </div>\n', ...
            '    <div class = "data">\n', ...
            '        <img id="plot" src="', c.plot_filename(), '"/>\n', ...
            '        <a id="plot_file" href="', c.plot_filename(), '">Open plot</a>\n', ...
            '        <a href="', c.plot_filename(), '">Download data</a>\n', ...
            '    </div>\n', ...
            '<script type="text/javascript">\n', ...
            '    function changeDate(date) {\n', ...
            '        document.getElementById("plot").src = date;\n', ...
            '        document.getElementById("plot_file").href = date;\n', ...
            '    };\n', ...
            '</script>', ...
            '</body>\n', ...
            '</html>' ];
    filename = ['/home/eilam.morag/public_html/Combs/', ...
                c.combStrFile(), '/', c.combStrFile(), '.php'];
    fileID = fopen(filename, 'w');
    fprintf(fileID, text);
    fclose(fileID);
end