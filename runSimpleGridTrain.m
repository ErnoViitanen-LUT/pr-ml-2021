% runSimpleGridTrain
% Train simple grid model using training data
clear all;
loadTrainingStrokes;
ndata = normalize2D(data);

lastAccuracy = -1;
numIterations = 1000;
pTrain = 2/3;

fprintf("Finding the most accurate model from %d iterations...\n", numIterations);
for iteration=1:numIterations    
    
    [trainData,trainClass,testData,testClass] = splitForTrainAndTest(ndata,class,pTrain);

    simple = simpleGridSimplify(trainData);
    modelSimple = simpleGridProbability(simple,trainClass);
    simpleGridModel = modelSimple;
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