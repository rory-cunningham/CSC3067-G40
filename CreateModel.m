function [ truePos, trueNeg, falsePos, falseNeg ] = final(FEOptions, COptions, crossVal, resultsFolder)
addpath ./functions
addpath ./Data
addpath ./pre-processing
addpath ./SVM
addpath ./KNearestNeighbour
addpath ./SlidingWindow
addpath ./NeuralNetwork

%% Setup

% Fetch correct objects from the dataset.
dataString = fileread('Data/test.dataset');
TestAnswers = parseTestAnswers(dataString);
save([resultsFolder 'TestAnswers.mat'], 'TestAnswers');

% Get the training set.
[TrainingImages, TrainingLabels] = getTrainingSet('Data/images/');

% Preprocess
ProcessedTrainingImages = PreProcess(TrainingImages);

save([resultsFolder 'TrainingImages.mat'], 'TrainingImages', 'TrainingLabels', 'ProcessedTrainingImages');
Loss = 'N/A';

%% Feature Extraction
feMethod = FEOptions(1);
switch feMethod{:}
    case 'raw'
        TrainingFeatures = rawpixel(ProcessedTrainingImages);
        featureExtractionFunc0 = @(X) rawpixel(X);
    case 'hog'
        TrainingFeatures = hog(ProcessedTrainingImages);
        featureExtractionFunc0 = @(X) hog(X);
end

if(size(FEOptions, 2) > 1)
    param = FEOptions(2);
    switch param{:}
        case '-pca'
            [TrainingFeatures, eigenVectors] = PCA(TrainingFeatures);
            featureExtractionFunc = @(X) PCAReduce(eigenVectors, featureExtractionFunc0(X));
    end
else
    featureExtractionFunc = featureExtractionFunc0;
end

save([resultsFolder 'TrainingFeatures.mat'], 'TrainingFeatures');

%% Train Model

classifierMethod = COptions(1);
switch classifierMethod{:}
    
    case 'KNN'
        if(size(COptions, 2) > 1)
            k = COptions(2);
            k = k{:};
        else
            k = 3;
        end
        
        Model = TrainingFeatures;
        
        if(crossVal)
            cvModel = fitcknn(TrainingFeatures, TrainingLabels, 'CrossVal', 'on', 'NumNeighbors', k); 
            Loss = kfoldLoss(cvModel);
        end
             
        validationMethod = @(X) KNNTest(Model, TrainingLabels, X, k);
    
    case 'SVM'
        Model = SVMTraining(TrainingFeatures, TrainingLabels);
        validationMethod = @(X) SVMTesting(Model, X);
        
        if(crossVal)
            cvModel = crossval(Model);
            Loss = kfoldLoss(cvModel);
        end
        
    case 'NeuralNetwork'
        Model = NeuralNetworkTraining(TrainingFeatures, TrainingLabels, true);
        validationMethod = @(X) NeuralNetworkTest(Model, X);
        
        if(crossVal)
            predFunc = @(XTRAIN,ytrain,XTEST) fullNet(XTRAIN,ytrain,XTEST);
            %Perform 10-fold cross validation
            Loss = crossval('mse',TrainingFeatures,TrainingLabels,'Predfunc', predFunc);
        end
end
disp(['Loss: ' num2str(Loss)]);

save([resultsFolder 'Model.mat'], 'Model', 'Loss');

%% Testing
TestImages = getImages('Data/pedestrian/');
GreyTestImages = uint8(zeros(480, 640, size(TestImages, 4)));
for i=1:size(GreyTestImages, 3)
    GreyTestImages(:,:,i) = rgb2gray(TestImages(:,:,:,i));
end

ProcessedTestImages = PreProcess(GreyTestImages);

save([resultsFolder 'TestImages.mat'], 'TestImages', 'ProcessedTestImages');

%True positive,true negative, false postive, false negative
truePos = zeros(size(ProcessedTestImages,3),1);
trueNeg = zeros(size(ProcessedTestImages,3),1);
falsePos = zeros(size(ProcessedTestImages,3),1);
falseNeg = zeros(size(ProcessedTestImages,3),1);

for i=1:size(ProcessedTestImages,3)
    [Objects, windowCount] = SlidingWindow(ProcessedTestImages(:,:,i), featureExtractionFunc, validationMethod);
    Objects = centerOrigin(Objects);
    Objects = suppressNonMax(Objects, 100);
    [ truePos(i), trueNeg(i), falsePos(i), falseNeg(i) ] = Evaluate(Objects, TestAnswers{i}, windowCount, 10);
    answers = cell2mat(TestAnswers{i}.');
    answers = [answers ones(size(answers,1), 1)*-1];
    Objects = [answers; Objects];
    
    %Show us the results
    ShowDetectionResult(TestImages(:,:,:,i), Objects, ['g';'b'], num2str(i, '%05u'), resultsFolder);
end
end