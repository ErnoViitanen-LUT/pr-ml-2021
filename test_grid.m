loadstrokes;
DEBUG = false;
if ~exist('DEBUG', 'var')
        DEBUG = false;
end

%data=data(1:101)
%class=class(1:101)

data=datanormalization(data);
    
n = size(data,2);
pTrain = 2/3;
pValidate = 0;
nTrain = ceil(pTrain * n);
nValidate = ceil(pValidate * n);
i = randperm(n);
trainData = data(i(1:nTrain));
trainClass = class(i(1:nTrain));
testData = data(i(nTrain+nValidate+1:end));
testClass = class(i(nTrain+nValidate+1:end));

%testclass = mpl(data,class,data);
simple = simplify(trainData);
[startProbabilities,endProbabilities,emptyProbabilities] = simpleprobability(simple,trainClass);

predictedClass = simpleprediction(testData,startProbabilities,endProbabilities,emptyProbabilities);

preClass = predictedClass(1,:);
%{
figure;
confusion = confusionmat(testClass,predictedClass(5,:));
cm = confusionchart(confusion);
cm.Title = "Start";
figure;
confusion = confusionmat(testClass,predictedClass(4,:));
cm = confusionchart(confusion);
cm.Title = "End";
figure;
confusion = confusionmat(testClass,predictedClass(3,:));
cm = confusionchart(confusion);
cm.Title = "Start + End";
figure;
confusion = confusionmat(testClass,predictedClass(2,:));
cm = confusionchart(confusion);
cm.Title = "Empty";


preClass = predictedClass(1,:);
fh = figure;
confusion = confusionmat(testClass,predictedClass(1,:));
cm = confusionchart(confusion);
cm.Title = "Start + End + Empty";
%}

data_size = size(testData,2);
err = sum(testClass ~= preClass); % we compare our results with the expected values
acc = (data_size-err)/(data_size) % we compute the accuracy


    fh = figure;
    confusion = confusionmat(testClass,predictedClass(1,:));
    cm = confusionchart(confusion);
    cm.Title = "Start + End + Empty";

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

    inputPoints = interactive_digit_input;
    inputPoints = datanormalization(inputPoints);
    fprintf("done waiting...")
    predicted = simplepredict(inputPoints,startProbabilities,endProbabilities,emptyProbabilities)
    plotstroke(inputPoints,predicted);
    
    %plotstrokes(data,class,startIndex);
    %axis([0 1 0 1]);
    fh = figure;
    confusion = confusionmat(testClass,predictedClass(1,:));
    cm = confusionchart(confusion);
    cm.Title = "Start + End + Empty";
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

function predictedClass = simplepredict(test,startProbabilities,endProbabilities,emptyProbabilities)
    [M,N] = size(test);
    predictedClass = zeros(5,N);
    M
    N
    if M ~= 1
        N = 1;
    end
    for i=1:N
        if M == 1
            stroke = cell2mat(test(i));
        else
            stroke = test;
        end
        simple = simplify(stroke);

        strokeStart = simple(1,:);
        strokeEnd = simple(2,:);
        strokeEmpty = simple(3:end,:);
        emptyProbability = zeros(10,1);

        %startProbabilities
        %strokeStart
        %startProbabilities(strokeStart,:)
        sortedStartProbability = sortByColumn([startProbabilities(strokeStart,:)' [1:10]'],1)';
        sortedEndProbability = sortByColumn([endProbabilities(strokeEnd,:)' [1:10]'],1)';

        K = size(strokeEmpty,1);
        
        for j=1:K
            if any(strokeEmpty(j))
                probabilitiesForEmptyGridPos = emptyProbabilities(strokeEmpty(j),:)';                
                emptyProbability(:,j) = probabilitiesForEmptyGridPos;
            end
        end
        
        sumEmptyProbability = sum(emptyProbability,2);
        sumProbability = [(startProbabilities(strokeStart,:) + endProbabilities(strokeEnd,:)) / 2]';
        %sumEmptyProbability + 

        sortedSumProbability = sortByColumn([sumProbability [1:10]'],1)';
        summedEmptyStartEnd = sumProbability + sumEmptyProbability;
        sortedEmptyStartEndProbability = sortByColumn([summedEmptyStartEnd [1:10]'],1)';


        sortedEmptyProbability = sortByColumn([sumEmptyProbability [1:10]'],1)';
                        
%sortedEmptyStartEndProbability
        %topRandom = randi([1,4]);
        predictedClass(1,i) = sortedEmptyStartEndProbability(2,1);
        predictedClass(2,i) = sortedSumProbability(2,1);
        predictedClass(3,i) = sortedEmptyProbability(2,1);
        predictedClass(4,i) = sortedStartProbability(2,1);
        predictedClass(5,i) = sortedEndProbability(2,1);

    end
end
    

function sorted = sortByColumn(x,col)
    [~,idx] = sort(x(:,col),'descend'); % sort by distance in ascending order
    sorted = x(idx,:);   % sort the whole matrix using the sort indices
end
