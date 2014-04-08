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
GCO_Delete(h);

end

function [neighborMatrix] = secondNeighborMatrix(w,h)
% Function to generate neighboring node weights for 2nd order neighbor
% matrix that is unidirectional (upper left triangular)
% w: Image width
% h: Image height
% Declare sparse matrix of size N,M
neighborMatrix = sparse(w*h,w*h);
    for x = 2:w-1
        for y = 2:h-1
           row = zeros(1,m*n);
           %row = sparse(1,w*h);
           row(x-1+(y*w)) = 1;
           row(x-1+(y-1)*w) = 1;
           row(x-1+(y+1)*w) = 1;
           row(x+(y-1)*w) = 1;
           neighborMatrix(x*y,:) = row;
        end
    end
end