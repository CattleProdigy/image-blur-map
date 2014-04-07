im = imread('man-with-cellphone.PNG');
im = double(rgb2gray(im));

start_time = tic;

fprintf('Making filters...\n');
tic;
ti = make_gabor_filters(41);
toc;

gi = cell(size(ti));
sig_ni = cell(size(ti));
fprintf('\nCalculating Gabor Gradient Field...\n');
tic;
[gi sig_ni] = gabor_gradient_field(im, ti);
toc;

%%
fprintf('\nFitting Sample PSFs...\n');
tic;
[sig_i_coeffs, r_domain] = fit_psf(ti);
toc;

%%
fprintf('\nFinding most likely radii PSFs...\n');
tic;
[s, r] = ml_radius(im, gi, sig_i_coeffs, sig_ni);
toc;




fprintf('\nTotal ');
toc(start_time);



