function [s, mask]= CreateROI (M, N, xc, yc, band_n, sector_n, sector_width) 
 
for i= 0 : sector_width*sector_n-1
        [y,x]   = meshgrid(1:N, 1:M);
        Ti      = floor(i/sector_n);                                    % Eq. 2
        theta_i = mod(i,sector_n)*(360/sector_n);                       % Eq. 3
        theta_j = mod(i+1,sector_n)*(360/sector_n);                     % Eq. 3
        r       = sqrt((x(:,:,:)-xc).^2+(y(:,:,:)-yc).^2);              % Eq. 4
        theta   = wrapTo360(atan2d((y(:,:,:)-yc),(x(:,:,:)-xc)));       % Eq. 5

        if  theta_j == 0                                        
            temp = (band_n*(Ti+1) <= r   &   r < band_n*(Ti+2)) &           ...
                   (theta_i <= theta     &   theta <= 360);     % Eq. 1
        else
            temp = (band_n*(Ti+1) <= r   &   r < band_n*(Ti+2))  &          ...
                   (theta_i <= theta     &   theta <= theta_j);  % Eq. 1
        end

        s(:,:,i+1) = temp;
    end

    mask = logical(max(s,[],3)) ;
end