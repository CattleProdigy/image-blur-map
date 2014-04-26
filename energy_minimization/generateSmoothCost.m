function [smoothCost] = generateSmoothCost(labels)
    smoothCost = zeros(length(labels));
    for i = 1:length(labels)
        currentLabel = labels(i);
        smoothCost(i,:) = abs(labels - currentLabel);
    end
end
