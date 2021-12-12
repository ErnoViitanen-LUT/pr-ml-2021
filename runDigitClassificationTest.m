% runDigitClassificationTest
% Test trained models with testing data

loadTrainingStrokes;
ndata = normalize2D(data);
pTrain = 4/5;

[~,~,testData,testClass] = splitForTrainAndTest(ndata,class,pTrain);

[~,nTest] = size(testClass);
predictedClass = zeros(1,nTest);

fprintf("running digit classification test...\n");
for i=1:nTest
    test = cell2mat(testData(i));
    digit = digit_classify(test) + 1;
    predictedClass(i) = digit;
    fprintf("%d", digit)
end

data_size = size(testData,2);
err = sum(testClass ~= predictedClass); % we compare our results with the expected values
accuracy = (data_size-err)/(data_size) % we compute the accuracy

global hFig;
if ~hFig
    hFig = figure;   
end
confusion = confusionmat(testClass,predictedClass);
cm = confusionchart(confusion);
cm.Title = "Digit Classification";
drawnow;