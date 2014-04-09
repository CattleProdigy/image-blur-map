function [blurMap, noise, blurredImage] = blurGenerator(inputImage, blurSpace, nvar)
% Function to generate a randomly corrupted image from spatially varying
% blurring with additive noise.
% inputImage: Uncorrupted image
% blurSpace: Finite discrete set of blur parameters to use i.e. 0.1:0.1:8
% foregroundMask: Binary image mask defining an object as being in the
% foreground
% nvar: Additive white Gaussian noise variance
% blurMap: Pixel by pixel blur radius map
% noise: Generated noise
% blurredImage: input image with blur and noise applied
   

    % Apply blur map to input images
    inputImage = double(inputImage)./255.0;
    blurMap = generateBlurMap(size(inputImage),blurSpace);
    blurredImage = blurByMap(inputImage,blurMap,blurSpace);
    noise = nvar * randn(size(inputImage)); % Generate additive white noise
    blurredImage = blurredImage + noise;    % Apply additive white noise
    
    figure(1)
    imagesc(blurredImage);
    colorbar;
    figure(2);
    %imshow(blurMap./max(max(blurMap)));
    imagesc(blurMap);
    colorbar;
end

function [blurImg] = blurByMap(inputImage, blurMap, blurSpace)
    % Perform local convolution
    xmax = size(inputImage,2);
    ymax = size(inputImage,1);
    blurImg = zeros(size(inputImage));
    % Perform and mask multiple convolutions for fast computation 
    for i = 1:length(blurSpace)
        r = blurSpace(i);
        psf = fspecial('disk',r);
        %psf = fspecial('gaussian',[r,r]);
        blurTemp = conv2(inputImage,psf,'same');
        mask = (blurMap == blurSpace(i));
        blurImg = blurImg + mask.*blurTemp; % Mask
    end
    
end

function [blurMap] = generateBlurMap(imSize,blurSpace)
% Generates an IID random field and then median filters it to get clusters
    xsize = imSize(2);
    ysize = imSize(1);
    blurMap = zeros(imSize);
    for i = 1:length(blurSpace)
        rfield = rand(ysize,xsize);
        disp(mat2str(i))
        blurMap = blurMap + round(medfilt2(rfield,[20,20],'symmetric'));
    end
    
    %randMap = ceil(length(blurSpace).*rand(ysize,xsize));
    %figure(4);
    %imagesc(randMap);
    %colorbar;
    %for x = 1:xsize
    %    for y = 1:ysize
    %        blurMap(y,x) = blurSpace(randMap(y,x));
    %    end
    %end
    %blurMap = medfilt2(blurMap,[30, 30],'symmetric');
    %gfilt = fspecial('gaussian',[20 20], 1);
    %blurMap = ceil(imfilter(blurMap,gfilt));
end