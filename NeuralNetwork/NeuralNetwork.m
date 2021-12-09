function [ Responses ] = NeuralNetwork( Features, Labels, Test)

Responses = zeros(size(Test,1), 1);
Model = NeuralNetworkTraining( Features, Labels, false);

for i=1:size(Test,1)
    Responses(i) = NeuralNetworkTest(Model, Test(i,:));
end