function [x, y] = FindRP(I)

[ori, rel] = RidgeOrient(I, 1, 3, 3);

sp = rel < 0.1;
sp = find(sp ~= 0);
[x y] = ind2sub(size(I), sp); 


 figure()
 subplot(1,4,1), imshow(mat2gray(I),[]), hold on;
 subplot(1,4,2), imshow(mat2gray(ori),[]), hold on;
 subplot(1,4,3), imshow(mat2gray(rel),[]), hold on;

end