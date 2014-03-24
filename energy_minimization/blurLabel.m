function [MappedImage] = blurLabel(inputImage,D,lambda_0,rhats)
    
    nclasses = size(D,3); % Number of classes
    xmax = size(inputImage,2);
    ymax = size(inputImage,1);
    
    % First pass: Label each pixel based on minimum D value
    % Find the optimized radius based on filtered ML estimates
    D_min = zeros(size(D(:,:,1)));
    for x = 1:xmax
        for y = 1:ymax
            D_min(y,x) = find(D(y,x,:) == min(D(y,x,:)),1);
        end
    end
    size(D_n)
    
    % Compute cuts for each class
    for n = 1:nclasses
       for x = 1:xmax
           for y = 1:ymax
      
       
           end 
       end
    end
end