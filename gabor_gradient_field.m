function [gi, sig_ni] = gabor_gradient_field(im, ti, noise)

    % Take Image Gradient
    del = [1 -1];
    
    im2 = padarray(im,[0,1],'symmetric','both');
    grad = conv2(im2, del, 'valid');
    grad = grad(:,1:end-1);
    
    
    % Convolve the gradient field with each filter and
    % store the result in a cell array of the same size and layout
    % as the filters
    
    gi = zeros([size(im) size(ti,3)]);
    sig_ni = zeros([1, size(ti,3)]);
    
    for i = 1:size(ti,3)
        gi(:,:,i) = abs(conv2(grad, ti(:,:,i), 'same')).^2;
        ti_temp = padarray(ti(:,:,i),[0, 1],'symmetric','both');
        filter_gradient = conv2(ti_temp, del, 'full');
        filter_gradient = filter_gradient(:,2:end-1);
        sig_ni(:,i) = noise.*sum(sum(abs(filter_gradient).^2));
    end
    
    
%     gi = ti;
%     sig_ni = cell(size(ti));
%     for i = 1:size(ti,1)
%         for j = 1:size(ti,2)
%             if (isempty(ti{i,j}))
%                 continue;
%             end
%             
%             filter_gradient = conv2(ti{i,j}, del, 'same');
%             sig_ni{i,j} = 1.*sum(sum(abs(filter_gradient).^2));
%             gi{i,j} = conv2(gradient, ti{i,j}, 'same');
%         end
%     end
    
    % Take the square magnitude
    %gi = cellfun(@(x) abs(x).^2, gi, 'UniformOutput', false);
end

