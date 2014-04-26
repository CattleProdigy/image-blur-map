[ti, freqs] = make_gabor_filters(41);

a1s = [-10 -8 -6 -4 -2 0 2 4 6 8 10];
a2s = [2 8];

subplot = @(m,n,p) subtightplot (m, n, p, [0.001 0.005], [0.001 0.005], [0.001 0.005]);

sp_count = 1;
for i = 1:size(ti,1)
    for j = 1:size(ti,2)
        if (isempty(ti{i,j}))
            continue;
        end
        
        freq = freqs{i,j};
        a1 = freq(1);
        a2 = freq(2);
        if (ismember(a1, a1s) && ismember(a2,a2s))
            subplot(2,11,sp_count);


            
            
            imagesc(real(ti{i,j})');

            if (a1 == 0 && a2 == 2)
                title('Reproduced Gabor Filters');
            end
            colormap('gray')
            axis square
            axis off
            sp_count = sp_count + 1;
        end
        
    end
end