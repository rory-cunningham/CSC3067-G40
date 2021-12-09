function [Model] = NeuralNetworkTraining( TrainingFeatures, Labels, verbose )
%This is a very simple Neural Network adapted from https://uk.mathworks.com/help/deeplearning/ug/train-stacked-autoencoders-for-image-classification.html
%We use the Deeplearning Toolbox on to Matlab for the Neural Network
TrainingFeatures = TrainingFeatures.';
Labels = Labels.';

% Create a sparse matrix(very few 1 values)
sparseLabels = zeros(2, size(Labels, 2));
sparseLabels(1,:) = Labels ~= 1;
sparseLabels(2,:) = Labels == 1;

% Train the first autoencoder
auto = trainAutoencoder(TrainingFeatures,100, ...
    'MaxEpochs', 100, ...
    'ShowProgressWindow', verbose, ...
    'L2WeightRegularization',0.01, ...
    'ScaleData', true);

features = encode(auto,TrainingFeatures);

% Train a softmax layer, you train the softmax layer in a supervised fashion using labels for the training data
softmax = trainSoftmaxLayer(features, sparseLabels,'ShowProgressWindow', verbose, 'MaxEpochs', 100);

% Form a deep net by stacking 
Model = stack(auto, softmax);
[Model, tr] = train(Model, TrainingFeatures, sparseLabels);

view(Model);

end
