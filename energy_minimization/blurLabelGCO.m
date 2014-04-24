% Insert Copyright notice!!!!
% 

%%
function [blurMap] = blurLabelGCO(inputImage,D,labels)
% inputImage: Blurry input image
% D: unary node cost: filtered likelihood histogram per pixel (D(r),y,x)
% labels: Estimated r-value space being indexed by each z-element of D

D(D > 2^23) = 2^23; % Saturate values to 2^23
colorPenalties = computeColorPenalties(inputImage,1);
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
penaltySer = reshape(colorPenalties,1,nPixels).'; % Serialize color penalty
% Generate neighborhood weighting
NeighborArray = secondNeighborMatrix(xSize,ySize,penaltySer);

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
function [colorPenalties] = computeColorPenalties(inputImage,varLambda)
% Function to compute local color roughness penalty (for color images only)
    colorPenalties = ones(size(inputImage,1),size(inputImage,2));
    if(size(inputImage) == 3)
        penaltyFilter = [-1 -1 -1; -1 8 -1; -1 -1 -1]./8; 
        filtPenalties = imfilter(inputImage,penaltyFilter);  % Filter color channel differences
        colorPenalties(:,:) = exp(-1.*sqrt(squeeze(filtPenalties(:,:,1)).^2 + squeeze(filtPenalties(:,:,2)).^2 + squeeze(filtPenalties(:,:,3).^2))./(2*varLambda)); % Take 2-norm penalty along channels
    end
end

