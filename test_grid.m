loadstrokes;
DEBUG = true;
if ~exist('DEBUG', 'var')
        DEBUG = false;
end

%data=data(1:101)
%class=class(1:101)

data=datanormalization(data);

%testclass = mpl(data,class,data);
simple = simplify(data);
[startProbabilities,endProbabilities,sumProbabilities] = simpleprobability(simple,class);
predictedClass = simplepredict(data,startProbabilities,endProbabilities, sumProbabilities);

top4 = zeros(1,size(class,2));
for i=1:size(class,2)
    if any(class(i)==predictedClass(:,i))
        top4(i) = class(i);
    else
        top4(i) = predictedClass(1,i);
    end

end

figure
confusion = confusionmat(class,predictedClass(1,:));
confusionchart(confusion)

figure
confusion = confusionmat(class,top4);
confusionchart(confusion)


%simple
%startProbabilities
%endProbabilities

%startProbabilities = getProbabilities(simple,1)
%endProbabilities = getProbabilities(simple,2)

%summedStart = startProbabilities ./ (sum(startProbabilities) + sum(endProbabilities))
%summedEnd = endProbabilities ./ (sum(endProbabilities) + sum(startProbabilities))


%summedStart = [summedStart; 1:10]

if(DEBUG==true)
    startIndex = 80;
    plotstrokes(data,class,startIndex);
    %axis([0 1 0 1]);
end

%inputPoints = interactive_digit_input;
%inputPoints = datanormalization(inputPoints);
%inputPoints = datanormalization(cell2mat(data(404)))
%fprintf("done waiting...")
%simple = simplify(inputPoints);

%strokeStart = simple(1,:);
%strokeEnd = simple(2,:);
%startProbability = sortByColumn([summedStart(:,strokeStart) [0:9]'],1)'
%endProbability = sortByColumn([summedEnd(:,strokeEnd) [0:9]'],1)'

%startProbability = [summedStart(:,strokeStart) [0:9]']'
%endProbability = [summedEnd(:,strokeEnd) [0:9]']'

%sumProbability = sortByColumn([summedStart(:,strokeStart) + summedEnd(:,strokeEnd) [0:9]'],1)'


%plotstroke(inputPoints,sumProbability);







%startProbability = getProbabilityForRow(simple,1)
%endProbability = getProbabilityForRow(simple,2)

function predictedClass = simplepredict(test,startProbabilities,endProbabilities,sumProbabilities)
    N = size(test,2);
    predictedClass = zeros(4,N)
    
    for i=1:N
        stroke = cell2mat(test(i));
        simple = simplify(stroke);

        strokeStart = simple(1,:);
        strokeEnd = simple(2,:);

        %startProbability = sortByColumn([startProbabilities(:,strokeStart) [1:10]'],1)'
        %endProbability = sortByColumn([endProbabilities(:,strokeEnd) [1:10]'],1)'
        
        sumProbability = sortByColumn([(startProbabilities(:,strokeStart) + endProbabilities(:,strokeEnd)) / 2 [1:10]'],1)'

        %topRandom = randi([1,4]);
        predictedClass(:,i) = sumProbability(2,1:4);
    end
end
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

function interpolated_data = interpolate(data)
    len = length(data)
    for i = 1:len
        tmp = linear_interpolation(cell2mat(data(i)),10);
        [tmp_m, tmp_n] = size(tmp);
        data(i) = mat2cell(tmp,tmp_m,tmp_n);
    end
end
