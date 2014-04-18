% Insert Copyright notice!!!!
% 
%%
function [blurMap] = blurLabelGCO(inputImage,D,labels)
% inputImage: Blurry input image
% D: unary node cost: filtered likelihood histogram per pixel (D(r),y,x)
% rHats: Estimated r-value space being indexed by each z-element of D


D = infinityFilter(D); % Filter out very large values

addpath([pwd ('\energy_minimization\gco-v3.0\matlab\')]);

% Compute Size Parameters
xSize = size(D,3); % Image x-size
ySize = size(D,2); % Image y-size
depth = size(D,1); % Size of discrete radius domain
nPixels = size(D,2).*size(D,3); % Total # of pixels

% Initialize GCO Object
h = GCO_Create(nPixels,length(labels)); % GCO Object

% Serialize cost arrays to be depth x nPixels in size
Dser = reshape(D,depth,nPixels); % Note, check that this comes out correctly

% Generate neighborhood weighting
NeighborArray = secondNeighborMatrix(xSize,ySize);

% Set cost parameters and graph relationships
GCO_SetDataCost(h,Dser);

GCO_SetNeighbors(h,NeighborArray);

% Run alpha-expansion on graph
disp('Starting alpha-expansion');
tic;
GCO_Expansion(h);
endTime = toc;
disp(['Alpha-expansion complete in ' mat2str(endTime) 's']);
% Recover labels (radii) and reformat
serLabels = GCO_GetLabeling(h);

blurMap = reshape(serLabels,ySize,xSize); % Deserialize radii
blurMap = applyLabels(blurMap, labels);   % Apply actual blur labels
GCO_Delete(h);

% Label overlay on output image
imagesc(blurMap);
colorbar;
end



%%
function [radiiMap] = applyLabels(indexMap, labels)
% Function that applies actual radius values to blur map based on indices
    radiiMap = zeros(size(indexMap,1),size(indexMap,2));
    for x = 1:size(indexMap,2);
        for y = 1:size(indexMap,1);
            radiiMap(y,x) = labels(1,indexMap(y,x));
        end
    end
end

%% 
function [filteredD] = infinityFilter(D)
% Function to saturate the -log likelihood candidates
    filteredD = D;
    for i = 1:size(D,1)
        for j = 1:size(D,2)
            for k = 1:size(D,3)
                if (D(i,j,k) > 2^23)
                    filteredD(i,j,k) = 2^23;
                end
            end
        end
    end
end