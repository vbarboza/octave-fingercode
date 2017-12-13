function [V] = AADSector(gabor, mask)

V = zeros(1, size(gabor,3));
for i = 1 : size(gabor,3)
    temp    = gabor(:,:,i).*mask;  
    
    % P can be NaN if sector outside the image border
    P       = mean2(temp(mask == 1));
    xy      = find(mask);
    n       = size(xy,1);
    V(i)    = sum( abs(temp(xy) - P) ) / n ;                            % Eq. 20
end
end
 
