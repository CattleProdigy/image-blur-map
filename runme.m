%im = imread('flower2.bmp');
im = imread('blurry_buildings.bmp');
im1 = imfilter(128+80*randn(100,100),fspecial('disk',6),'symmetric');
im2 = imfilter(128+80*randn(100,100),fspecial('disk',3),'symmetric');
im = [im1;im2];
im(im<0) = 0; im(im>255) = 255;


im = imread('birdistheword2.bmp');


imColor = im;
if (ndims(im) == 3)
    im = rgb2gray(im);
end

im = double (im);
im = im./255 ;

% h = fspecial('disk',5');
% im2 = padarray(im,[5,5],'symmetric','both');
% im = conv2(im2,h,'same');
% im = im(6:end-5,6:end-5);



%%
start_time = tic;

fprintf('Making filters...\n');
tic;
[ti, freqs] = make_gabor_filters(41);
toc;

%%
fprintf('\nCalculating Gabor Gradient Field...\n');
tic;
nvar = 0.15/(255^2);
nvar = 1E-4;
[gi, sig_ni] = gabor_gradient_field(im, ti,nvar);
toc
%%
fprintf('\nFitting Sample PSFs...\n');
tic;
[sig_i_coeffs, pq] = fit_psf2(ti);
toc;

% %%
% likelihood_test(gi, sig_i_coeffs, sig_ni);

%%
fprintf('\nFinding most likely radii PSFs...\n');
tic;
[rcons_p, r_candidates, p_candidates] = ml_radius(im, gi, sig_i_coeffs, sig_ni, pq);
toc;

[ps, idx] =sort(p_candidates,3);

ps = ps(:,:,6:8);
rs = rcons_p(:,:,6:8);

%%

addpath([pwd ('\energy_minimization\')]);

labels = [0.1:0.1:8];
D = filterLikelihoods(ps,rs,labels);

blurMap = blurLabelGCO(imColor,D,labels);

%imagesc(blurMap);

fprintf('\nTotal ');
toc(start_time);

plot_ml_estimates;

compute_rmse;