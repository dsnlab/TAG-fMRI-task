function side = getDiscoSide(subID)
    % find inputdir
    thisfile = mfilename('fullpath'); % studyDir/task/code/thisfile.m
    taskDir = fileparts(fileparts(thisfile));
    inputDir = fullfile(taskDir, 'input');
    
    % read table
    discoSideFN = fullfile(inputDir, 'dsd_discoside.txt');
    T = readtable(discoSideFN, 'ReadRowNames', true);
    
    % if subject isn't in there assign a random side
    if not (ismember(subID, T.Properties.RowNames))
        sides={'Right', 'Left'}; 
        randomSide=sides(randi(length(sides)));
        T{subID, 'discoSide'} = {randomSide};
        writetable(T, discoSideFN, 'WriteRowNames', true);
    end
    
    % get discoside
    side = T.discoSide{subID};
end
