function [r, p] = ml_iterative2(im, gi, sig_i_coeffs, sig_ni, r,pq, show_image)
    close all;
    nfilt = size(sig_i_coeffs,1);
    [m, n] = size(im);
    r_old = round(r.*ones(size(im))); % Initial Conditions
    r_old2 = round(r.*ones(size(im)));
    s_old = 1.*abs(randn(size(im)));
    

    it_max = 20;
    
    derive_coeffs = zeros(nfilt,size(sig_i_coeffs,2)-1);
    %pq_deriv = pq-1;
    for j = 1:nfilt
        %derive_coeffs(j,:) = sig_i_coeffs(j,:).*pq;
        derive_coeffs(j,:) = polyder(sig_i_coeffs(j,:));
    end

      
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


%         s(s<0) = 0;
% 
% 
%         mu = mean(mean(s(~isnan(s))));
%         s(s<0) = mu;
%         s(isnan(s)) = mu;
        
        % Estimate R        
        % radius gradient descent
        
        step_size = 0.0001;
        
        for it = 1:2000
            
            fprintf('R Gradient Descent Iteration: %i\n',it);
            
            deriv_sum = 0;
            
            rho_sum = zeros(m,n);
            spectrum_sum = zeros(m,n);
            for j = 1:nfilt

                sig_i_r = exp(polyval(sig_i_coeffs(j,:),r_old));
                %sig_i_r = exp(polyval(fliplr(sig_i_coeffs(j,:)),r_old).*(r_old.^(pq(1))));

                rho = (1 + sig_ni(j)./(s_old.*sig_i_r)).^(-2);
                rho_sum = rho_sum + rho;

                spectrum_sum = spectrum_sum + rho.*abs(gi(:,:,j) - sig_ni(j))./(sig_i_r);
    %             imagesc(gi(:,:,j) - sig_ni(j));
    %             colorbar;
    %             pause;
            end
            s = spectrum_sum./rho_sum;
            
            for j = 1:nfilt
                sig_i_r = exp(polyval(sig_i_coeffs(j,:),r_old));
                %sig_i_r = exp(polyval(fliplr(sig_i_coeffs(j,:)),r_old).*(r_old.^(pq(1))));

                blur_spectrum_deriv = polyval(derive_coeffs(j,:),r_old).*sig_i_r;
                %blur_spectrum_deriv = (polyval(fliplr(derive_coeffs(j,:)),r_old).*(r_old.^(pq_deriv(1)))).*sig_i_r;
                
                denom = (s.*sig_i_r+sig_ni(j));
                deriv_sum = deriv_sum - ...
                    blur_spectrum_deriv.*s.*( (gi(:,:,j))./(denom.^2) - 1./denom );
                
                if (any(isnan(deriv_sum(:))) || any(isinf(deriv_sum(:))))
                        disp('whoops1');
                end

            end

%             mu = nanmean(nanmean(deriv_sum));
%             deriv_sum(isnan(deriv_sum)) = mu;
            if (any(isnan(r(:))) || any(isinf(r(:))))
                    disp('whoops2');
            end
            r = r_old - step_size.*deriv_sum + 0.85*(r_old - r_old2);
            
%             r(r < 0 | r > 10) = nanmean(nanmean(r));
            
%             step_size = beta*step_size;
%             if (show_image)
%                 subplot(2,1,2);
%                 imagesc(r);
%                 colorbar;
%                 drawnow;
%             end
            
            rdiff = nansum(nansum((r-r_old).^2))/numel(isnan(r(:)));
            fprintf('r diff: %g\n', rdiff);


            
            r_old2 = r_old;
            r_old = r;
            
            if (show_image)
                subplot(2,1,1)
                imagesc(s);
                colorbar;
                subplot(2,1,2);
                imagesc(r);
                colorbar;
                drawnow;
            end

            % Report
            dif = sum(sum((s-s_old).^2))/length(s(:));
            fprintf('diff: %g\n\n', dif);

            if (rdiff < 1e-6 && dif < 1E-9 && it > 1)
                break;
            end

            % Batch update s, r
            s_old = s;
            
        end

%         lb = 0.5.*ones(size(im));
%         up = 9.*ones(size(im));
%         options = saoptimset('simulannealbnd');
%         %options = saoptimset(options, 'Display', 'iter');
%         
%         for j = 1:m
%             parfor k = 1:n
%             [r(j,k),fval,exitFlag,output] = ...
%                 simulannealbnd(@(x) ml_objfun(x, gi(j,k,:), sig_i_coeffs, sig_ni, s(j,k)),r_old(j,k),0.5,9,options);
%             end
%             disp j
%         end
%                 


    p = ones(size(im));
    for i = 1:nfilt
        sig_i_r = exp(polyval(sig_i_coeffs(i,:),r));
        %sig_i_r = exp(polyval(fliplr(sig_i_coeffs(i,:)),r_old).*(r_old.^(pq(1))));
        p = p.*exppdf(gi(:,:,i), (s.*sig_i_r + sig_ni(i)));
    end

end

