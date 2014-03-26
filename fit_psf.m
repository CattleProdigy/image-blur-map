function [ coeffs, r_domain ] = fit_psf(ti)

    disc = @(r, ri) double(r <= ri);
    g = fspecial('gaussian');

    r_domain = fliplr([0:0.1:8])';

    pq = [-5:5];
    
    sigma_hi = ti;
    for i = 1:length(r_domain)
        
        r = r_domain(i);
        
        % Generate Sample PSF (Slightly blurred Disc);
        x = [-r:r];
        y = x;
        [xx, yy] = ndgrid(x, y);
        blur_psf = disc(sqrt(xx.^2 + yy.^2), r);
        blur_psf = conv2(blur_psf, g,'same');

        % Generate Blur Spectra of the sample PSFs
        for j = 1:size(ti,1)
            for k = 1:size(ti,2)
                if (isempty(ti{j,k}))
                    continue;
                end
                sigma_hi{i,j,k} = sum(sum(abs(conv2(ti{j,k}, blur_psf, 'same')).^2));
            end
        end
    end
    
    coeffs = cell([size(ti,1) size(ti,2)]);
    for j = 1:size(ti,1)
        for k = 1:size(ti,2)
            if (isempty(ti{j,k}))
                continue;
            end
            fprintf('Frequency: %d, %d', j, k);
            sigma_r = cell2mat(sigma_hi(:, j,k));
            
            coeff_guess = 0.0001*randn(length(pq),1);
            alpha = lsqcurvefit(@(x, xdata) psfmodel(x, xdata,pq), coeff_guess, r_domain, sigma_r);
            coeffs{j,k} = alpha;
        end
    end
    
    for j = 1:size(ti,1)
        for k = 1:size(ti,2)
            if (isempty(ti{j,k}))
                continue;
            end
            
            sigma_r = cell2mat(sigma_hi(:, j,k));
            

            fit_sigma = psfmodel(coeffs{j,k}, r_domain, pq);


            subplot(2,1,1)
            plot(fit_sigma);
            subplot(2,1,2)
            plot(sigma_r);
            pause;
        end
    end    
%     
%     for i = 1:length(r_domain)
%         temp = squeeze(coeffs(i,:,:));
%         temp(cellfun(@isempty,temp)) = {0};
%         temp = cell2mat(temp);
%         imagesc(temp);
%         pause(0.1);
%         
%     end
end



% generate r domain
% generate a set of sample PSFs from the model
% Take blur spectrum of the sample PSFs (equation 6)
% For each frequency in gabor filter bank fit (equation 12)

