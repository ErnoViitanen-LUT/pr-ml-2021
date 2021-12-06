
function predictedClass = simpleprediction(test,startProbabilities,endProbabilities,emptyProbabilities)
    [M,N] = size(test);
    predictedClass = zeros(5,N);
    if M ~= 1 % we are predicting only one stroke
        N = 1;
    end
    for i=1:N
        if M == 1 % we are using predictions to calcurate accuracy
            stroke = cell2mat(test(i));
        else
            stroke = test;
        end
        simple = simplify(stroke);

        strokeStart = simple(1,:);
        strokeEnd = simple(2,:);
        strokeEmpty = simple(3:end,:);
        emptyProbability = zeros(10,1);
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