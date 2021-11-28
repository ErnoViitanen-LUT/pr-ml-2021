loadstrokes;
% DEBUG = true;
if ~exist('DEBUG', 'var')
        DEBUG = false;
end

data=datanormalization(data);
len = length(data)
for i = 1:len
    tmp = linear_interpolation(cell2mat(data(i)),10);
    [tmp_m, tmp_n] = size(tmp);
    data(i) = mat2cell(tmp,tmp_m,tmp_n);
end
if(DEBUG==true)
    startIndex = 80;
    plotstrokes(data,class,startIndex,3);


    %axis([0 1 0 1]);
end
