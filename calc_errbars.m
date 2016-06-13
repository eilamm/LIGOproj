% return standard deviation / sqrt(num_Freq)
function errbars = calc_errbars(sigma, num_freq)
    errbars = sigma./sqrt(num_freq);
end