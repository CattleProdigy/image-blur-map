function [blurMap, noise, blurredImage] = blurGenerator(inputImage, blurRange, foregroundMask, nvar)
% Function to generate a randomly corrupted image from spatially varying
% blurring with additive noise.
% inputImage: Uncorrupted image
% blurRange: [Min Max] Blur radius range allowed
% foregroundMask: Binary image mask defining an object as being in the
% foreground
% nvar: Additive white Gaussian noise variance
% blurMap: Pixel by pixel blur radius map
% noise: Generated noise
% blurredImage: input image with blur and noise applied
    % Generate MRF background blur map
    % Generate MRF foreground blur map
    % Apply blur map to input image
    bluredImage = blurByMap(inputImage,bmap);
    noise = nvar * randn(size(inputImage)); % Generate additive white noise
    blurredImage = blurredImage + noise;    % Apply additive white noise

end

function [blurImg] = blurByMap(inputImage, blurMap)
    % Perform local convolution
    xmax = size(inputImage,2);
    ymax = size(inputImage,1);
    for x = 1:xmax
        for y = 1:ymax
            % Get local window depending on blur size
            % Convolve local window with kernel
        end
    end
end