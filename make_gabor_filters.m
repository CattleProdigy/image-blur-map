function t = make_gabor_filters(filter_size)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    x = [-filter_size/2:filter_size/2-1];
    y = x;
    [xx, yy] = ndgrid(x, y);

    % Generate Gaussian Window                
    gaussian_function = @(x, sigma, N) ...
        (1 ./ (sigma .* sqrt(2*pi))).*exp(-((x.^2)./(2.*sigma.^2)));
    
    gaussian_window = gaussian_function(xx, filter_size / 4, filter_size)...
                                .* gaussian_function(yy, filter_size / 4, filter_size);
    
    gaussian_window = gaussian_window ./ (max(max(gaussian_window)));
    t = gaussian_window;

    gabor = @(x, y, wx, wy) exp(-2*pi*1i.*(x.*wx + y.*wy));
    
    % frequency values (a1 / N
    a1 = [-(filter_size-1)/4:(filter_size-1)/4];
    a1 = a1(logical(1 - mod([-(filter_size-1)/4:(filter_size-1)/4],2)));
    a2 = [0:(filter_size-1)/4];
    a2 = a2(logical(1 - mod(a2,2)));
    a10 = [-(filter_size-1)/4:-2];
    a10 = a10(logical(1 - mod([-(filter_size-1)/4:-2],2)));
    
    ti = cell([length(a2) length(a1)]);
    for i = 1:length(a2)
        n = length(a1);
        if (a2(i) == 0)
            for j = 1:length(a10)
                ti{i,j} = gabor(xx, yy, a10(j), a2(i));
                        imagesc(real(ti{i,j}));
        pause;
            end
        else 
            for j = 1:length(a1)
                ti{i,j} = gabor(xx, yy, a1(j), a2(i));
                        imagesc(real(ti{i,j}));
        pause;
            end
        end

    end
    t = ti;
end

% for N = 41, 60 Filters are generated
% even values of 

%10
