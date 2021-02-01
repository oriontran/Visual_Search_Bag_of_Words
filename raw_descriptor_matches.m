%get paths, filenames, and retrieve necessary matrices
addpath('./provided_code/');
fname = 'twoFrameData.mat';
load(fname, 'im1', 'im2', 'descriptors1', 'descriptors2', 'positions1',...
    'positions2', 'scales1', 'scales2', 'orients1', 'orients2');

%create polygon
imshow(im1);
oninds1 = selectRegion(im1, positions1);

%initialize and set matrix to hold sift descriptors of features in polygon
im1_sift_region = zeros(size(oninds1,1),128);
for i=1:size(oninds1,1)
    im1_sift_region(i,:) = descriptors1(oninds1(i),:);
end

%find all euclidean distances under a threshold value of .15
eucdist = dist2(im1_sift_region, descriptors2);
[I,J] = find(eucdist < .175);

%display the second image with sift patches
figure;
imshow(im2);
displaySIFTPatches(positions2(J,:), scales2(J), orients2(J), im2); 
