close all

%B.2 decomposition using laplacian pyramids

image1 = im2double(imread('image1.jpg'));
image2 = im2double(imread('image2.jpg'));

[M N ~] = size(image1); %same size images


level = 6;

[gaussian1,laplacian1] = genPyr(image1,level); % the laplacian & gaussian pyramids of the 2 images
[gaussian2,laplacian2] = genPyr(image2,level);


%B.3 recomposition of images
% for the recomposition of the original image we just add the difference
% picture with the blured picture for every level
original1 = cell(1,level);
original2 = cell(1,level);
original1{level}= gaussian1{level};
original2{level}= gaussian2{level};
for i =level-1:-1:1
	original1{i} = laplacian1{i}+impyramid(original1{i+1},'expand');
	original2{i} = laplacian2{i}+impyramid(original2{i+1},'expand');
end
    
figure;
for i=1:level
subplot(2,level,i),subimage(gaussian1{i});
if(i~=level)
    subplot(2,level,i+level+1),subimage(laplacian1{i});
end
end

figure;
for i=1:level
subplot(2,level,i),subimage(gaussian2{i});
if(i~=level)
    subplot(2,level,i+level+1),subimage(laplacian2{i});
end
end

figure;
subplot(1,2,1),subimage(original1{1});
subplot(1,2,2),subimage(original2{1});




%B.4 blended image
v = N/2;
mask1 = zeros(size(image1));
mask1(:,1:v,:) = 1;
mask2 = 1-mask1;


gaussian_filter = fspecial('gauss',60,30);
mask1 = imfilter(mask1,gaussian_filter,'replicate');
mask2 = imfilter(mask2,gaussian_filter,'replicate');


[gmask1,lmask1] = genPyr(mask1,level);
[gmask2,lmask2] = genPyr(mask2,level);



blended = cell(1,level);
%blended_rec{level} = gblended1{level} + gblended2{level};
size(gmask1{level})
size(laplacian1{level})
for i =level-1:-1:1
	blended_a= gmask1{i}.*(impyramid(gaussian1{i+1},'expand')+laplacian1{i});
	blended_b= gmask2{i}.*(impyramid(gaussian2{i+1},'expand')+laplacian2{i});
    blended{i}=blended_a + blended_b;
end

%blended_image = mask1.*image1 + mask2.*image2;

a=(gmask1{1}.*gaussian1{1} + gmask2{1}.*gaussian2{1});
b=blended{1};
d=a-b;
figure;
imshow(blended{1});



%B.5 hybrid image, composition of different stages of the pyramid
hybrid1 = cell(1,level);
hybrid2 = cell(1,level);
hybrid1{level}= gaussian1{level};
hybrid2{level}= gaussian2{level};
for i =level-1:-1:1
	hybrid1{i} = laplacian2{i}+impyramid(hybrid1{i+1},'expand');
	hybrid2{i} = laplacian1{i}+impyramid(hybrid2{i+1},'expand');
end
figure;
subplot(1,2,1),subimage(hybrid1{1});
subplot(1,2,2),subimage(hybrid2{1});
