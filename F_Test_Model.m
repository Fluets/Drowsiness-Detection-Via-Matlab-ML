%% Classification performance on the training data
prediction = predict(classifier, featuresTestSet); %featuresTrainingSet swapped for featuresTestSet
% calculate the predicted classes using the trained classifier

confusionMatrix = confusionmat(labelTestSet, prediction); %labelTrainingSet swapped for labelTestSet
% calculate the confusion matrix
accuracy = (confusionMatrix(1,1)+confusionMatrix(2,2))/sum(sum(confusionMatrix))

% visulaise the confusion matrix using a heatmap
attentiveStateClasses = {'Focused State', 'Drowsy State'};
figure(2)
heatmap(attentiveStateClasses ,attentiveStateClasses ,confusionMatrix)