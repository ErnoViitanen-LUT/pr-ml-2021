loadstrokes;
DEBUG = true;
if ~exist('DEBUG', 'var')
        DEBUG = false;
end

startIndex = 80;

data=datanormalization(data);
if(DEBUG==true)
    plotstrokes(data,class,startIndex,3);


    %axis([0 1 0 1]);
end
