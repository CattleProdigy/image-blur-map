function r = ml_iterative(im, gi, sig_i_coeffs, sig_ni, r)

    nfilt = size(sig_i_coeffs,1);
    [m, n] = size(im);
    r_old = round(r.*ones(size(im))); % Initial Conditions
    s_old = abs(randn(size(im)));
    
    it_max = 20;
    
%     derive_coeffs = blockproc(sig_i_coeffs,[1,10],@(x) polyder(x.data));
    for j = 1:nfilt
        derive_coeffs(j,:) = polyder(sig_i_coeffs(j,:));
    end
    
    for i = 1:20
        fprintf('ML Iteration: %i\n',i);
        r = r_old; % placeholder        
        
        % Estimate S
 
% Vectorized version of fixed point s update (it is slower for some reason)
%        
%         sig_i_r = blockproc(sig_i_coeffs,[1,10],@(x) reshape(exp(polyval(x.data, r_old)), [1,m*n]));
%         sig_i_r = reshape(sig_i_r, [size(gi,3), m, n]);
%         sig_n_ii = repmat(sig_ni',[1 m n]);
% 
%         s_temp(1,:,:) = s_old;       
%         rho = (1+sig_n_ii...
%             ./(repmat(s_temp,[nfilt,1,1]).*sig_i_r)).^(-2);
%         
%         spectrum = rho.*((permute(gi,[3 1 2])) - sig_n_ii)./sig_i_r;
%         
%         rho_sum = squeeze(sum(rho,1));
%         spectrum_sum = squeeze(sum(spectrum,1));
%         s = (rho_sum.^-1).*spectrum_sum;

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
        for it = 1:5
            
            fprintf('R Gradient Descent Iteration: %i\n',it);
            
            deriv_sum = 0;
            
            for j = 1:nfilt

                sig_i_r = exp(polyval(sig_i_coeffs(j,:), r_old));

                blur_spectrum_deriv = polyval(derive_coeffs(j,:), r_old).*sig_i_r;

                deriv_sum = deriv_sum - ...
                    (blur_spectrum_deriv.*s.*gi(:,:,j))./((s.*sig_i_r+sig_ni(j)).^2) + ...
                    blur_spectrum_deriv.*s./(s.*sig_i_r+sig_ni(j));


            end

            mu = mean(mean(deriv_sum(~isnan(deriv_sum))));
            deriv_sum(isnan(deriv_sum)) = mu;
            
            r = r_old + 0.0001.*deriv_sum;
            subplot(2,1,2);
            imagesc(r);
            colorbar;
            drawnow;
            
            fprintf('r diff: %g\n', sum(sum((r-r_old).^2))./length(r(:)));

            
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
        dif = sum(sum((s-s_old).^2))./length(s(:));
        fprintf('diff: %g\n', dif);
        
        if (dif < 1E-7)
            break;
        end
        
        % Batch update s, r
        s_old = s;
        r_old = r;
        
    end

end

