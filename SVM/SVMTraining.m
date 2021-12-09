function [model] = SVMTraining(features, labels)
%This is a function to train a SVM ML Model, it implements fitcsvm which is a matlab
%function that trains support vector machine (SVM) classifier for one-class and binary classification
% Posterior probablilties are also returned(probability of a random event or an
% uncertain proposition)

%labels that are -1 or 1 for the binary problem(pos/neg)
labels(labels==0)=-1;

model = fitcsvm(features, labels,'KernelFunction','linear','ClassNames',[-1,1], 'Standardize', true,'BoxConstraint', 0.1);

model = fitSVMPosterior(model);



end