function [r_candidates, p_candidates] = ml_radius(im, gi, sig_i_coeffs, sig_ni)

    initial_rs = 1:8;

    r_candidates = zeros([size(im) 8]);
    p_candidates = zeros([size(im) 8]);

    for i = 1:length(initial_rs);
        init = initial_rs(i);
        fprintf('Init Cond: %i\n', init);
        r = ml_iterative(im, gi, sig_i_coeffs, sig_ni, init);
        r_candidates(:,:, i) = r;
        p_candidates(:,:, i) = ones(size(im));
    end
    
end

