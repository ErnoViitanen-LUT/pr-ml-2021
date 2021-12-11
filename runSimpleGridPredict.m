
load simpleGridModel.mat;

inputStrokes = interactiveDigitInput;
ndata = normalize2D({inputStrokes});

[~,predictedClass] = simpleGridPrediction(ndata,simpleModel);
predictedClass = predictedClass(1,:) % get the sum with empty


