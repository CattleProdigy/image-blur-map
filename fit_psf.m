function [ sig_i_coeffs, r_domain ] = fit_psf(ti)

    disc = @(r, ri) double(r <= ri);
    g = fspecial('gaussian');

    r_domain = fliplr([0:0.1:8])';

    %pq = [-5:5];
    
    sigma_hi = ti;
    for i = 1:length(r_domain)
        
        r = r_domain(i);

        % Radius must be positive;
        if (r == 0)
            r = 0.1;
        end

        % Generate Sample PSF (Slightly blurred Disc);
        blur_psf = fspecial('disk',r);

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
    
    sig_i_coeffs = cell([size(ti,1) size(ti,2)]);
    for j = 1:size(ti,1)
        for k = 1:size(ti,2)
            if (isempty(ti{j,k}))
                continue;
            end
            
            sigma_r = cell2mat(sigma_hi(:, j,k));
            vals = unique(sort(sigma_r));
            sigma_r(sigma_r == 0) = vals(2).*ones(sum(sigma_r == 0),1); % Clear any zeros;
            
            lsigma_r = log(sigma_r);     
            ws = warning('off','all');  % Turn off warning for overfitting
            sig_i_coeffs{j,k} = polyfit(r_domain,lsigma_r, 7);
            warning(ws)  % Turn it back on.

%             f = fit (r_domain, lsigma_r, 'rat32');
% 
%             subplot(2,1,1)
%             plot(r_domain, (f(r_domain)));
%             subplot(2,1,2)
%             plot(r_domain, log(sigma_r));
%             pause();

            %sample_psf = psfmodel(x, r_domain, pq);
            
            %coeff_guess = 0.0001*randn(length(pq),1);
            %alpha = lsqcurvefit(@(x, xdata) psfmodel(x, xdata,pq), coeff_guess, r_domain, sigma_r);
            %coeffs{j,k} = alpha;
        end
    end
    
%     for j = 1:size(ti,1)
%         for k = 1:size(ti,2)
%             if (isempty(ti{j,k}))
%                 continue;
%             end
%             
%             sigma_r = cell2mat(sigma_hi(:, j,k));
%             
%             fit_sigma = exp(polyval(sig_i_coeffs{j,k}, r_domain));
% 
%             subplot(2,1,1)
%             plot(r_domain, log(fit_sigma));
%             subplot(2,1,2)
%             plot(r_domain, log(sigma_r));
%             pause();
%         end
%     end    
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

