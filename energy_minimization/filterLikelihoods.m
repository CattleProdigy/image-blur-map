function [D] = filterLikelihoods(ps,rs,labels)
% Function to perform discretized candidate likelihood filtering,
% normalization, and -log conditioning. 
% ps: Candidate likelihoods
% rs: Candidate values
% labels: Labels used (set up currently for nearest 0.1)
% D: Data cost filtered from likelihoods for use with energy minimization
    p = discretizeCandidates(ps,rs,labels);

    %p = recoord3d(ps);
    
    K = [1E-20 1E-12 1E-7 1E-3 1E-1 1 1E-1 1E-3 1E-7 1E-12 1E-20]; % Filter kernel
    xdim = size(p,3);
    ydim = size(p,2);       
    
    D = zeros(length(labels),size(ps,1),size(ps,2));
    for x=1:xdim
        for y = 1:ydim
            loc_filt = conv(squeeze(p(:,y,x)).',K,'same');
            loc_norm = norm(loc_filt,1); % 1-Norm of likelihood estimate
            column = round(-log(loc_filt./loc_norm));
            D(:,y,x) = column; %Store to filtered 
        end
    end
    
end

%% 
function p = discretizeCandidates(ps,rs,labels)
% Function to discretize candidate blur radii and construct a top-candidate
% label matrix
    p = zeros(length(labels),size(ps,1),size(ps,2));
    rd = round(rs.*10)./10; % Discretize the radii values
    % Insert likelihoods into 3D array
    for k = 1:length(labels)
        slice = squeeze((rd(:,:,1) == labels(k)).*ps(:,:,1) + (rd(:,:,2) == labels(k)).*ps(:,:,2) + (rd(:,:,3) == labels(k)).*ps(:,:,3));
        p(k,:,:) = slice;
    end
end

%%
function recoord = recoord3d(imat)
    recoord = zeros(size(imat,3),size(imat,1),size(imat,2));
    for k = 1:size(imat,3)
        recoord(k,:,:) = squeeze(imat(:,:,k));
    end
end