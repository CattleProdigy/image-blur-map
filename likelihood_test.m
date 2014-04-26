function x = likelihood_test(gi, sig_i_coeffs, sig_ni)

    x=9;
    
    r = 0:.1:8;
    s = 0:0.01:1;
    
    likelihood = zeros(length(r),length(s));
    
    for i = 1:length(r)
        for j = 1:length(s)
            rr = r(i);
            ss = s(j);
            
            like_prod = 1;
            for l = 1:size(sig_i_coeffs,1)
                for k = 1:size(sig_i_coeffs,2)
                    if (isempty(gi{l,k}))
                        continue;
                    end
                
                    grad = gi{l,k};
                    sig_i_r = exp(polyval(sig_i_coeffs{l,k}, rr));
                    
                    temp = exppdf(grad(20,20), (ss*sig_i_r + 0.000.*sig_ni{l,k}));
                    like_prod = like_prod * temp;
                    %like_prod = like_prod * grad(20,20)/(ss*sig_i_r) + log(ss*sig_i_r + 0.05.*sig_ni{l,k});
                    
                end
            end
            
            likelihood(i,j) = like_prod;
        end
    end
    
    imagesc(sqrt(s), r, likelihood);


end

