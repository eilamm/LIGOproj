% Author: Eilam Morag
% July 15, 2016
% Self check function.
% Test if the frequencies are constantly increasing, which they should be.
% If they are not increasing, possible sign of repeated bins.
function previous_val = selfCheck_binsIncreasing(current_val,  ...
                                                previous_val, ID, index) 
    if (current_val <= previous_val)
        error('%s%i%s%s%i', 'Comb ', ID, ' frequencies ' ...
                , 'not strictly increasing at index ', index);
    else
        previous_val = current_val;
    end
end
