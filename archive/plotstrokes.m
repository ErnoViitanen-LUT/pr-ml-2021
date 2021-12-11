function plotstrokes(data,class,sampleIndex,plotDigit)
    % plot strokes starting from sampleIndex
    % plotDigit [optional]: plot alternatively one digit multiple times
    
    if ~exist('sampleIndex', 'var')
        sampleIndex = 1;
    end
   
    hFig = figure;
    hFig.Position = [100 100 1400 800]; % set figure position and size

    % Create UI controls and callbacks for changing stroke set
    ButtonPrev = uicontrol('Parent',hFig,'Style','pushbutton','String','Prev','Units','points','Position',[420 20 40 20],'Visible','on');
    TextIndex=uicontrol('Parent',hFig,'Style','text','String',sampleIndex,'Units','points','Position',[460 20 50 20],'Visible','on');
    ButtonNext=uicontrol('Parent',hFig,'Style','pushbutton','String','Next','Units','points','Position',[500 20 50 20],'Visible','on');
    
    if exist('plotDigit', 'var')
        ButtonNext.Callback = {@btn_click,TextIndex,data,1,plotDigit};
        ButtonPrev.Callback = {@btn_click,TextIndex,data,-1,plotDigit};
        plot_digit(data,sampleIndex,plotDigit); % plot individual digit
    else
        ButtonNext.Callback = {@btn_click,TextIndex,data,1};
        ButtonPrev.Callback = {@btn_click,TextIndex,data,-1};
        draw_plots(data,sampleIndex); % plot different digits
    end
end
function draw_plots(data,sampleIndex)
    % plot different digits
    samplesFrom = sampleIndex;
    samplesTo = sampleIndex;
    

    cla; % clear subplots
    for j=samplesFrom:samplesTo
        for i=0:9 % plot 10 digits in 3D
            sample = cell2mat(data(i*100 + j));
            subplot(4,5,i+1);            
            plot3(sample(:,1), sample(:,2), sample(:,3), 'k-');
            view(360,90); % rotate plot
            hold on;

            [pos,intersection,segment,interpos] = plotrects(sample);
            title("3D " + (i*100 + j),"start-end: " + pos(1) +":"+ pos(2) + ", intersections: " + mat2str(interpos));
            hold off;
        end
        for i=0:9 % plot 10 digits in 2D
            sample = cell2mat(data(i*100 + j));
            subplot(4,5,i+10+1);
            plot(sample(:,1), sample(:,2));
            hold on;
            [pos,intersection,segment,interpos] = plotrects(sample);
            
            title("2D " + (i*100 + j),"start-end: " + pos(1) +":"+ pos(2) + ", intersections: " + mat2str(interpos));
            hold off;
        end  
    end
    drawnow;  
end

function plot_digit(data,sampleIndex,plotDigit)
    % plot individual digit
    
    cla; % clear subplots
    for j=1:20 % plot 20 digits in 2D
        sample = cell2mat(data(plotDigit*100 + j + sampleIndex));
        subplot(4,5,j);
        plot(sample(:,1), sample(:,2));
        hold on;
        [pos,intersection,segment,interpos] = plotrects(sample);

        
        title("2D " + (plotDigit*100 + j + sampleIndex),"start-end: " + pos(1) +":"+ pos(2) + ", intersections: " + mat2str(interpos));

        hold off;
    end

    drawnow;    
end

function [pos,intersection,segment,interpos] = plotrects(sample)
    % plot rectangles for start and end samples 
    intersection = nan;
    interpos = 0;
    numPointsInSample = 3;
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
                    interpos(i) = plotOneRect(xy0(i,:),k,"green");
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
            pos(1) = plotOneRect(sampleStart(1,:),k,"red");
        end
        if pos(2) == 0
            pos(2) = plotOneRect(sampleEnd(1,:),k,"blue");
        end
    end
    pos
    
end

function foundInPos = plotOneRect(sample,pos,color)
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