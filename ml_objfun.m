function obj = ml_objfun(r, gi, sig_i_coeffs, sig_ni, s)

    nfilt = size(sig_i_coeffs,1);
    obj = zeros(size(r));
    for j = 1:nfilt
        sig_i_r = exp(polyval(sig_i_coeffs(j,:), r));
        obj = obj + (gi(:,:,j)./(s.*sig_i_r + sig_ni(j))) + log(s.*sig_i_r + sig_ni(j));
    end

end

