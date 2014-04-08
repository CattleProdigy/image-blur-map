function [s, r] = ml_radius(im, gi, sig_i_coeffs, sig_ni)

    r_old = round(8.*rand(size(im))); % Initial Conditions
    s_old = abs(randn(size(im)));
    
    it_max = 20;
    
    derive_coeffs = cell(size(sig_i_coeffs));
    for j = 1:size(sig_i_coeffs,1)
        for k = 1:size(sig_i_coeffs,2)
            if (isempty(gi{j,k}))
                continue;
            end
            derive_coeffs{j,k} = polyder(sig_i_coeffs{j,k});
        end
    end
    
    for i = 1:it_max
        fprintf('ML Iteration: %i\n',i);
        r = r_old; % placeholder        
        
        % Estimate S
        rho_sum = 0;
        spectrum_sum = 0;
        for j = 1:size(sig_i_coeffs,1)
            for k = 1:size(sig_i_coeffs,2)
                if (isempty(gi{j,k}))
                    continue;
                end

                sig_i_r = exp(polyval(sig_i_coeffs{j,k}, r_old));
                
                rho = (1 + sig_ni{j,k}./(s_old.*sig_i_r)).^-2;
                rho_sum = rho_sum + rho;
                
                spectrum_sum = spectrum_sum + rho.*(gi{j,k} - sig_ni{j,k})./(sig_i_r);
            end
        end
        s = (1./rho_sum).*spectrum_sum;
        
        mu = mean(mean(s(~isnan(s))));
        s(isnan(s)) = mu;
        
        % Estimate R        
        % radius gradient descent
        for it = 1:it_max
            
            fprintf('R Gradient Descent Iteration: %i\n',it);
            
            deriv_sum = 0;

            for j = 1:size(sig_i_coeffs,1)
                for k = 1:size(sig_i_coeffs,2)
                    if (isempty(gi{j,k}))
                        continue;
                    end
                    
                    sig_i_r = exp(polyval(sig_i_coeffs{j,k}, r_old));
                    
                    blur_spectrum_deriv = polyval(derive_coeffs{j,k}, r_old).*sig_i_r;

                    deriv_sum = deriv_sum - ...
                        (blur_spectrum_deriv.*s.*gi{j,k})./((s.*sig_i_r+sig_ni{j,k}).^2) + ...
                        blur_spectrum_deriv.*s./(s.*sig_i_r+sig_ni{j,k});

                end
            end
            
            mu = mean(mean(deriv_sum(~isnan(deriv_sum))));
            deriv_sum(isnan(deriv_sum)) = mu;
            
            r = r_old + 0.0001.*deriv_sum;
            
            
            fprintf('r diff: %g\n', sum(sum((r-r_old).^2))./length(r(:)));

            
            r_old = r;
        end
        

        % Report
        fprintf('diff: %g\n', sum(sum((s-s_old).^2))./length(s(:)));
        
        % Batch update s, r
        s_old = s;
        r_old = r;
        
    end

end

