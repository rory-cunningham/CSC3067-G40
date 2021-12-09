function [confidence]= SVMTesting(model,features)
%Testing for SVM model, this implements the matlab function predict
%that predicts responses of linear regression models 

[prediction, score]= predict(model, features);

confidence = score(:, 2);

end