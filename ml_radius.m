function [s, r] = ml_radius(im, gi, sig_i_coeffs)

    r_old = 1; % Initial Conditions
    s_old = 1;
    
    it_max = 100;
    
    for i = 1:it_max
        
        for j = 1:size(sig_i_coeffs,1)
            for k = 1:size(sig_i_coeffs,2)
                if (isempty(ti{j,k}))
                    continue;
                end
                rho_i{j,k} = (1 + sig_ni/(s_old*exp(polyval(sig_i_coeffs{j,k}, 
            end
        end

        
    end

end

