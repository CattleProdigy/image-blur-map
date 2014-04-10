function [r, p] = ml_iterative(im, gi, sig_i_coeffs, sig_ni, r)
    close all;
    nfilt = size(sig_i_coeffs,1);
    [m, n] = size(im);
    r_old = round(r.*ones(size(im))); % Initial Conditions
    s_old = abs(randn(size(im)));
    
    it_max = 20;
    
    derive_coeffs = zeros(nfilt,size(sig_i_coeffs,2)-1);
    for j = 1:nfilt
        derive_coeffs(j,:) = polyder(sig_i_coeffs(j,:));
    end
    
    for i = 1:35
        fprintf('ML Iteration: %i\n',i);
      
        
        % Estimate S
 
% Vectorized version of fixed point s update (it is slower for some reason)    
%         tic;
%         sig_i_r = zeros(nfilt,m,n);
%         for j = 1:nfilt
%             sig_i_r(j,:,:) = exp(polyval(sig_i_coeffs(j,:), r_old));
%         end
%         sig_n_ii(1,1,:) = sig_ni;
%         
%         tp = bsxfun(@times,shiftdim(sig_i_r,1),s_old);
%         rho = (1 + bsxfun(@rdivide,sig_n_ii,tp)).^(-2);
%         spectrum = rho.*(bsxfun(@minus, gi,sig_n_ii))./(shiftdim(sig_i_r,1));
%         
%         rho_sum = squeeze(sum(rho,3));
%         spectrum_sum = squeeze(sum(spectrum,3));
%         s = (rho_sum.^-1).*spectrum_sum;
%         toc;

        rho_sum = zeros(m,n);
        spectrum_sum = zeros(m,n);
        for j = 1:nfilt

            sig_i_r = exp(polyval(sig_i_coeffs(j,:), r_old));

            rho = (1 + sig_ni(j)./(s_old.*sig_i_r)).^(-2);
            rho_sum = rho_sum + rho;

            spectrum_sum = spectrum_sum + rho.*(gi(:,:,j) - sig_ni(j))./(sig_i_r);
        end
        s = (1./rho_sum).*spectrum_sum;

        mu = mean(mean(s(~isnan(s))));
        s(isnan(s)) = mu;
        
        % Estimate R        
        % radius gradient descent
        step_size = 0.0001;
        beta = 0.2;
        for it = 1:100
            
            fprintf('R Gradient Descent Iteration: %i\n',it);
            
            deriv_sum = 0;
            
            for j = 1:nfilt

                sig_i_r = exp(polyval(sig_i_coeffs(j,:), r_old));

                blur_spectrum_deriv = polyval(derive_coeffs(j,:), r_old).*sig_i_r;

                denom = (s.*sig_i_r+sig_ni(j));
                deriv_sum = deriv_sum - ...
                    blur_spectrum_deriv.*s.*((gi(:,:,j))./(denom.^2) - ...
                    1./denom);

            end

            mu = mean(mean(deriv_sum(~isnan(deriv_sum))));
            deriv_sum(isnan(deriv_sum)) = mu;
            
            r = r_old + step_size.*deriv_sum;
            step_size = beta*step_size;
            subplot(2,1,2);
            imagesc(r);
            colorbar;
            drawnow;
            
            rdiff = sum(sum((r-r_old).^2))/numel(r);
            fprintf('r diff: %g\n', rdiff);

            if (rdiff < 1e-3 && it > 3)
                break;
            end
            
            r_old = r;
        end
        subplot(2,1,1)
        imagesc(s);
        colorbar;
        subplot(2,1,2);
        imagesc(r);
        colorbar;
        drawnow;

        % Report
        dif = sum(sum((s-s_old).^2))/length(s(:));
        fprintf('diff: %g\n\n', dif);
        
        if (dif < 0.01)
            break;
        end
        
        % Batch update s, r
        s_old = s;
        r_old = r;
        
    end
    
    p = ones(size(im));
    for i = 1:nfilt
        sig_i_r = exp(polyval(sig_i_coeffs(i,:), r));
        p = p.*exppdf(gi(:,:,i), (s.*sig_i_r + sig_ni(i)));
    end

end

