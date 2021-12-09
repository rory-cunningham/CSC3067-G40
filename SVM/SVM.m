clear all
close all

%% training
addpath ./SVM/SVM-KM
addpath ./functions
addpath ./Data

% Loading labels and images
sample = 20;
[images,labels] = loadPedestrianDatabase('./Data/pedestrian_train.cdataset', sample);

%Perform training
modelSVM = SVMTraining(images, labels);

%After calculating the support vectors, we can draw them in the previous
%image

save('./SVM/modelSVM.mat', 'modelSVM');

%% Testing 

[Testing_images, Testing_Labels] = loadPedestrianDatabase('./Data/pedestrian_test.cdataset', sample);

%for each testing images, we get a prediction 

for i=1:size(Testing_images,1)
    testNumber = Testing_images(i,:);
    [prediction, score] = SVMTesting(testNumber, modelSVM);
    classificationResult(i,1) = prediction;
    scores(i) = score;
end

comparison = (Testing_Labels == classificationResult);

Accuracy = sum(comparison/length(comparison));

