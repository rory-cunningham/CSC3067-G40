clear all
close all

[images, labels] = loadPedestrianDatabase('pedestrian_test.cdataset',1);

for i = 1:size(images,1)
    image_temp2(:,:,i) = reshape(images(i,:),[160,96]);
end

 for i = 1:size(images,1)
     features(i,:) = hog_feature_vector(image_temp2(:,:,i));
 end

%Supervised training function that takes the examples and infers a model
model = KNNtraining(features, labels);

[images, labels] = loadPedestrianDatabase('pedestrian_train.cdataset',1);

for i = 1:size(images,1)
    image_temp2(:,:,i) = reshape(images(i,:),[160,96]);
end

 for i = 1:size(images,1)
     features(i,:) = hog_feature_vector(image_temp2(:,:,i));
 end

%For each testing image, we obtain a prediction based on our trained model
for i=1:size(features,1)
    
    testnumber= features(i,:);
    
    classificationResult(i,1) = KNNTesting(testnumber, model, 3);
    
end

comparison = (labels==classificationResult);
Accuracy = sum(comparison)/length(comparison);