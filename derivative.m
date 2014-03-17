function gi = derivative(in)
    in = (double(in));
    [n, m]= size(in);
    ti = make_gabor_filters(41);
    gi = gabor_gradient_field(in, ti);
%     for i = 1:(n-42)
%         disp(i);
%         tic;
%         for j = 1:(m-42)
%             gi = gabor_gradient_field(in(i:i+40,j:j+40), ti);
%         end
%         toc;
%     end
end