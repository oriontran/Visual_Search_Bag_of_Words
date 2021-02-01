function [histogram,feature2word] = createHistogram(image_features, vocab)
    %determine which word each feature in the image belongs to
    feature2word = zeros(size(image_features,1),1);
    distances = dist2(image_features,vocab);
    [~,feature2word] = min(distances,[],2);
    
    %create histogram using features
    [histogram] = histc(feature2word, 1:1500);
    
    if (size(histogram,1)==1)
        x = histogram';
        histogram = x;
    end
end
