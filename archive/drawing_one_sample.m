inputPoints = interactive_digit_input;
inputPoints(:,3) = rand(size(inputPoints,1),1);
inputPoints = datanormalization2d(inputPoints);
digit_classify(inputPoints)

