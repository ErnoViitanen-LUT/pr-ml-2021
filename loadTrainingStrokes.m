% loadTrainingStrokes
% Load training data 
% - from training data folder
% - from previously saved trainingStrokes.mat file

trainingDataFolder = "training_data";

if isfile("trainingStrokes.mat")
     % File exists.
     load trainingStrokes.mat;
else
    % File does not exist.
    files = dir(trainingDataFolder + '/*.mat') ; 
    N = length(files);
    
    data = cell(1, N);
    class = zeros(1, N);
    i = 0;
    for file = files'
        i = i+1;
        [mat,tok,ext] = regexp(file.name,"stroke_([0-9])_.*",'match','tokens', 'tokenExtents');
        class(1,i) = 1 + str2num(char(tok{1}));
        data(1,i) = struct2cell(load(trainingDataFolder + "/" + file.name,"pos"));
    end
    % clear all except class and data variables
    clear -regexp ^(?!class|data$)[^.]+$
    save trainingStrokes class data;
end

if exist('plotdata', 'var')
    startIndex = 80;
    plotStrokes(data,startIndex,3);
    plotStrokes(data,startIndex);
end