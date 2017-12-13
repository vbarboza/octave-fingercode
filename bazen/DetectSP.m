% In this function, we implement the singular point detection method proposed 
% by Bazen and Gerez, 2002 [1].
%
% Reference: 
% [1] - Bazen and Gerez, 2002. Systematic Methods for the Computation of the 
%       Directional Fields and Singular Points of Fingerprints, PAMI.
%
%
% author: Raoni F. S. Teixeira (raoniteixeira <at> gmail <dot> com)

function [CCx CCy CDx CDy] = DetectSP(im)

[N,M] = size(im);
im    = im2double(im);

dy = fspecial('sobel');
dx = dy';

% Eq. 1
Gx = imfilter(im, dx);
Gy = imfilter(im, dy);
s  = sign(Gx);
Gx = s.*Gx;
Gy = s.*Gy;

% Eq. 7
Gxx = Gx.^2;
% Eq. 8
Gyy = Gy.^2;
% Eq. 9
Gxy = (Gx.*Gy);

sigma = 6;
wsize = 6*sigma;
W     = fspecial('gaussian',  [wsize, wsize], sigma);

Gxx = imfilter(Gxx, W);
Gyy = imfilter(Gyy, W);
Gxy = imfilter(Gxy, W);

% Eq. 10
x = (Gxx-Gyy);
y = (2*Gxy);

L = ones(N, M);
TAN = atan2(y, x);
L( x >= 0) = TAN(x >= 0);
L(x < 0 & y >= 0) = TAN(x<0 & y >=0) + pi;
L(x < 0 & y < 0) = TAN(x<0 & y <0) - pi;

Phi = L*0.5;

Theta = zeros(N,M);
Theta(Phi <= 0) = Phi(Phi <= 0) + pi/2;
Theta(Phi > 0) = Phi(Phi > 0) - pi/2;


Jx = imfilter(2*Theta, dx);
Jy = imfilter(2*Theta, dy);

%mod 2 pi
Jx = MyMod(Jx);
Jy = MyMod(Jy);


Jx = imfilter(Jx, W);
Jy = imfilter(Jy, W);


Jydx = imfilter(Jy, dx);
Jxdy = imfilter(Jx, dy);

Jydx = imfilter(Jydx, W);
Jxdy = imfilter(Jxdy, W);

J = Jydx-Jxdy;

a = ones(4,4);

result = imfilter(J, a);
result((result < 2*pi) & (result > -2*pi)) = 0;


C = find(imregionalmax(result) == 1);
D = find(imregionalmin(result) == 1);

C = C(find(result(C) ~= 0) ) ;
D = D(find(result(D) ~= 0) ) ;

%horizontal and vertical coordinates of cores and deltas
[CCx CCy] = ind2sub(size(im), C); 
[CDx CDy] = ind2sub(size(im), D);

%Uncomment these lines to show the results

 figure()
 subplot(1,4,1), imshow(mat2gray(im),[]), hold on;
 subplot(1,4,2), imshow(mat2gray(Theta),[]), hold on;
 subplot(1,4,3), imshow(mat2gray(J),[]), hold on;
 
%figure, imshow(im), 
%figure, imshow(Theta), 
%figure, imshow(result, []); impixelinfo;
%figure, imshow(J, []); impixelinfo;
end
