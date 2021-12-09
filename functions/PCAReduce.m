function [ X ] = PCAReduce( eigenVectors, X )

X = X * eigenVectors;

end