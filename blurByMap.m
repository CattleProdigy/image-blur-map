function [blurImg] = blurByMap(inputImage, blurMap, blurSpace)
    % Perform local convolution
    blurImg = zeros(size(inputImage));
    % Perform and mask multiple convolutions for fast computation 
    for i = 1:length(blurSpace)
        
        r = blurSpace(i);
        
        if (r>0.6)
            psf = fspecial('gaussian',ceil(4.*r), r);
        else
            psf = [1];    
        end
        %psf = fspecial('gaussian',[r,r]);
        %blurTemp = conv2(inputImage,psf,'same');
        blurTemp = double(imfilter(inputImage,psf,'symmetric'));
        flatmask = (blurMap == blurSpace(i));
        if(size(inputImage,3) > 1)
            mask(:,:,1) = flatmask;
            mask(:,:,2) = flatmask;
            mask(:,:,3) = flatmask;
        else
            mask = flatmask;
        end
        blurImg = blurImg + mask.*blurTemp; % Mask
    end
    
end
