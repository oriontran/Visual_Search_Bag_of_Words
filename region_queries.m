addpath('./provided_code/');
framesdir = './frames/';
siftdir = './sift/';
fnames = dir([siftdir '/*.mat']);
load kMeans.mat kMeans;

%images of choice
images = ['/friends_0000001131.jpeg';
          '/friends_0000002022.jpeg';
          '/friends_0000002332.jpeg';
          '/friends_0000001954.jpeg'];

for i=1:4
    %find an image and get a region of interest
    fname = [siftdir '/' images(i,:) '.mat'];
    load(fname, 'imname', 'descriptors', 'positions');
    im = imread([framesdir '/' imname]);
    figure;
    oninds = selectRegion(im, positions);
    
    %initialize and set matrix to hold sift descriptors of features in polygon
    im_sift_region = zeros(size(oninds,1),128);
    for j=1:size(oninds,1)
        im_sift_region(j,:) = descriptors(oninds(j),:);
    end
    [histogram,~] = createHistogram(im_sift_region, kMeans);
    
    %find largest normalized scalar products
    largest_ncp_ind = [];
    hist_ncp = [];
    for j=1:size(histogram_matrix,2)
        ncp = normalizedScalarProduct(histogram,histogram_matrix(:,j));
        if(strcmp(hist_indexes(j,:),images(1,:)) == 1 || ...
            strcmp(hist_indexes(j,:),images(2,:)) == 1 ||...
            strcmp(hist_indexes(j,:),images(3,:)) == 1)
            continue    
        end
        hist_ncp = cat(2,hist_ncp,ncp);
    end
    [largest_ncp,largest_ncp_ind] = maxk(hist_ncp,5);
    
    %display the five closest matches
    figure;
    subplot(2,3,1);
    im = imread([framesdir '/' imname]);
    imshow(im);
    hold on;
    title('original');
    for k=1:5
        subplot(2,3,k+1);
        im = imread([framesdir '/' hist_indexes(largest_ncp_ind(k),:)]);
        imshow(im);
        hold on;
        title(['image ' k+48]);
    end
end
