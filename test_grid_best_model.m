loadstrokes;
DRAW = false;
if ~exist('DRAW', 'var')
        DRAW = false;
end

%data=data(1:101)
%class=class(1:101)

data=datanormalization(data);
lastAccuracy = 0;
for iteration=1:1000    
    n = size(data,2);
    pTrain = 2/3;
    pValidate = 0;
    nTrain = ceil(pTrain * n);
    nValidate = ceil(pValidate * n);
    i = randperm(n);
    trainData = data(i(1:nTrain));
    trainClass = class(i(1:nTrain));
    testData = data(i(nTrain+nValidate+1:end));
    testClass = class(i(nTrain+nValidate+1:end));
    
    simple = simplify(trainData);
    modelSimple = simpleprobability(simple,trainClass);
    
    predictedClass = simpleprediction(testData,modelSimple);
    
    preClass = predictedClass(1,:);
    
    data_size = size(testData,2);
    err = sum(testClass ~= preClass); % we compare our results with the expected values
    accuracy = (data_size-err)/(data_size); % we compute the accuracy
    
    if accuracy > lastAccuracy
        fprintf("found better model " + iteration + " " +accuracy + "\n");
        betterModel = modelSimple;
        lastAccuracy = accuracy;
    end

end
if DRAW
fh = figure;
confusion = confusionmat(testClass,predictedClass(1,:));
cm = confusionchart(confusion);
cm.Title = "Start + End + Empty";
end
if(DRAW==true)
    startIndex = 80;

    inputPoints = interactive_digit_input;
    inputPoints = datanormalization(inputPoints);
    fprintf("done waiting...")
    predicted = simpleprediction(inputPoints,modelSimple)
    plotstroke(inputPoints,predicted);
    
    %plotstrokes(data,class,startIndex);
    %axis([0 1 0 1]);
    %fh = figure;
    %confusion = confusionmat(testClass,predictedClass(1,:));
    %cm = confusionchart(confusion);
    %cm.Title = "Start + End + Empty";
end
