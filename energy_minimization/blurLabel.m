function [MappedImage] = blurLabel(inputImage,D,lambda_0,rhats)
% inputImage: Blurry input image
% D: filtered likelihood histogram per pixel (3D array)
% lambda_0: Smoothness weighting
% rhats: Estimated r-value space being indexed by each z-element of D

    %nclasses = size(D,3); % Number of classes
    nclasses = size(rhats);     % Get total number of possible radii values
    xmax = size(inputImage,2);
    ymax = size(inputImage,1);
    
    % First pass: Label each pixel based on the Rhat index that minimizes D
    % Find the optimized radius based on filtered ML estimates
    labels = zeros(size(D(:,:,1))); % Minimizing indices of D
    for x = 1:xmax
        for y = 1:ymax
            labels(y,x) = find(D(y,x,:) == min(D(y,x,:)),1);
        end
    end
    size(labels)
    
    L = energyFunction(D,lambda0,labels);
    while 1==1% Until there is minimal change
        % Compute cuts for each class
        for n = 1:nclasses
           % Compute smoothness costs at each pixel for 8-nearest neighbors
           % Do binary graph cut on alpha-!alpha boundary
           % All pixels in alpha become member of current class
            labels = alphaExpand(labels,n);
        end
    end
end


function newLabels = alphaExpand(labels, alpha)
% Helper function to expand labels for a given class for the alpha
% expansion process.
% labels: Current labels for each pixel
% alpha: Current class label being expanded
    newLabels = labels;
    
    % Set node energies for source/sink costs
    % Nodes originating at alpha have infinite sink cost
    % Otherwise nodes have 
    
end

function energy = energyFunction(D,lambda0,labels)
% Energy/Cost function for alpha expansion
% D: Unitary cost table per pixel for label set
% lambda0: Pairwise cost scaling
% labels: Set of selected labels for each pixel
% Energy: Energy cost associated with the given label set
    unaryCost = 0;
    pairwiseCost = 0;
    lsmooth = localSmoothness(lambda0,labels);
    for i = 1:size(labels,1) % Iterate through to compute total energy
        for j = 1:size(labels,2)
            unaryCost = unaryCost + D(i,j,(labels(i,j)));
            pairwiseCost = pairwiseCost + lsmooth(i,j);
        end
    end
    energy = unaryCost + pairwiseCost;
end

function lV = localSmoothness(lambda0,labels)
% Local smoothness based on absolute label difference
% lambda0: Smoothness scaling factor
% labels: Set of current labels (radii) at each pixel

    xmax = size(labels,2);
    ymax = size(labels,1);
    labels = padarray(labels,[2 2],'symmetric');  % Pad image w/ extended boundary conditions
    V = zeros(size(labels))
    for x = 2:xmax+1
        for y = 2:ymax+1
            center = labels(y,x); 
            % Compute smoothness moment
            V(y,x) = (1/8).*(abs(center-labels(y-1,x-1)))+(abs(center-labels(y-1,x)))+(abs(center-labels(y-1,x+1)))+(abs(center-labels(y,x-1)))+(abs(center-labels(y,x+1)))+(abs(center-labels(y+1,x-1)))+(abs(center-labels(y+1,x)))+(abs(center-labels(y+1,x+1)));
        end
    end
    lV = lambda0.*V;
end