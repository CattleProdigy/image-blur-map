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
    %oneMap = ones(size(inputImage,1),size(inputImage,2)/2);
    %blurMap = [15 .* oneMap 3.*oneMap];
    blurredImage = blurByMap(inputImage,blurMap,blurSpace);
    %blurredImage = blurByMap(inputImage,blurMap,[3,15]);
    noise = nvar * randn(size(inputImage)); % Generate additive white noise
    blurredImage = blurredImage + noise;    % Apply additive white noise
    
    figure(1)
    subplot(1,2,1);
    %imagesc(inputImage);
    imshow(inputImage);
    axis equal;
    colormap('gray');
    colorbar;
    subplot(1,2,2);
    %imagesc(blurredImage);
    imshow(blurredImage);
    axis equal;
    %colormap('gray');
    %colorbar;
    figure(2);
    %imshow(blurMap./max(max(blurMap)));
    size(blurMap)
    imagesc(blurMap);
    colorbar;
end


function [blurMap] = generateBlurMap(imSize,blurSpace)
% Generates an IID random field and then median filters it to get clusters
    xsize = imSize(2);
    ysize = imSize(1);
    blurMap = blurSpace(1)*ones(imSize(1),imSize(2));
    
    blurMap = drawCircle(blurMap, round(size(blurMap,2)/2), round(size(blurMap,1)/2),20,5);
    for j = blurSpace
        for k = 1:round(100*rand)
            blurMap = drawCircle(blurMap,round(xsize*rand),round(ysize*rand),round(35*rand),j);
        end
    end
    % Draw random primitive geometry
    
%     for i = 1:length(blurSpace)
%         rfield = rand(ysize,xsize);
%         disp(mat2str(i))
%         blurMap = blurMap + round(medfilt2(rfield,[10,10],'symmetric'));
%     end
    
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

function [circImg] = drawCircle(inImg,xc,yc,r,value)
% Function to draw solid value disk on image
circImg = inImg;
for x = (xc-r):(xc+r)
    for y = (yc-r):(yc+r)
        if(((x-xc).^2+(y-yc).^2) <= r.^2)
            if((x <= size(circImg,2)) & (x >= 1))
                if((y<= size(circImg,1)) & (y>=1))
                    circImg(y,x) = value;
                end
            end
        end
    end
end
end