im = imread('flower2.bmp');
imColor = im;

if (ndims(im) == 3)
    im = rgb2gray(im);
end
im = double (im);
im = im./255 ;
%im = imresize(im,0.5);
% 
% h = fspecial('disk',5');
% im2 = padarray(im,[5,5],'symmetric','both');
% im = conv2(im2+1e-7.*randn(size(im2)),h,'same');
% im = im(6:end-5,6:end-5);
% 

x = 1:256; y = x;
[xx yy ] = ndgrid(x,y);
blurmap= 3.*xx./256 + yy./256 + 1;
blurmap_quant = round(blurmap.*10)./10;

imblur = blurByMap(im,blurmap_quant, unique(blurmap_quant));
im = imblur;



%%
start_time = tic;

fprintf('Making filters...\n');
tic;
[ti, freqs] = make_gabor_filters(41);
toc;

%%
fprintf('\nCalculating Gabor Gradient Field...\n');
tic;
[gi, sig_ni] = gabor_gradient_field(im, ti, 1E-6);
toc
%%
fprintf('\nFitting Sample PSFs...\n');
tic;
[sig_i_coeffs, pq, Ss] = fit_psf2(ti);
toc;

% %%
% likelihood_test(gi, sig_i_coeffs, sig_ni);

%%
fprintf('\nFinding most likely radii PSFs...\n');
tic;
[rcons_p, r_candidates, p_candidates] = ml_radius(im, gi, sig_i_coeffs, sig_ni, pq,Ss);
toc;

[ps, idx] =sort(p_candidates,3);

ps = ps(:,:,6:8);
rs = rcons_p(:,:,6:8);

%%

addpath([pwd ('\energy_minimization\')]);

labels = [0.1:0.1:8];
D = filterLikelihoods(ps,rs,labels);

blurMap = blurLabelGCO(im,D,labels);

imagesc(blurMap);

fprintf('\nTotal ');
toc(start_time);

plot_ml_estimates;
