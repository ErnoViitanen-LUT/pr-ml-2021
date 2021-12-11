loadstrokes;
DEBUG = true;
if ~exist('DEBUG', 'var')
        DEBUG = false;
end

data=datanormalization(data);

%testclass = mpl(data,class,data);
simple = simplify(data);

startProbabilities = getProbabilities(simple,1)
endProbabilities = getProbabilities(simple,2)

summedStart = startProbabilities ./ (sum(startProbabilities) + sum(endProbabilities))
summedEnd = endProbabilities ./ (sum(endProbabilities) + sum(startProbabilities))

%summedStart = [summedStart; 1:10]

if(DEBUG==true)
    startIndex = 80;
    plotstrokes(data,class,startIndex,3);
    %axis([0 1 0 1]);
end

inputPoints = interactive_digit_input;
inputPoints = datanormalization(inputPoints);
%inputPoints = datanormalization(cell2mat(data(404)))
fprintf("done waiting...")
simple = simplify(inputPoints);

strokeStart = simple(1,:);
strokeEnd = simple(2,:);
startProbability = sortByColumn([summedStart(:,strokeStart) [0:9]'],1)'
endProbability = sortByColumn([summedEnd(:,strokeEnd) [0:9]'],1)'

%startProbability = [summedStart(:,strokeStart) [0:9]']'
%endProbability = [summedEnd(:,strokeEnd) [0:9]']'

sumProbability = sortByColumn([summedStart(:,strokeStart) + summedEnd(:,strokeEnd) [0:9]'],1)'


plotstroke(inputPoints,sumProbability);







%startProbability = getProbabilityForRow(simple,1)
%endProbability = getProbabilityForRow(simple,2)

function weightedProbability(startProb,endProb)
    numWeights = 4;
    for i=1:numWeights
        weight = startProb(:,1);
        endProb(1,find(endProb(2,:) == weight(2)))
        startProb(1,1);
    end
end

function sorted = sortByColumn(x,col)
    [~,idx] = sort(x(:,col),'descend'); % sort by distance in ascending order
    sorted = x(idx,:);   % sort the whole matrix using the sort indices
end


function probability = getProbabilities(data,row)
    probability = zeros(10,9);

    numRows = size(data,1);
    numCols = size(data,2);
    
    for i=1:numRows
        %probability(i,10) = i-1;
        %probability(11,i) = i;
        colend = i*100;
        colstart = colend-100+1;
        
        [a,b]=hist(data(row,colstart:colend),unique(data(row,colstart:colend)));
        %i
        %[a;b]
        %a = a/100;
        for j=1:size(b,2)
            k = b(j);
            %fprintf(i + " " + k + "j"+ j +". ")
            probability(i,k) = a(j);
            %s1(i,j) = a();              
        end
    end
end

function interpolated_data = interpolate(data)
    len = length(data)
    for i = 1:len
        tmp = linear_interpolation(cell2mat(data(i)),10);
        [tmp_m, tmp_n] = size(tmp);
        data(i) = mat2cell(tmp,tmp_m,tmp_n);
    end
end
