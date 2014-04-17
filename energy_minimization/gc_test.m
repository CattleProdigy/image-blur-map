clear all
close all

labels = 0.1:0.1:8;
nlabels = length(labels);
h = 200; w = 200;

D = zeros(nlabels,h,w);
for j = 1:nlabels
    D(j,:,:) = (0.8*rand(h,w));
end
D(30,h/4:3*h/4,w/4:3*w/4) = D(30,h/4:3*h/4,w/4:3*w/4)+0.8;
figure(99);
size(D(30,1:h,1:w))
imagesc(squeeze(D(30,1:h,1:w)))
figure(98);
bmap = blurLabelGCO(-log(D),labels);

% Q = zeros(2,h,w);
% Q(1,:,:) = 0.15*ones(h,w);
% for j = 1:h
%     for k = 1:w
%         if(j <(3*h/4) & j > h/4)
%             if(k < 3*w/4 & k > w/4)
%                 Q(2,j,k) = 0.75;
%             end
%         end
%     end
% end
% figure(99);
% QQ = Q(1,:,:) + Q(2,:,:);
% size(QQ(1))
% imagesc(QQ);
% colorbar;
% figure(100);
% %Q = Q + 0.2*randn(h,w);
% bqmap = blurLabelGCO(Q,[0 1]); % Binary labeling