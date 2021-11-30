close all
loadstrokes;
data = datanormalization2d(data);
class = class-1;
seed = rng;
[model1, C1, y_test1, acc1, acc1_total] = augmented_model(data,class,0.5,2,seed);
[model2, C2, y_test2, acc2, acc2_total]=spliting_model(data,class,2,0.5,2,seed);
majority_voting_ensemble(C1,y_test1,acc1, acc1_total, C2,y_test2,acc2, acc2_total)