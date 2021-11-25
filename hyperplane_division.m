function result = hyperplane_division(data,n)
% HYPERPLANE DIVISION
% Function divides a hyperplane into n^2 squares
% where 
% data - cell of a normalized hyperplane
% n - number of squares in a row/column
data = cell2mat(data);
result = cell(n);
for i = [1:n]
    for j = [1:n]
        temp = data(find(data(:,1) >= (i-1)/n & data(:,1) <= i/n & data(:,2) >= (j-1)/n & data(:,2) <= j/n),:);
        result(i,j) = mat2cell(temp,size(temp,1),size(temp,2));
    end
end
end