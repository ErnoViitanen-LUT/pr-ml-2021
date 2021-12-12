function plotStroke(data)
    % plot a single stroke    
    if ~exist('sampleIndex', 'var')
        sampleIndex = 1;
    end
   
    global hFig;
    if ~hFig
        hFig = figure;   
    end
    sample = data;
    plot(sample(:,1), sample(:,2));    
    axis([0 1 0 1]);
    hold on;
    
    plotrects(sample)
    drawnow;
    hold off;
end

function [pos] = plotrects(sample)
% plot samples and highlight rectangles for start and end samples 
    numPointsInSample = 2;
    sampleStart=sample(1:numPointsInSample,:);
    sampleSize = size(sample,1);
    sampleEnd = sample(sampleSize - numPointsInSample:sampleSize,:);
    plot(sampleStart(:,1),sampleStart(:,2),"rx");
    plot(sampleEnd(:,1),sampleEnd(:,2),"bx");
    
    pos = [0,0];
    for k=1:9
        if pos(1) == 0
            pos(1) = plotOneRect(sampleStart(1,:),k,"red");
        end
        if pos(2) == 0
            pos(2) = plotOneRect(sampleEnd(1,:),k,"blue");
        end
    end    
end

function foundInPos = plotOneRect(sample,pos,color)
% Hightlight rect position with color
    foundInPos = 0;
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
    %x
    %x = x * max(fullsample(:,1))
    in = inpolygon(sample(:,1),sample(:,2),x,y);
    if any(in)
        foundInPos = pos;
        p = patch(x,y,nan,'FaceColor',color,'FaceAlpha',.1);  
    end

    

end
