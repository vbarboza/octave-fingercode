function [V] = DetectFC(I, angle, band_n, sector_n, sector_w, direction_n)
  
    % Rotate
I           = imrotate(I, angle, 'crop');

    % Reference point
[xc, yc]    = FindRP(I);    % Should repeat for 15, 10 and 5 windows

if isempty(xc) && isempty(yc)
    [CCx, CCy] = Jain(I, 15);
end

BW      = ~im2bw(I,graythresh(I));
   
CMass = regionprops(double(BW), 'Centroid') ;  

X   = [xc yc];
Ind = dsearchn(X, [CMass.Centroid(2) CMass.Centroid(1)]);
CCx = X(Ind,1);
CCy = X(Ind,2);

 subplot(1,4,4), imshow(mat2gray(I),[]), hold on;
plot(CCy, CCx, 'ro', 'MarkerSize', 16,'LineWidth', 4);
%hold off;
    
    % Sectors
[s, mask]   = CreateROI(size(I,1), size(I,2), CCx, CCy, sector_w, sector_n, band_n);

    % Normalization
ns          = NormalizeROI(double(I), s);
% imshow(ns,[]), impixelinfo;


    % Gabor
[gabor_img, gabor_set] = GaborROI(ns);
% figure, imshow(gabor_img,[]), impixelinfo;

    % FingerCodes
fc          = zeros(size(s, 3), direction_n);
for i = 1 : size(s, 3)
   fc(i,:)  =  AADSector(gabor_set, s(:,:,i));
end

    % 5 rotated FingerCOdes
z           = 1 ;
i           = 0:size(s, 3)-1;  % Sectors
j           = 1:direction_n;   % Directions
for R = -2 : 2
    a       = fc(mod((i+sector_n+R), sector_n) + floor(i/sector_n) * sector_n + 1, ...
            mod((j+7 + R),                                              ...
            direction_n) + 1                                            ...
            );                                                          % Eq. 21
    V(:,:,z)= a(1:band_n*sector_n, 1:direction_n) ;
    z       = z + 1 ;
end

end