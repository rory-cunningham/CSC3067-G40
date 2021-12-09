clear all;
close all;

%Random Num generator to differentiate runs
rng(1);

% Get the name and dir of the results file.
resultsFolder = strrep(datestr(datetime), ' ', '_');
resultsFolder = strrep(resultsFolder, ':', '-');
resultsFolder = ['results/' resultsFolder '/'];
mkdir(resultsFolder);
mkdir([resultsFolder 'images/']);

% Configure the options.
ExtractionOption = {'raw'};
ModelType = {'KNN'};
CrossValidation = false;

save([resultsFolder 'Options.mat'], 'ExtractionOption', 'ModelType');

% Run the full training / testing.
[ tPos, tNeg, fPos, fNeg ] = CreateModel( ExtractionOption, ModelType, CrossValidation, resultsFolder);

% Sum the resulting vectors.
TP = sum(tPos);
TN = sum(tNeg);
FP = sum(fPos);
FN = sum(fNeg);

N = TP + TN + FP + FN;

accuracy = (TN + TP) / N;
errorRate = (FN + FP) / N;
recall = TP / (TP +FN);
precision = TP / (TP+FP);
specificity = TN / (TN+FP);
f1 = 2*TP / (2*TP + FN + FP);
falseAlarmRate = FP / (FP+TN);

save([resultsFolder 'Metrics.mat'], ...
    'tPos', 'tNeg', 'fPos', 'fNeg', ...
    'TP', 'TN', 'FP', 'FN', 'N', ...
    'accuracy', 'errorRate', ...
    'recall', 'precision', ...
    'specificity', 'f1', ...
    'falseAlarmRate');

% Output the results to video.
videoFrames = getImages([resultsFolder 'images/']);
videoOut = VideoWriter([resultsFolder 'output.mp4'],'MPEG-4');
videoOut.FrameRate = 4;
videoOut.Quality = 100;

open(videoOut);
for i=1:size(videoFrames, 4)
    writeVideo(videoOut, videoFrames(:,:,i));
end
close(videoOut);