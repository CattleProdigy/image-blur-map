im = imread('man-with-cellphone.PNG');
im = double(rgb2gray(im));

% Take Image Gradient
del = [1 -1];
gradient = conv2(im, del, 'same');

%i = 452
%j = 224
i = 453
j = 362

        window = gradient(i:i+40,j:j+40);
        subplot(1,2,1);
        imagesc(window);
        colorbar;
        colormap('gray');
        axis square;
        axis off;
        title('Gradient of Local Window');
        subplot(1,2,2);
        histfit(window(:),50,'normal');
        title('Historgram of Gradient Intensity Values w/ Gaussian Fit')
        axis square;
        drawnow;
        pause(0.1);
