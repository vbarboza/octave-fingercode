close all; clear all; clc;


band_n          = 4;    % band number
sector_n        = 16;   % sector number
sector_w        = 20;   % sector width
direcetion_n    = 8;    % number of considered directions

        % Read image
    I = imread('5_1.tif') ;
    
        % 0 and 12.5 degrees
    V = DetectFC(I,0, band_n, sector_n, sector_w, direcetion_n);