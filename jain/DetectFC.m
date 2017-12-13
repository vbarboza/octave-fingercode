function [V] = DetectFC(I, angle, band_n, sector_n, sector_w, direction_n)

% Rotate
I = imrotate(I, angle, 'bicubic', 'crop');

% Reference point
[xc, yc]    = FindRP(I, 15);    % Should repeat for 15, 10 and 5 windows

% Sectors and bounding box
[s, mask]   = CreateROI(size(I,1), size(I,2), xc, yc, sector_w, sector_n, band_n);

% Normalization
ns          = NormalizeROI(double(I), s);

% Gabor
[gabor_img, gabor_set] = GaborROI(ns);

% FingerCodes
fc          = zeros(size(s, 3), direction_n);
for i = 1 : size(s, 3)
    fc(i,:)  =  AADSector(gabor_set, s(:,:,i));
end

% FingerCode Images
fcimg       = zeros(size(I,1), size(I,2), direction_n);
for i = 1 : size(s, 3)
    for o = 1 : direction_n
        fcimg(:,:,o) = fcimg(:,:,o) + s(:,:,i) * fc(i,o);
    end
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

% Saving results
prop  = regionprops(mask, 'BoundingBox');
bbox = cat(1, prop.BoundingBox);

output = mat2gray(imcrop(ns, bbox)); % Imagem normalizada
imwrite(output, './Results/Normalizada.jpg');

for o = 1 : direction_n
    output = mat2gray(imcrop(gabor_set(:,:,o), bbox)); % Orientações da filtragem
    imwrite(output, strcat('./Results/Gabor',num2str(o*22.5),'.jpg'));
end

output = mat2gray(imcrop(gabor_img, bbox)); % Imagem normalizada
imwrite(output, './Results/GaborRec.jpg');

for o = 1 : direction_n
    output = mat2gray(imcrop(fcimg(:,:,o), bbox)); % FingerCodes
    imwrite(output, strcat('./Results/FC',num2str(o*22.5),'.jpg'));
end

end