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
            title("3D " + (i*100 + j));
        end
        for i=0:9 % plot 10 digits in 2D
            sample = cell2mat(data(i*100 + j));
            subplot(4,5,i+10+1);
            plot(sample(:,1), sample(:,2));
            title("2D " + (i*100 + j));
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
        title("2D " + (plotDigit*100 + j + sampleIndex));
    end
    drawnow;    
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