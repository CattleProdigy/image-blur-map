function [ y ] = polyval_pq(coeffs, pq, x)

    coeffs = coeffs(:);
    [n, m] = size(x);
    V = zeros(m*n, length(pq));
    
    for v = 1:length(pq)
        V(:,v) = (x(:)).^pq(v);
    end
    
    y = V*coeffs;
    
    y = reshape(y, n,m);
    
    % Use Horner's method for general case where X is an array.
%     y = zeros(siz_x, superiorfloat(x,p));
%     if nc>0, y(:) = p(1); end
%     for i=2:nc
%         y = x .* y + p(i);
%     end

end

