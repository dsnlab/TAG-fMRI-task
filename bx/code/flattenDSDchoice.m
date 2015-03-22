function flatChoice = flattenDSDchoice(tPairs,cPairs)
%FLATCHOICE.M flatten response matrix, do not call directly
flatChoice = zeros(length(tPairs),30);
for tCount = 1:length(tPairs)
    switch tPairs(tCount,1)
    case 1
        switch cPairs(tCount,1)
        case 0
            flatChoice(tCount,1)=1;
        case 1
            flatChoice(tCount,2)=1;
        case 2
            flatChoice(tCount,3)=1;
        case 3
            flatChoice(tCount,4)=1;
        case 4
            flatChoice(tCount,5)=1;
        end
    case 2
        switch cPairs(tCount,1)
        case 0
            flatChoice(tCount,6)=1;
        case 1
            flatChoice(tCount,7)=1;
        case 2
            flatChoice(tCount,8)=1;
        case 3
            flatChoice(tCount,9)=1;
        case 4
            flatChoice(tCount,10)=1;
        end
    case 3
        switch cPairs(tCount,1)
        case 0
            flatChoice(tCount,11)=1;
        case 1
            flatChoice(tCount,12)=1;
        case 2
            flatChoice(tCount,13)=1;
        case 3
            flatChoice(tCount,14)=1;
        case 4
            flatChoice(tCount,15)=1;
        end
    end
    
    switch tPairs(tCount,2)
    case 1
        switch cPairs(tCount,2)
        case 0
            flatChoice(tCount,16)=1;
        case 1
            flatChoice(tCount,17)=1;
        case 2
            flatChoice(tCount,18)=1;
        case 3
            flatChoice(tCount,19)=1;
        case 4
            flatChoice(tCount,20)=1;
        end
    case 2
        switch cPairs(tCount,2)
        case 0
            flatChoice(tCount,21)=1;
        case 1
            flatChoice(tCount,22)=1;
        case 2
            flatChoice(tCount,23)=1;
        case 3
            flatChoice(tCount,24)=1;
        case 4
            flatChoice(tCount,25)=1;
        end
    case 3
        switch cPairs(tCount,2)
        case 0
            flatChoice(tCount,26)=1;
        case 1
            flatChoice(tCount,27)=1;
        case 2
            flatChoice(tCount,28)=1;
        case 3
            flatChoice(tCount,29)=1;
        case 4
            flatChoice(tCount,30)=1;
        end
    end
end
return