%%
function [neighborMatrix] = secondNeighborMatrix(w,h,colorPenaltyVector)
% Function to generate neighboring node weights for 2nd order neighbor
% matrix that is unidirectional (upper left triangular)
% w: Image width
% h: Image height
% Declare sparse matrix of size N,M
disp('Creating Neighbor Matrix');
neighborMatrix = sparse(w*h,w*h);
tic;
B = 100;

diags = B.*ones(w*h, 4).*repmat(colorPenaltyVector,1,4);

neighborMatrix = spdiags(diags, [1 (h) (h+1) (h+2)], neighborMatrix);

    endTime = toc;
    disp(['Neighbor Matrix Generation Complete in ' mat2str(endTime) 's']);
end