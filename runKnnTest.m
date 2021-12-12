% runKnnTest
% Test kNN model with testing data

if ~exist('knnModel','var')
    error("No model for kNN model testing found")
end

%loadTrainingStrokes;
%ndata = normalize2D(data);
%pTrain = 2/3;
%[~,~,testData,testClass] = splitForTrainAndTest(ndata,class,pTrain);

for K=2:6
        
    predictedClass = knnPredict(testData,knnModel,K);
    
    data_size = size(testData,2);
    err = sum(testClass ~= predictedClass); % we compare our results with the expected values
    accuracy = (data_size-err)/(data_size) % we compute the accuracy
    
    global hFig;
    if ~hFig
        hFig = figure;   
    end
    confusion = confusionmat(testClass,predictedClass);
    cm = confusionchart(confusion);
    cm.Title = "Voting";
    drawnow;


end