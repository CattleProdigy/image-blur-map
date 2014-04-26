function y = jinc( r )
    if (r == 0)
        y = 1;
    else
        y = 2*besselj(1,2*pi*r)/(2*pi*r);
    end
end
