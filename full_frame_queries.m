%takes about ten minutes to run

%get proper filenames, paths, etc
addpath('./provided_code/');
framesdir = './frames/';
siftdir = './sift/';
fnames = dir([siftdir '/*.mat']);
load kMeans.mat kMeans;

%images of choice
images=['friends_0000006168.jpeg'
        'friends_0000002619.jpeg'
        'friends_0000000280.jpeg'];

%create a matrix where each column is a histogram where the number of the
%rows corresponds to that same vocabulary word DONT TOUCH
histogram_matrix = [];
hist_indexes = [];
for i=1:num_sift_files
    fname = [siftdir '/' fnames(i).name];
    load(fname, 'imname', 'descriptors');
    [histogram,~] = createHistogram(descriptors, kMeans);
    histogram_matrix = cat(2,histogram_matrix,histogram);
    hist_indexes = cat(1,hist_indexes,imname);
end

%fill a matrix with normalized scalar product for each chosen image's
%histogram with every other images histogram and find the largest five ncps
for i=1:3
    fname = [siftdir '/' images(i,:) '.mat'];
    load(fname, 'imname', 'descriptors');
    [histogram,~] = createHistogram(descriptors, kMeans);
    
    largest_ncp_ind = [];
    hist_ncp = [];
    
    for j=1:size(histogram_matrix,2)
        ncp = normalizedScalarProduct(histogram,histogram_matrix(:,j));
        if(strcmp(hist_indexes(j,:),images(1,:)) == 1 || ...
            strcmp(hist_indexes(j,:),images(2,:)) == 1 || ...
            strcmp(hist_indexes(j,:),images(3,:)) == 1)
            continue    
        end
        hist_ncp = cat(2,hist_ncp,ncp);
    end
    [largest_ncp,largest_ncp_ind] = maxk(hist_ncp,5);

    figure;
    subplot(2,3,1);
    im = imread([framesdir '/' imname]);
    imshow(im);
    hold on;
    title('original');
    for j=1:5
        subplot(2,3,j+1);
        im = imread([framesdir '/' hist_indexes(largest_ncp_ind(j),:)]);
        imshow(im);
        hold on;
        title(['image ' j+48]);
    end
end
