function [nsp] = normalizedScalarProduct(im_histogram,other_histogram)
    sum1=0;
    sum2=0;
    sum3=0;
    for i=1:1500
        sum1 = sum1 + (im_histogram(i)*other_histogram(i));
        sum2 = sum2 + im_histogram(i)*im_histogram(i);
        sum3 = sum3 + other_histogram(i)*other_histogram(i);
    end
    nsp = sum1/(sqrt(sum2)*sqrt(sum3));
end
