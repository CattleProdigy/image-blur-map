%function [recovered] = unblur(blurImg, blurMap,labels)
blurImg = rgb2gray(imColor);
% Compute inverse filtered responses
recovered = zeros(size(blurImg),'uint8');
for r = 1:length(labels)
   disp(['Current Radius: ' mat2str(r)]);
   flatmask = (blurMap == labels(r));
   if(size(blurImg,3) > 1)
       mask(:,:,1) = flatmask;
       mask(:,:,2) = flatmask;
       mask(:,:,3) = flatmask;
   else
       mask = flatmask; % Monochrome case
   end
   kernelSize = 3*ceil(labels(r));
   blurPSF =  fspecial('gaussian',kernelSize,labels(r));
   %blurFFT = fft2(blurPSF);
   %invblurPSF = abs(ifft2(1./blurFFT));
   %deblurSlice = double(imfilter(blurImg,invblurPSF,'symmetric'));
   deblurSlice = deconvlucy(blurImg,blurPSF);
   %deblurSlice = deconvreg(blurImg,blurPSF,size(blurImg,1)*size(blurImg,2)*5E-3);
   recovered = recovered + uint8(mask).*deblurSlice;
end

%end

