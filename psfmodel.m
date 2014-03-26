function sigma = psfmodel(alpha, r, pq)

    alpha = alpha(:);
    pq    = pq(:);
    sigma = zeros(size(r));
    for i = 1:length(r)
        sigma(i) = exp(alpha'*(r(i).^pq));
    end
    sigma(isnan(sigma)) = 0;
    sigma(~isfinite(sigma)) = 0;
    %sigma = exp(alpha'*(r.^pq));
end

