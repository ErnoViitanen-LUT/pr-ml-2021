close all
clear all
clc
loadstrokes;
class = class-1;
seed = rng;
data_len = length(data);
y_test = zeros(1,data_len);
DEBUG = true; 

for i = 1:data_len
   y_test(1,i) = digit_classify(cell2mat(data(i)));
end
if(DEBUG == true)
    err = sum(y_test ~= class); % we compare our results with the expected values
    acc = (data_len-err)/(data_len) % we compute the accuracy
    figure
    confusion = confusionmat(class,y_test); %we compute the confusion matrix
    confusionchart(confusion)
    title('Voting')
end