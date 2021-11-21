augmentedstatisticalmodel(data,class);
function augmentedstatisticalmodel(data,class)
    if ~exist('DEBUG', 'var')
        DEBUG = false;
    end
    for digit = 0:9
        num_dat = data(class==digit);
        N = length(num_dat);
        if(DEBUG==true)
            figure
        end
        for i = 1:N
            x = cell2mat(num_dat(i));
            avg = mean(x(:,1:2));
            if(DEBUG==true)
                plot(avg(1),avg(2),'k.'); hold on
            end
        end
        if(DEBUG==true)
            title(num2str(digit))
            axis([0,1,0,1]);
            saveas(gcf,strcat(num2str(digit),'.png'));
        end
    end
end
