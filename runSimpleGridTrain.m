loadTrainingStrokes;
ndata = normalize2D(data);

lastAccuracy = -1;
numIterations = 1000;

fprintf("Finding the most accurate model from %d iterations...\n", numIterations);
for iteration=1:numIterations    
    n = size(ndata,2);
    pTrain = 2/3;
    pValidate = 0;
    nTrain = ceil(pTrain * n);
    nValidate = ceil(pValidate * n);
    i = randperm(n);
    trainData = ndata(i(1:nTrain));
    trainClass = class(i(1:nTrain));
    testData = ndata(i(nTrain+nValidate+1:end));
    testClass = class(i(nTrain+nValidate+1:end));
    
    simple = simpleGridSimplify(trainData);
    modelSimple = simpleGridProbability(simple,trainClass);
    
    [~,predictedClass] = simpleGridPrediction(testData,modelSimple);
    
    preClass = predictedClass(1,:);
    
    data_size = size(testData,2);
    err = sum(testClass ~= preClass); % we compare our results with the expected values
    accuracy = (data_size-err)/(data_size); % we compute the accuracy
    
    if accuracy > lastAccuracy
        fprintf("found more accurate model " + iteration + " " +accuracy + ", saved into simpleGridModel variable...\n");
        simpleGridModel = modelSimple;
        lastAccuracy = accuracy;
    end

end