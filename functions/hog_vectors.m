function [hog] = hog_vectors(images)
    hog = {zeros(1, 3000)};
    for i = 1:3000
        hog{i, :} = hog_feature_vector(images{i});
    end
    hog = cell2mat(hog);
end