% Insert Copyright notice!!!!
% 
function [blurMap] = blurLabelGCO(inputImage,D,V,rHats)
% inputImage: Blurry input image
% D: unary node cost: filtered likelihood histogram per pixel (D(r),y,x)
% V: scaled pairwise smoothnest node cost: absolute 1st order differences
% (V(r),y,x)
% rHats: Estimated r-value space being indexed by each z-element of D

% Compute Size Parameters
xSize = size(D,3); % Image x-size
ySize = size(D,2); % Image y-size
depth = size(D,1); % Size of discrete radius domain
nPixels = size(D,2).*size(D,3); % Total # of pixels

% Initialize GCO Object
h = GCO_Create(nPixels,size(rHats)); % GCO Object

% Serialize cost arrays to be depth x nPixels in size
Dser = reshape(D,depth,nPixels); % Note, check that this comes out correclty
Vser = reshape(V,depth,nPixels);

% Generate neighborhood weighting
NeighborArray = secondNeighborMatrix(xSize,ySize);

% Set cost parameters and graph relationships
GCO_SetDataCost(h,Dser);
GCO_SetSmoothCost(h,Vser);
GCO_SetNeighbors(h,NeighborArray);

% Run alpha-expansion on graph
GCO_Expansion(h);

% Recover labels (radii) and reformat
serLabels = GCO_GetLabeling(h);
blurMap = reshape(serLabels,ySize,xSize); % Deserialize radii

end


function [neighborMatrix] = secondNeighborMatrix(w,h)
% Function to generate neighboring node weights
% w: Image width
% h: Image height

    nPixels = w*h; % Compute total length of array
    % Generate 2nd row and then circulantly generate 1st row
    nrow2 = [[1 1 1],zeros(1,h-3),[1 0 1],zeros(1,h-3),[1 1 1],zeros(1,h-3),zeros(1,w*h-3)];
    nrow1 = circshift(nrow2,[0,-1]);
    % Preallocate giant neighborhood matrix
    neighborMatrix = zeros(nPixels,nPixels);
    % Fill in giant matrix
    for i = 1:nPixels
        neighborMatrix(i,:) = circshift(nrow1,[0,i-1]);
    end
end