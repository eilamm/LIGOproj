% Calculates the standard deviation of x using sigma = sqrt(<x^2> - <x>^2)
% where avg_of_square = <x^2> and avg = <x>^2
function sigma = stddev(avg_of_square, avg)
    sigma = sqrt(avg_of_square - avg^2);
end