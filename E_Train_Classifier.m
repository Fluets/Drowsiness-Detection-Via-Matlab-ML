% Use the training set to train a classifier 
%classifier = fitctree(featuresTrainingSet, labelTrainingSet); %- Original

% Changed to fitcdiscr to fit experimental plan
classifier = fitcdiscr(featuresTrainingSet, labelTrainingSet);