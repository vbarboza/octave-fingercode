function [filtered, set] = GaborROI(roi)

    % Gabor coefficients (500 dpi)
f = 0.1;
dx = 4.0;
dy = 4.0;

theta = degtorad([0, 22.5, 45, 67.5, 90, 112.5,135, 157.5]);

    % 33 x 33 neighborhood
[y,x] = meshgrid(-16:16, -16:16);
 
xx = zeros(size(y,1), size(y,2), size(theta, 2)) ;
for i = 1 : size(theta, 2)
    xx(:,:,i)  = x * cos(theta(1,i)) + y * sin(theta(1,i));             % Eq. 18
end
   
 yy = zeros(size(y,1), size(y,2), size(theta, 2)) ;
for i = 1 : size(theta, 2)
    yy(:,:,i)  = -x * sin(theta(1,i)) + y * cos(theta(1,i));            % Eq. 19
end
 
 gabor = zeros(size(y,1), size(y,2), size(theta, 2)) ;
 gabor = exp(-0.5*(xx.^2/dx^2 + yy.^2/dy^2)).*cos(2*pi*f*xx);   % Eq. 17
 
    % Filtering ROI
for i = 1 : size(theta, 2)
    set(:,:,i) = conv2(roi, gabor(:,:,i), 'same') ;
end
 
filtered = max(set,[], 3) ;
end