% Compute RMS Error for bilevel image

blurIdeal = [6*ones(100,100);3*ones(100,100)];

error = blurMap - blurIdeal;
RMSE = sqrt(mean2(error.^2))