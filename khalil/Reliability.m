function [reliability] = Reliability(I, W)
% Estimation of local ridge orientation (p. 89)
% "Adaptative Flow Orientation-Based Feature Extraction in Fingerprint
% Images" (Jain, 1995)

% Gradient components through Sobel masks
[Gx, Gy]    = imgradientxy(I, 'Sobel');

Gxx = Gx.^2;
Gxx = blockproc(Gxx, [W, W],                                            ...
                @(blk_struct) sum(blk_struct.data(:)) *                 ...
                ones(size(blk_struct.data)));
Gyy = Gy.^2;
Gyy = blockproc(Gyy, [W, W],                                            ...
                @(blk_struct) sum(blk_struct.data(:)) *                 ...
                ones(size(blk_struct.data)));
            
Gxy = (Gx.*Gy); 
Gxy = blockproc(Gxy, [W, W],                                            ...
                @(blk_struct) sum(blk_struct.data(:)) *                 ...
                ones(size(blk_struct.data)));

O   = atan2(2*Gxy,Gxx-Gyy)/2;
            
phix = cos(2*O);
phiy = sin(2*O);            



        %{
h   = fspecial('gaussian');
Gxx = imfilter(Gxx, h); 
Gyy = imfilter(Gyy, h);
Gxy = imfilter(Gxy, h) * 2;

den = sqrt(Gxy.^2 + (Gxx - Gyy).^2) + eps;
sen =  Gxy      ./den;
css = (Gxx-Gyy) ./den;

h   = fspecial('gaussian');
sen = imfilter(sen, h);
css = imfilter(css, h);

O   = pi/2 + atan2(sen,css)/2;
min_inertia = (Gyy+Gxx)/2 - (Gxx-Gyy).*css/2 - Gxy.*sen/2;

        %}
min_inertia = (Gyy + Gxx)/2 - (phix'.*Gxx - Gyy)/2 - (phiy'.*Gxy)/2;
max_inertia = Gyy + Gxx - min_inertia;
    
reliability = 1 - min_inertia./(max_inertia+.0001);
%reliability = reliability.*(den>.0001);

figure(),imshow(mat2gray(I)),impixelinfo();
figure(),imshow(mat2gray(reliability)),impixelinfo();

end
