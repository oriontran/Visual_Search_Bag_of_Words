%takes about 5 minutes to run using 200 frames. uploaded kMeans using 300 words

%get proper filenames, paths, etc
addpath('./provided_code/');
framesdir = './frames/';
siftdir = './sift/';
fnames = dir([siftdir '/*.mat']);

[means,membership] = createVocab();

%finds two words that are farthest apart on the 
means_dist = dist2(means',means');
[~,row_max] = max(means_dist);
[M,col_max] = max(max(means_dist));

%make sure that each word chosen has at least 25 instances of the word. if
%not just use a nearby word
word1inds = find(membership == col_max);
word2inds = find(membership == row_max(col_max));
while(size(word1inds,1) < 25)
    if (col_max ~= 1)
        word1inds = find(membership == col_max - 1);
    elseif (col_max ~= 1500)
        word1inds = find(membership == col_max + 1);
    end
end
if (size(word2inds,1) < 25)
    if (row_max(col_max) ~= 1)
        word2inds = find(membership == row_max(col_max) - 1);
    elseif(row_max(col_max) ~= 1500)
        word2inds = find(membership == row_max(col_max) + 1);
    end
end

%find all patches and display for both words
figure
for i=1:25
    subplot(5,5,i);
    fname = [siftdir '/' fnames(feat2im(word1inds(i))).name];
    load(fname, 'imname', 'descriptors', 'positions', 'scales', 'orients');
    imname = [framesdir '/' imname];
    im = imread(imname);
    grayim = rgb2gray(im);
    distances = dist2(means(:,col_max)',descriptors);
    [M,I] = min(distances);
    patch = getPatchFromSIFTParameters(positions(I,:), scales(I), orients(I), grayim);
    imshow(patch);
end

figure
for i=1:25
    subplot(5,5,i);
    fname = [siftdir '/' fnames(feat2im(word2inds(i))).name];
    load(fname, 'imname', 'descriptors', 'positions', 'scales', 'orients');
    imname = [framesdir '/' imname];
    im = imread(imname);
    grayim = rgb2gray(im);
    distances = dist2(means(:,row_max(col_max))',descriptors);
    [M,I] = min(distances);
    patch = getPatchFromSIFTParameters(positions(I,:), scales(I), orients(I), grayim);
    imshow(patch);
end

kMeans = means';
save kMeans.mat kMeans
