%% Split the data into training and testing 
trainingRatio = 0.8;
x1 = ceil(length(focusedFeatures)*trainingRatio);

%% Training set 
featuresTrainingSet = [focusedFeatures(1:x1,:);drowsyFeatures(1:x1,:)];
labelTrainingSet = [focusedLabel(1:x1);drowsyLabel(1:x1)];

%% Test set
featuresTestSet = [focusedFeatures(x1+1:end,:);drowsyFeatures(x1+1:end,:)];
labelTestSet = [focusedLabel(x1+1:end);drowsyLabel(x1+1:end)];