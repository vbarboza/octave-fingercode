% O QUE SIGNIFICA NO ARTIGO: RESTRIC THE SEARCH FOR THE REFERENCE POINT...?

function [xc, yc] = FindRP(I, W)

    % Gradients
[Gx, Gy]    = imgradientxy(I, 'Sobel');

    % Orientation
Vx          = blockproc(2*Gx.*Gy, [W, W],                               ...
                        @(b)   sum(b(:)) *       ...
                                        ones(size(b)));   % Eq. 6
Vy          = blockproc(Gx.^2-Gy.^2, [W, W],                            ...
                        @(b)  sum(b(:)) *        ...
                                       ones(size(b)));    % Eq. 7
                                   
O           = .5 * (atan2(Vy , Vx));                                    % Eq. 8

    % Smooth
 Fx         = cos(2*O);                                                 % Eq. 9
 Fy         = sin(2*O);                                                 % Eq. 10
 
 Ffx        = blockproc(Fx, [W,W], @(b) b(1,1));      
 Ffx        = colfilt(Ffx, [5,5], 'sliding', @mean);                    % Eq. 11
 
 Ffy        = blockproc(Fy, [W,W], @(b) b(1,1));      
 Ffy        = colfilt(Ffy, [5,5], 'sliding', @mean);                    % Eq. 12
 
 Oo         = 0.5 * (atan2(Ffy, Ffx));                                  % Eq. 13
 
% figure(), imshow(Oo,[]), impixelinfo;                                 % Fig. 6c
 
    % Sine component
 E          = sin(Oo) ;                                                 % Eq. 14
 
    % Integral
 fun        = @(blk) IntegrateRegion(blk);
 a          = nlfilter(E, [2*5, 2*5], fun);
 
    % Maximum
 A          = zeros(size(I));
 A          = blockproc(a, [1 1], @(b) b * ones(W,W));
 A          = A(1:size(I,1), 1:size(I,2));
 [xc, yc]   = find(A == max(A(:)));
 
 M          = zeros(size(I));
 M(xc, yc)  = 1;  
 
 xc         = xc(1);
 yc         = yc(1);
 
 imwrite(imresize(mat2gray(Oo), size(I), 'nearest'), './Results/Orientacao.jpg');
 imwrite(mat2gray(A), './Results/Integral.jpg');
 
 figure()
 subplot(1,4,1), imshow(mat2gray(I),[]), hold on;
 subplot(1,4,2), imshow(mat2gray(Oo),[]), hold on;
 subplot(1,4,3), imshow(mat2gray(A),[]), hold on;
 subplot(1,4,4), imshow(mat2gray(I),[]), hold on;
 plot(yc, xc, 'ro', 'MarkerSize', 16,'LineWidth', 4);
 
end

function [A] = IntegrateRegion(blk)

[yy, xx] = meshgrid(1:size(blk,1), 1:size(blk,2)/2) ;

R = floor(size(blk,1)/2) ;
 
[array_dist, array_az] = norm([xx(:)- R, yy(:)- R]) ;
array_az = array_az - 90 ;

array_az = round( reshape(array_az, size(yy))) ;
array_az(array_az==-90) = 0 ;

array_dist = round(reshape(array_dist, size(yy))) ;

    % Fig. 7
mask_RI  =  and((array_az <= 45) | (array_az >= 135) , (array_dist <= R));
mask_RII = and(~mask_RI, (array_dist <= R));

eps = blk(1:R, 1:2*R) ;

A = sum(sum(eps(mask_RI)))  - sum(sum(eps(mask_RII)));                  % Eq. 15

end