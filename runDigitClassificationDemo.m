% runDigitClassificationDemo
% Interactive digit classification for demo purposes

inputPoints = interactiveDigitInput;
if inputPoints
    inputPoints(:,3) = rand(size(inputPoints,1),1);
    inputPoints = normalize2D(inputPoints);    
    digit_classify(inputPoints)
end