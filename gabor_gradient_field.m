function gi = gabor_gradient_field(im, ti)

    % Take Image Gradient
    del = [1 -1];
    gradient = conv2(im, del, 'same');
    
    % Convolve the gradient field with each filter and
    % store the result in a cell array of the same size and layout
    % as the filters
    gi = ti;
    for i = 1:size(ti,1)
        for j = 1:size(ti,2)
            if (isempty(ti{i,j}))
                continue;
            end
            gi{i,j} = conv2(gradient, ti{i,j}, 'same');
        end
    end
end

