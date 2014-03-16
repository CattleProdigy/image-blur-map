function out = derivative(in)
    in = double(in);
    %del = repmat([-1 0 1], 3, 1);
    out = conv2(in, del, 'same');
    [n, m]= size(in);
    for i = 5:(n-5)
        for j = 5:(m-5)
            subplot(2,1,1)
            imagesc(out(i:i+41,j:j+41));
            subplot(2,1,2);
            temp = out(i:i+41,j:j+41);
            hist(temp(:),1000);
            pause;
        end
    end
end

