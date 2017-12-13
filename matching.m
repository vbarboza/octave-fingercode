close all; clear all; clc;

    % Parameters
band_n          = 4;    % band number
sector_n        = 16;   % sector number
sector_w        = 20;   % sector width
direcetion_n    = 8;    % number of considered directions

workingDir = uigetdir('.\');

fingercode_fmt  = '.txt' ;
image_name      = dir(fullfile(workingDir,  ['*' fingercode_fmt]));
image_name      = {image_name.name}';


matched         = 0 ;
not_matched     = 0 ;

good_imgs       = size(image_name,1);
for image_n = 1:size(image_name,1)
    file    = fopen([workingDir '\' image_name{image_n}(1:strfind(image_name{image_n},fingercode_fmt)-1) fingercode_fmt]);
    query   = fread(file, 'double');
    query   = reshape(query, [band_n*sector_n 8 10]);
    query   = query(:,:,3);
    
    fclose(file);
    
    query_img_BASE  = image_name{image_n}(1:strfind(image_name{image_n},'_')-1) 
    
    if any(any(isnan(query))) 
        good_imgs   = good_imgs - 1;
        continue; 
    end
    
    min_dist = realmax;
    match_img_BASE  = 'NULL';
    for nbr_test    = 1 : size(image_name,1) 
        if nbr_test ~= image_n 
            file = fopen([workingDir '\' image_name{nbr_test}(1:strfind(image_name{nbr_test},fingercode_fmt)-1) fingercode_fmt]);
            FC_test = fread(file, 'double');
            FC_test = reshape(FC_test, [band_n*sector_n 8 10]);
            fclose(file);
                
            for z_test = 1 : 10
                dist = norm(query - FC_test(:,:,z_test));       
                if any(any(isnan(FC_test(:,:,z_test))))
                    continue;
                end        
                if min_dist > dist
                    min_dist        = dist;
                    match_img_BASE  = image_name{nbr_test}(1:strfind(image_name{nbr_test},'_')-1)
                end
            end
        end
    end
    
    if strcmp(query_img_BASE, match_img_BASE) 
        matched = matched + 1;
    elseif ~strcmp(match_img_BASE, 'NULL') 
        not_matched = not_matched + 1;
    end
end
        

OK      = matched / good_imgs * 100;
Not_OK  = not_matched / good_imgs * 100;

init    = strfind(workingDir, '_B') ;

workingDir2 = strrep(workingDir, workingDir(init:end), '');
if ~(exist([workingDir2 '_B' int2str(band_n) '_' num2str(OK,6) '%']) == 7)
   movefile(workingDir,  [workingDir2 '_B' int2str(band_n) '_' num2str(OK,6) '%'])
end