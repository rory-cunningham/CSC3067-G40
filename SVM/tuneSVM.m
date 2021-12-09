%SVM software requires labels -1 or 1 for the binary problem
TrainingLabels(TrainingLabels==0)=-1;

CvLoss = zeros(7);

for kernalScalePower = -3:1:3
    kScale = 10 ^ kernalScalePower;
    
    for boxConstraintPower = -3:1:3
        C = 10 ^ boxConstraintPower;
        
        % Calculate the support vectors
        Model = fitcsvm(TrainingFeatures, TrainingLabels,'KernelScale',kScale,'KernelFunction','rbf','ClassNames',[-1,1], 'Standardize', true,'BoxConstraint', Inf);

        % Wrap so posterior probablities are returned in score.
        psModel = fitSVMPosterior(Model);

        % Cross validate the model.
        cvModel = crossval(psModel);
        [cvLabels, cvScore, cvCost] = kfoldPredict(cvModel);
        cvLoss = kfoldLoss(cvModel);

        disp(['KScale: ' num2str(10^kernalScalePower)]);
        disp(['C: ' num2str(10 ^ C)]);
        disp(['Loss: ' num2str(cvLoss)]);
        disp('');
    
        CvLoss(kernalScalePower + 6, boxConstraintPower + 6);
    end
end

save('CvLoss.mat', 'CvLoss');