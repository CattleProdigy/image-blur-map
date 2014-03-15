function t = make_gabor_filters(filter_size)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    [xx, yy] = ndgrid(-filter_size/2:filter_size/2-1,...
                        -filter_size/2:filter_size/2-1);

    % Generate Gaussian Window                
    gaussian_function = @(x, sigma, N) ...
        (1 ./ (sigma .* sqrt(2*pi))).*exp(-((x.^2)./(2.*sigma.^2)));
    
    gaussian_window = gaussian_function(xx, filter_size / 4, filter_size)...
                                .* gaussian_function(yy, filter_size / 4, filter_size);
    
    gaussian_window = gaussian_window ./ (max(max(gaussian_window)));
    t = gaussian_window;


end

