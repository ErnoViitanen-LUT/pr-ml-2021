function simple = simplify(data)

    simple = [];
    if isa(data,'cell')
        dataLength = length(data(1,:));
        for i=1:dataLength
            sample = cell2mat(data(i));        
            simple = makeItSimple(sample,simple);
        end
        % restrict to 10 rows per column
    else
        sample = data;
        simple = makeItSimple(sample,simple);
        simple(end+1:10)=0;
    end
    simpleEnd = min(size(simple,1),10);
    simple = simple(1:simpleEnd,:);
end


function simple = makeItSimple(sample,simple)

    positions = getRectPositions(sample);

    sx = size(simple);
    sy = size(positions);
    a = max(sx(1),sy(1));
    simple = [[simple;zeros(abs([a 0]-sx))],[positions;zeros(abs([a,0]-sy))]];
end

function positions = getRectPositions(sample)
    
    rect(1) = findPosition(sample,'start');
    rect(2) = findPosition(sample,'end');
    intersections = findIntersections(sample);
    positions = [rect';intersections'];
end

function interrects = findIntersections(sample)

    [x0,y0,segments] = selfintersect(sample(:,1),sample(:,2));
    xy = [x0,y0];
    interrects = zeros(1,length(xy));
    for i=1:length(xy)             
        interrects(i) = findRectPosition(xy);
    end    
    
end

function position = findPosition(sample,startOrEnd)

    numPointsInSample = 2;
    sampleStart=sample(1:numPointsInSample,:);
    sampleSize = size(sample,1);
    sampleEnd = sample(sampleSize - numPointsInSample:sampleSize,:);
    
    if startOrEnd == "start"
        position = findRectPosition(sampleStart);
    else
        position = findRectPosition(sampleEnd);
    end

end

function foundInPos = findRectPosition(sample)
    foundInPos = 0;   

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
        if any(in)
            foundInPos = pos;
            break
        end
    end
end