function [ y ] = polyval_pq2(coeffs, pq, x)

nc = length(coeffs);

coeffs = ((coeffs(:)));

siz_x = size(x);


% Use Horner's method for general case where X is an array.
y = zeros(siz_x, superiorfloat(x,coeffs));
if (nc>0)
    y = coeffs(1)./(x.^(pq(end))); 
end

for i=2:nc
    y = (x .* y + coeffs(i)./(x.^(pq(end))));
end



end
