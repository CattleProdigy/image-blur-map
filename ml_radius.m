function [rcons_p, r_candidates, p_candidates] = ml_radius(im, gi, sig_i_coeffs, sig_ni,pq)


    initial_rs = fliplr(1:8);

    r_candidates = zeros([size(im) 8]);
    p_candidates = zeros([size(im) 8]);
    rcons_p      = zeros([size(im) 8]);
    
    for i = 1:length(initial_rs);
        init = initial_rs(i);
        fprintf('Init Cond: %i\n', init);
        [r, p] = ml_iterative(im, gi, sig_i_coeffs, sig_ni, init,pq,true);
        r_candidates(:,:,i) = r;
        p_candidates(:,:,i) = p;
    end
    
    [~, idx] = sort(p_candidates, 3);
    for j = 1:size(im,1)
        for k = 1:size(im,2)
            for i = 1:8
                rcons_p(j,k,i) = (r_candidates(j,k, idx(j,k,i)));
            end
        end
    end

end

