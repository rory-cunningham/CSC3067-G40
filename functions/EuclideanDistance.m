function dEuc = EuclideanDistance(sample1, sample2)
%Function to obtain Euclidian distance between two points

dEuc = sqrt(sum((sample1 - sample2).^2, 2));

end