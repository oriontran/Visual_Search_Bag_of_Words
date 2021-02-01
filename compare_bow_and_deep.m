%takes about one minute to run

%get proper filenames, paths, etc
addpath('./provided_code/');
framesdir = './frames/';
siftdir = './sift/';
fnames = dir([siftdir '/*.mat']);
load kMeans.mat kMeans;

%images of choice
images=['friends_0000004503.jpeg'
        'friends_0000000394.jpeg'];

for i=1:2
    fname = [siftdir '/' images(i,:) '.mat'];
    load(fname, 'imname', 'descriptors', 'deepFC7');
    [histogram,~] = createHistogram(descriptors, kMeans);
    choice_im_deep = deepFC7';
    image_name = imname;
    
    largest_ncp_ind = [];
    hist_ncp = [];
    deep_ncp = [];
    
    %ncp for histograms
    for j=1:size(histogram_matrix,2)
        ncp = normalizedScalarProduct(histogram,histogram_matrix(:,j));
        if(strcmp(hist_indexes(j,:),images(1,:)) == 1 || ...
            strcmp(hist_indexes(j,:),images(2,:)) == 1)
            continue    
        end
        hist_ncp = cat(2,hist_ncp,ncp);
    end
    [largest_ncp,largest_ncp_ind] = maxk(hist_ncp,10);
    
    %ncp for deepFC7
    for k=1:size(fnames,1)
        fname = [siftdir '/' fnames(k).name];
        load(fname, 'imname', 'deepFC7');
        if(strcmp(imname,images(1,:))==1||strcmp(imname,images(2,:))==1)
            continue    
        end
        ncp2 = normalizedScalarProduct(choice_im_deep,deepFC7');
        deep_ncp = cat(2,deep_ncp,ncp2);
    end
    [largest_ncp_deep,largest_ncp_ind_deep] = maxk(deep_ncp,10);
    
    %display BoW images
    figure;
    im = imread([framesdir '/' image_name]);
    imshow(im);
    hold on;
    title('original');
    figure;
    for j=1:10
        subplot(2,5,j);
        im = imread([framesdir '/' hist_indexes(largest_ncp_ind(j),:)]);
        imshow(im);
        hold on;
        title(['bow image ' j+48]);
    end
    
    %display deep images
    figure;
        im = imread([framesdir '/' image_name]);
    imshow(im);
    hold on;
    title('original');
    figure;
    for j=1:10
        subplot(2,5,j);
        im = imread([framesdir '/' hist_indexes(largest_ncp_ind_deep(j),:)]);
        imshow(im);
        hold on;
        title(['deep image ' j+48]);
    end
end
