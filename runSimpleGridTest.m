% runSimpleGridTest
% Test simple grid model with testing data

loadTrainingStrokes;
ndata = normalize2D(data);

for times=1:1
        
    [~,predictedClass] = simpleGridPrediction(testData,simpleGridModel);
    predictedClass = predictedClass(1,:); % get the sum with empty
    
    data_size = size(testData,2);
    err = sum(testClass ~= predictedClass); % we compare our results with the expected values
    accuracy = (data_size-err)/(data_size) % we compute the accuracy
    
    global hFig;
    if ~hFig
        hFig = figure;   
    end
    confusion = confusionmat(testClass,predictedClass);
    cm = confusionchart(confusion);
    cm.Title = "Start + End + Empty";
    drawnow;


end