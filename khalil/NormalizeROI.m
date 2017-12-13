% Fingerprint image normalization (of each sector)

function [normalized] = NormalizeROI(I, s) 

M0 = 100; % desired mean
V0 = 100; % desired variance
norm_sector = zeros(size(s));

for i = 1 : size(s,3)
    roi = find(s(:,:,i) == 1);
    M   = mean2(I(roi));  % mean
    V   = std2(I(roi))^2; % variance
    
    N = zeros(size(I)) ;
    set1 = find((I >  M) .* s(:,:,i) == 1);
    set2 = find((I <= M) .* s(:,:,i) == 1);

    N(set1) = M0 + sqrt((V0 * (I(set1) - M).^2)/V);
    N(set2) = M0 - sqrt((V0 * (I(set2) - M).^2)/V);
    
    norm_sector(:,:,i) = N;                                             % Eq. 16
end

normalized =  max(norm_sector,[],3);
end