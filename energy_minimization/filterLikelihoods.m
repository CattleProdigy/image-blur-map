function [D] = filterLikelihoods(p)
% Function to perform discretized candidate likelihood filtering,
% normalization, and -log conditioning. 
% p: 3D array of (p_x(r),y,x), prerounded r values
% D: Data cost filtered from likelihoods for use with energy minimization
    K [1E-20 1E-12 1E-7 1E-3 1E-1 1 1E-1 1E-3 1E-7 1E-12 1E-20]; % Filter kernel
    xdim = size(p,3);
    ydim = size(p,2);       
    li_length = size(p,1);  % Likelihood array length
    for x=1:xdim
        for y = 1:ydim
            loc_filt = conv(p(y,x,:),K);
            loc_norm = norm(loc_filt,1); % 1-Norm of likelihood estimate
            D(:,y,x) = round(-log(loc_filt./loc_norm)); %Store to filtered 
        end
    end
    
end