function plotstroke(data,prob)
    % plot strokes starting from sampleIndex
    % plotDigit [optional]: plot alternatively one digit multiple times
    
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
    
    [pos,intersection,segment,interpos] = plotrects(sample);    
    if exist('prob', 'var')        
        %top3 = strcat(mat2str(prob(1,1)),sprintf(': %.3f',(prob(1,2))),", ",...
        %    mat2str(prob(2,1)),sprintf(': %.3f',(prob(2,2))),", ",...
        %    mat2str(prob(2,1)),sprintf(': %.3f',(prob(3,2))))
        title("Predicted: " + (prob(1,1) - 1));
        
    end
    drawnow;
    hold off;
end

function [pos,intersection,segment,interpos] = plotrects(sample)
    % plot rectangles for start and end samples 
    intersection = nan;
    interpos = 0;
    numPointsInSample = 2;
    sampleStart=sample(1:numPointsInSample,:);
    sampleSize = size(sample,1);
    sampleEnd = sample(sampleSize - numPointsInSample:sampleSize,:);
    plot(sampleStart(:,1),sampleStart(:,2),"rx");
    plot(sampleEnd(:,1),sampleEnd(:,2),"bx");
    [x0,y0,segments] = selfintersect(sample(:,1),sample(:,2));
    segment = segments;
    if(length(segments) > 0)   
        xy0 = [x0,y0];
        interpos = zeros(1,size(xy0,1));
        for k=1:9
            for i=1:length(xy0(:,1))
                if interpos(i) == 0
                    interpos(i) = plotOneRect(xy0(i,:),k,"green",sample);
                end
            end
        end
        %plotOneRect(sampleStart(1,:),k,"red");

        % leave out first and last segments (beginning and end of draw)
        % segments = segments(segments(:,1) >= 20 & segments(:,1) <= sampleSize - 20,:);
        %segments = segments(segments(:,2) - segments(:,1) > 3,:)

        %if(length(segments) > 0)   
        %    midsegment = segments(ceil(end/2), :)
        %    segments
        %    %
        %    segments = midsegment;
    %
    %        %segments(segments >= 30 & segments <= sampleSize - 50) = [];
    %
    %        intersection = [sample(segments(:,1),:);sample(segments(:,2),:)];
    %        plot(intersection(:,1),intersection(:,2),"b*");
    %    end
    end
    plot(x0,y0,"ro");

    
    pos = zeros(length(interpos),3);
    pos(:,3) = interpos';
    for k=1:9
        if pos(1) == 0
            pos(1) = plotOneRect(sampleStart(1,:),k,"red",sample);
        end
        if pos(2) == 0
            pos(2) = plotOneRect(sampleEnd(1,:),k,"blue",sample);
        end
    end    
end

function foundInPos = plotOneRect(sample,pos,color,fullsample)
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

function btn_click(hObject, event,TextIndex,data,inc,plotDigit) 
    % button click callback for next or previous stroke set
    
    if exist('plotDigit', 'var')
        sampleIndex = str2num(TextIndex.String) + inc * 20;
        TextIndex.String = sampleIndex;
        plot_digit(data,sampleIndex,plotDigit);
    else
        sampleIndex = str2num(TextIndex.String) + inc;
        TextIndex.String = sampleIndex;
        draw_plots(data,sampleIndex);
    end  
end