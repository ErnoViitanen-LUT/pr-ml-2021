function y_test = majority_voting_ensemble(data)
%Let's assume model accuracy and how sure it is be defined by the variable x
% be presented as [digit,acc,sureness] = model
%then we need to find such a function that will boost high accuracy and
%high sureness models to our voting system 
%then each model votes for one of the digit and the score of the vote
%is the function y. We choose the digit where y is the highest

load('models.mat');
load('new_split_model.mat');
load('modelBest.mat')

%Choose the best models
m1 = model_benchmark.intpol_model_attempt_4_train_r_90_dim_3;
m2 = model_benchmark.aug_model_attempt_2_train_r_80_dim_3;
m3 = split_models.split_model_attempt_3;
% m3 = model_benchmark.spl_model_attempt_5_train_r_85_dim_3;

interpolated_data = linear_interpolation(data,300);

data_cell = mat2cell(data,size(data,1),size(data,2));
data_cell_divided = hyperplane_division(data_cell,2);
data_mean = mean(data);

C = zeros(10,1);
c1 = zeros(10,300);
c2 = zeros(10,1);
c3 = zeros(10,4);
p_str = 'part_';

for digit = 0:9
    s = strcat("digit_",num2str(digit));
    for i = 1:size(c1,2)
        c1(digit+1,i) = mvnpdf(interpolated_data(i,:),m1.(s).mu(i,:),m1.(s).sigma);
    end
    c2(digit+1,1) = mvnpdf(data_mean',m2.(s).mu,m2.(s).sigma);
    for i = 1:2
        for j = 1:2
            part_str = strcat(p_str,num2str(2*(i-1)+j));
            x = cell2mat(data_cell_divided(i,j));
            mean_x = mean(x);
            try
                c3(digit+1,2*(i-1)+j) =  mvnpdf(mean_x',m3.(part_str).m.(s).mu,m3.(part_str).m.(s).sigma);
            catch ME
                c3(digit+1,2*(i-1)+j) = 0;
            end
        end
    end
end

for i = 1:2
        for j = 1:2
            part_str = strcat(p_str,num2str(2*(i-1)+j));
            c3(:,2*(i-1)+j) = c3(:,2*(i-1)+j).*m3.(part_str).acc';
        end
end

c1_sum = sum(c1,2);
c3_sum = sum(c3,2);

C1 = normalize_pdf(c1_sum);
C2 = normalize_pdf(c2);
C3 = normalize_pdf(c3_sum);

C1(C1 == 0) = eps;
C2(C2 == 0) = eps;
C3(C3 == 0) = eps;

acc1 = [0.6200 0.8600 0.9200 0.9600 0.7800 0.7200 0.8200 0.2800 0.9800 0.7000]; 
acc2 = [0.6200 0.6700 0.7700 0.1400 0.4500 0.6100 0.1700 0.1200 0.3400 0.7500];
acc3 = [0.6800 0.0000 0.6800 0.7200	0.0000 0.0533 0.6533 0.6533	0.7067 0.9200];

d = acc3 - acc1;

m_acc3 = zeros(1,10);
m_acc3(8) = d(8);

acc1_tot = 0.764;
acc2_tot = 0.464;
acc3_tot = 0.5067;

[C4,~] = simpleprediction(data,betterModel);
p_min = min(C4); %find digit with minimum pdf
p_max = max(C4); %find digit with maximum pdf
C_4 = (C4-p_min)./(p_max-p_min);

C = C_4;
% C1+(C3.*m_acc3');
% +(C3.*m_acc3')
% .*exp((m1.acc')+4*eps).^2 + C2.*exp((m2.acc')+4*eps).^2 + C3.*exp((m3.acc')+4*eps).^2;
[~,y_test] = max(C); %we choose the class which has the biggest value
y_test = y_test - 1; 

end