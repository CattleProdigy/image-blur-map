function [s, r] = ml_radius(im, gi, sig_i_coeffs, sig_ni)

    r_old = 1; % Initial Conditions
    s_old = abs(randn(size(im)));
    
    it_max = 100;
    
    rho_i = cell(size(gi));
    
    for i = 1:it_max
        fprintf('Iteration: %i\n',i);
        r = r_old; % placeholder        
        
        rho_sum = 0;
        spectrum_sum = 0;
        
        for j = 1:size(sig_i_coeffs,1)
            for k = 1:size(sig_i_coeffs,2)
                if (isempty(gi{j,k}))
                    continue;
                end

                sig_i_r = exp(polyval(sig_i_coeffs{j,k}, r_old));
                
                rho_i{j,k} = (1 + sig_ni{j,k}./(s_old.*sig_i_r)).^-2;
                rho_sum = rho_sum + rho_i{j,k};
                
                spectrum_sum = spectrum_sum + (rho_i{j,k}).*(gi{j,k} - sig_ni{j,k})./(sig_i_r);
                
                
            end
        end
        
        s = (1./rho_sum).*spectrum_sum;
        
        fprintf('diff: %g\n', sum(sum((s-s_old).^2))./length(s(:)));
        
        s_old = s;
        r_old = r;
        
    end

end

