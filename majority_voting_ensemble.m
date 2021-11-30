function majority_voting_ensemble(C1,y_test1,acc1,acc1_total,C2,y_test2,acc2,acc2_total)
%Let's assume model accuracy and how sure it is be defined by the variable x
% be presented as [digit,acc,sureness] = model
%then we need to find such a function that will boost high accuracy and
%high sureness models to our voting system 
%then each model votes for one of the digit and the score of the vote
%is the function y. We choose the digit where y is the highest
test_class = zeros(1,length(y_test1));
test_data_size = length(test_class);
C2 = reshape(C2,10,test_data_size);
DEBUG=true;
% y1 = exp(1./(1-acc1));
% y2 = exp(1./(1-acc2));
C = C1.*(acc1'.*acc1_total) + C2.*(acc2'.*acc2_total);
[~,y_test] = max(C,[],1); %we choose the class which has the biggest value
y_test = y_test - 1; 

for digit = 0:9
    test_class(:,(digit)*(test_data_size/10)+1:(digit+1)*(test_data_size/10))=digit;
end

err = sum(y_test ~= test_class); % we compare our results with the expected values
acc = (test_data_size-err)/(test_data_size) % we compute the accuracy
if(DEBUG == true)
    figure
    confusion = confusionmat(test_class,y_test); %we compute the confusion matrix
    confusionchart(confusion)
    title('Voting')
end

end