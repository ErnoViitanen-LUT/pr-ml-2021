load simpleGridModel.mat;
ndata = normalize2D(data);

for times=1:100
    n = size(ndata,2);
    pTrain = 1/3;
    pValidate = 0;
    nTrain = ceil(pTrain * n);
    nValidate = ceil(pValidate * n);
    i = randperm(n);
    trainData = ndata(i(1:nTrain));
    trainClass = class(i(1:nTrain));
    testData = ndata(i(nTrain+nValidate+1:end));
    testClass = class(i(nTrain+nValidate+1:end));
        
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