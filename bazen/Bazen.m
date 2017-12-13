close all; clear all; clc;

    % Parameters
band_n          = 4;    % band number
sector_n        = 16;   % sector number
sector_w        = 20;   % sector width
direcetion_n    = 8;    % number of considered directions

    % Paths
current_dir     = '.'%uigetdir('.\Database');
db_dir          = '.\Database';
fc_dir          = [db_dir '\FC'];
image_fmt       = '.tif';
image_name      = dir(fullfile(current_dir,  ['*' image_fmt]));
image_name      = {image_name.name}';

mkdir(fc_dir);

tic
for image_n = 1 : 1 %size(image_name,1)
    disp(image_n);
        % Read image
    %I = imread(fullfile(current_dir,  image_name{image_n})) ;
    I = imread('84_2.tif');
    imwrite(I,'./Results/Original.jpg');
    
        % 0 and 12.5 degrees
    V = DetectFC(I,0, band_n, sector_n, sector_w, direcetion_n);
    W = DetectFC(I,-12.5, band_n, sector_n, sector_w, direcetion_n);

        % The whole feature array (10 templates as in the paper)
    VW = cat(3, V,W);

        % Create FC
    fidw = fopen([db_dir '\FC\' image_name{image_n}(1:strfind(image_name{image_n}, image_fmt)-1) '.txt'], 'w');
    fwrite(fidw, VW, 'double');
    fclose(fidw);
end
toc

    % Save FC
movefile([db_dir '\FC'], [db_dir '\FC_' current_dir((strfind(current_dir,'Database\')+size('Database\',2):end))]);