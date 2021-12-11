% File used for training the models using various parameters
loadstrokes;
data = datanormalization2d(data);
class = class-1;

NUMBER_OF_ATTEMPTS = 5; %how many times we will test the model with the same parameters 

split_models = struct;
s_spl_m = "split_model_";

for attempt = 1:NUMBER_OF_ATTEMPTS
    % Spliting model
    s = strcat("attempt_",num2str(attempt));
    [model, ~, ~, acc, acc_total] = spliting_model(data,class,2,0.85,3);
    s_s = strcat(s_spl_m,s);
    split_models.(s_s) = model;
    split_models.(s_s).acc = acc;
    split_models.(s_s).acc_total = acc_total;
end