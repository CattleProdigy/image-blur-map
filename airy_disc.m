function ad = airy_disc(r, N)

    x = [-r/2-1:r/2 +1];
    y = x;
    [xx, yy] = ndgrid(x,y);
    
    gaussian_function = @(x, sigma, N) ...
        (1 ./ (sigma .* sqrt(2*pi))).*exp(-((x.^2)./(2.*sigma.^2)));
    
    gaussian_window = gaussian_function(xx, N / 4, N)...
                                .* gaussian_function(yy, N / 4, N);
                            
    gaussian_window = gaussian_window ./ (max(max(gaussian_window)));
    

    %ad = arrayfun(@jinc, sqrt(xx.^2 + yy.^2)).^2;
    ad = arrayfun(@(r2) double(abs(r2) <= r/2), sqrt(xx.^2 + yy.^2));
    ad = ad.*gaussian_window;
end

