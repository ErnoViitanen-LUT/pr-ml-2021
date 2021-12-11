

%data=datanormalization(data)

d = cell2mat(data(101))

findRectPosition(d,"empty")
plotstroke(d,sumProbabilities);

function foundInPos = findRectPosition(sample,sampleType)
    foundInPos = 0;   

    sampleSize = size(sample,1);
sprintf("sample %s %d\n",sampleType,sampleSize)
    for pos=1:9
        if pos == 1 %bottomleft
            x=[0,1/3,1/3,0];
            y=[0,0,1/3,1/3];
        elseif pos == 2 %bottommiddle
            x=[1/3,2/3,2/3,1/3];
            y=[0,0,1/3,1/3];
        elseif pos == 3 %bottomright
            x=[1-1/3,1,1,1-1/3];
            y=[0,0,1/3,1/3];
        elseif pos == 4 %middleleft
            x=[0,1/3,1/3,0];
            y=[1/3,1/3,2/3,2/3];
        elseif pos == 5 %center
            x=[1/3,2/3,2/3,1/3];
            y=[1/3,1/3,2/3,2/3];
        elseif pos == 6 %middleright
            x=[1-1/3,1,1,1-1/3];
            y=[1/3,1/3,2/3,2/3];
        elseif pos == 7 %topleft
            x=[0,1/3,1/3,0];
            y=[1-1/3,1-1/3,1,1];
        elseif pos == 8 %topmiddle
            x=[1/3,2/3,2/3,1/3];
            y=[1-1/3,1-1/3,1,1];
        else %pos == 9 topright
            x=[1-1/3,1,1,1-1/3];
            y=[1-1/3,1-1/3,1,1];
        end
        in = inpolygon(sample(:,1),sample(:,2),x,y);
        if sampleType ~= "empty" && any(in)
            foundInPos = pos;
            break
        elseif sampleType == "empty" && ~any(in)
            
            if foundInPos == 0
                foundInPos = pos;
            else
                foundInPos = [foundInPos pos];
            end
        end
    end
end