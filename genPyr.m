function [ gaussian_pyr , laplacian_pyr] = genPyr( img,level )

gaussian_pyr = cell(1,level);
laplacian_pyr = cell(1,level);
gaussian_pyr{1} = im2double(img);
for p = 2:level
	gaussian_pyr{p} = impyramid(gaussian_pyr{p-1},'reduce');
end


for p = level-1:-1:1 %expand for lost pixels
	original_size = size(gaussian_pyr{p+1})*2-1;
	gaussian_pyr{p} = gaussian_pyr{p}(1:original_size(1),1:original_size(2),:);   
end
end
