%% Prepare the dataset
% concatenate the extracted features for each EEG sample
% create the class label which corresponds for each sample/feature vector
% concatenate all feature vectors together and all class labels
% create feature vectors by combining both the energy and the MAD features
% I.E. each EEG sample will be represented by a 32-long feature vector 
% the first set of 14 feature values represent the energy features 
% the second set of 14 feature values represent the MAD features 
focusedFeatures=[energyFeaturesFocused, MADFeaturesFocused];

% Create the class label for all these feature vectors. This class, i.e. 
% focused, is attributed label value ZERO 
focusedLabel = zeros(length(focusedFeatures), 1); 

% Similarly, feature vectors and labels are created for the drowsy class 
% A value of ONE is used as the label for this class
drowsyFeatures=[energyFeaturesDrowsy, MADFeaturesDrowsy];
drowsyLabel = ones(length(drowsyFeatures), 1);

% The matrix featuresData will now hold the feature vectors for the entire dataset
% I.E. for all EEG samples from both classes
% Feature vectors for the focused class represent the first half 
% of the matrix rows followed by feature vectors representing the drowsy class. 
% The column array classLabels holds the desired class label for each 
% feature vector (i.e. row) of the featuresData matrix 
featuresData = [focusedFeatures; drowsyFeatures];
classLabels = [focusedLabel; drowsyLabel];