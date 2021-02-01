%takes 5 minutes when running visualize_vocabulary if this uses 200 frames (what i set it to in this), 
%but i uploaded a kMeans using 300 words for a more robust dataset and used 300 for all results

function [means,membership] = createVocab()
%get proper filenames, paths, etc
addpath('./provided_code/');
framesdir = './frames/';
siftdir = './sift/';
fnames = dir([siftdir '/*.mat']);

%prep for creating the vocabulary
num_sift_files = length(fnames);
randinds = randperm(num_sift_files);
vocab_features = [];

%provides a way to back track which feature came from which image of the
%images used to create the vocabulary
feat2im = [];

%create the vocabulary
for i=1:200
    fname = [siftdir '/' fnames(randinds(i)).name];
    load(fname, 'imname', 'descriptors', 'positions', 'scales', 'orients');
    vocab_features = cat(1,vocab_features,descriptors);
    for j=1:size(descriptors,1)
        feat2im = cat(1,feat2im,randinds(i));
    end
end
[membership,means,rms] = kmeansML(1500,vocab_features');
end
