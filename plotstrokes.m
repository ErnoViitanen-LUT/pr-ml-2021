function plotstrokes(data,class,sampleIndex)
    
    if ~exist('sampleIndex', 'var')
        sampleIndex = 1;
    end
    
    hFig = figure;
    hFig.Position = [100 100 1400 800];
    ButtonPrev = uicontrol('Parent',hFig,'Style','pushbutton','String','Prev','Units','points','Position',[420 20 40 20],'Visible','on');
    TextIndex=uicontrol('Parent',hFig,'Style','text','String','1','Units','points','Position',[460 20 50 20],'Visible','on');
    ButtonNext=uicontrol('Parent',hFig,'Style','pushbutton','String','Next','Units','points','Position',[500 20 50 20],'Visible','on');
    ButtonNext.Callback = {@btn_click,TextIndex,data,1};
    ButtonPrev.Callback = {@btn_click,TextIndex,data,-1};
    
    draw_plots(data,sampleIndex);
end
function draw_plots(data,sampleIndex)
    samplesFrom = sampleIndex;
    samplesTo = sampleIndex;

    for j=samplesFrom:samplesTo
        cla; % clear subplots
        for i=0:9
            sample = cell2mat(data(i*100 + j));
            subplot(4,5,i+1);            
            plot3(sample(:,1), sample(:,2), sample(:,3), 'k-');
            view(360,90);
            title("3D " + (i*100 + j));
        end
        for i=0:9
            sample = cell2mat(data(i*100 + j));
            subplot(4,5,i+10+1);
            plot(sample(:,1), sample(:,2));
            title("2D " + (i*100 + j));
        end
        drawnow;    
    end
end

function btn_click(hObject, event,TextIndex,data,inc)     
    sampleIndex = str2num(TextIndex.String) + inc;
    TextIndex.String = sampleIndex;
    draw_plots(data,sampleIndex);   
end