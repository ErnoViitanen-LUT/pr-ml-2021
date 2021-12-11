close all
clear all
clc
loadstrokes;
data = datanormalization2d(data);
class = class-1;
seed = rng;
data_len = length(data);
y_test = zeros(1,data_len);
DEBUG = true; 

for i = 1:data_len
    disp(i)
   y_test(1,i) = majority_voting_ensemble(cell2mat(data(i)));
end
if(DEBUG == true)
    err = sum(y_test ~= class); % we compare our results with the expected values
    acc = (data_len-err)/(data_len) % we compute the accuracy
    figure
    confusion = confusionmat(class,y_test); %we compute the confusion matrix
    confusionchart(confusion)
    title('Voting')
end