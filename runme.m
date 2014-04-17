im = imread('flower_test.jpg');
if (ndims(im) == 3)
    im = rgb2gray(im);
end
im = double (im);
im = im./255 ;

%%
start_time = tic;

fprintf('Making filters...\n');
tic;
[ti, freqs] = make_gabor_filters(41);
toc;

%%
fprintf('\nCalculating Gabor Gradient Field...\n');
tic;
[gi, sig_ni] = gabor_gradient_field(im, ti, 0.1/(255^2));
toc
%%
fprintf('\nFitting Sample PSFs...\n');
tic;
[sig_i_coeffs, r_domain] = fit_psf(ti);
toc;

% %%
% likelihood_test(gi, sig_i_coeffs, sig_ni);

%%
fprintf('\nFinding most likely radii PSFs...\n');
tic;
[rcons_p, r_candidates, p_candidates] = ml_radius(im, gi, sig_i_coeffs, sig_ni);
toc;

fprintf('\nTotal ');
toc(start_time);



