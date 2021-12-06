loadstrokes;
data = datanormalization2d(data);
class = class-1;

NUMBER_OF_ATTEMPTS = 5; %how many times we will test the model with the same parameters 

model_benchmark = struct;
intpol_acc_benchmark = zeros(NUMBER_OF_ATTEMPTS,10);
spl_acc_benchmark = zeros(NUMBER_OF_ATTEMPTS,10);
aug_acc_benchmark = zeros(NUMBER_OF_ATTEMPTS,10);

training_ratios = [0.5, 0.6, 0.7, 0.75, 0.8, 0.85, 0.9];
dims = [2,3];

s_int_m = "intpol_model_";
s_spl_m = "split_model_";
s_aug_m = "aug_model_";


for dim = dims
    for training_ratio = training_ratios
        for attempt = 1:NUMBER_OF_ATTEMPTS
            rng shuffle;
            seed = rng;
            s = strcat("attempt_",num2str(attempt),"_train_r_",num2str(round(training_ratio*100)),"_dim_",num2str(dim));
            disp('training...')
            disp(s)
            
            % Interpolating model
            [model, ~, ~, acc, acc_total] = interpolating_model(data,class,training_ratio,dim,300,seed,true);
            i_s = strcat(s_int_m,s);
            model_benchmark.(i_s) = model;
            model_benchmark.(i_s).acc = acc;
            model_benchmark.(i_s).acc_total = acc_total;
            intpol_acc_benchmark(attempt,:) = acc;
            
            % Spliting model
            
            [model, ~, ~, acc, acc_total] = spliting_model(data,class,2,training_ratio,dim,seed,false);
            s_s = strcat(s_spl_m,s);
            model_benchmark.(s_s) = model;
            model_benchmark.(s_s).acc = acc;
            model_benchmark.(s_s).acc_total = acc_total;
            spl_acc_benchmark(attempt,:) = acc;
            
            % Augmented model
            
            [model, ~, ~, acc, acc_total] = augmented_model(data,class,training_ratio,dim,seed,false);
            a_s = strcat(s_aug_m,s);
            model_benchmark.(a_s) = model;
            model_benchmark.(a_s).acc = acc;
            model_benchmark.(a_s).acc_total = acc_total;
            aug_acc_benchmark(attempt,:) = acc;
            
            disp('...done')
        end
        model_benchmark.intpol_acc_mean = mean(intpol_acc_benchmark,1);
        model_benchmark.spl_acc_mean = mean(spl_acc_benchmark,1);
        model_benchmark.aug_acc_mean = mean(aug_acc_benchmark,1);
    end
end