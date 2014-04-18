%%
function [neighborMatrix] = secondNeighborMatrix(w,h)
% Function to generate neighboring node weights for 2nd order neighbor
% matrix that is unidirectional (upper left triangular)
% w: Image width
% h: Image height
% Declare sparse matrix of size N,M
disp('Creating Neighbor Matrix');
neighborMatrix = sparse(w*h,w*h);
tic;
B = 50000;

diags = B.*ones(w*h, 4);

neighborMatrix = spdiags(diags, [1 (h) (h+1) (h+2)], neighborMatrix);

% for y = 2:h-1
%     for x = 2:w-1
%             row = sparse(w*h,1);
%             %rowN = x.*y
%             %x.*y -(x+1+(y).*w)
%             
%             %x.*y-(x+1+(y-2).*w)
%            
%             row(x+1+(y-2).*w,1) = B;
%             row(x+1+(y-1).*w,1) = B;
%             row(x+1+y.*w,1) = B;
%             row(x+y.*w,1) = B;
%             
%             row(x+(y-2).*w,1) = B;
%             row(x-1+(y-2).*w,1) = B;
%             row(x-1+(y-1).*w,1) = B;
%             row(x-1+y.*w,1) = B;
%             
%             %row(x-1+(y-1).*(w+1),1) = B;
%             %row(x+1+(y-1).*w,1) = B;
%             %row(x+1+(y-2).*w,1) = B;
%             %row(x+1+(y).*w,1) = B;
%             %row(x+(y).*w,1) = B;
%             
%             %row(x-1+(y-1).*w,1) = B;
%             %row(x-1+(y).*w,1) = B;
%             %row(x+(y+1).*w,1) = B;
%             
% %           row(x-1+(y.*w),1) = B;
% %           row(x-1+(y-1).*w,1) = B;
% %           row(x-1+(y+1).*w,1) = B;
% %           row(x+(y-1).*w,1) = B;
% %            
% %           row(x+1+((y-1).*w),1) = B;
% %           row(x+1+(y).*w,1) = B;
% %           row(x+1+(y+1).*w,1) = B;
% %           row(x+(y+1).*w,1) = B;
%            
%            row = sparse(row);
%            neighborMatrix(:,x+(y-1).*w) = sparse(row);
%            
%         end
%     end

    endTime = toc;
    disp(['Neighbor Matrix Generation Complete in ' mat2str(endTime) 's']);
end