function points = interactiveDigitInput
    % Window for user to draw digit
    % Reference project
    % https://se.mathworks.com/matlabcentral/fileexchange/47940-digit-recognizer-zip
    
    minPointDistance = 0.0000005;

    points = [];
    f = figure('Name','Draw a single digit number','Menu','None','NumberTitle','Off',...
        'windowButtonUpFcn',@dragStopCallback,'windowButtonDownFcn',@windowbuttonDownCallback);
    
    uicontrol('String','Submit','Position',[f.Position(1) / 2 - 35 8 70 25],...
        'Callback',@submitCallback,'FontSize',12); % Submit Button
       
    % Drawing Area
    aH = axes('XLim',[0 1],'YLim',[0 1],'XTickLabel',[],'yTickLabel',[]);
    title('Draw A Number [0-9]');

    h = plot(nan,'-k','ButtonDownFcn',@dragStartCallback);
    set(aH,'XLim',[0 1],'YLim',[0 1],'XTickLabel',[],'yTickLabel',[]);
    
    uiwait(f); 

    function submitCallback(varargin)
        close(f)
    end
    function windowbuttonDownCallback(varargin)
        point = get(aH,'CurrentPoint');
        points=[point(1) point(3)];
        set(f,'windowButtonDownFcn','')
        set(h,'XData',points(1,1));
        set(h,'YData',points(1,2));
        dragStartCallback;        
    end
    function dragStartCallback(varargin)
        set(f,'WindowButtonMotionFcn',@dragCallback);  
    end
    function dragStopCallback(varargin)        
        set(f,'WindowButtonMotionFcn','');
    end
    function dragCallback(varargin)
        point = get(aH,'CurrentPoint');
        lastPoint = points(size(points,1),:);
        distance = euclideanDistance(lastPoint,point);        
        if distance >= minPointDistance % do not store every pixel            
            points=[points;[point(1) point(3)]];                      
            set(h,'XData',[get(h,'XData') point(1)]);
            set(h,'YData',[get(h,'YData') point(3)]);
        end
    end
end

function distance = euclideanDistance(row1,row2)
    % calculate euclidean distance between two vectors
    distance = 0;
    for i=1:size(row1,1) % go through each column
        distance = distance + (row1(1,i) - row2(1,i))^2;
    end
    distance = sqrt(distance);
end
