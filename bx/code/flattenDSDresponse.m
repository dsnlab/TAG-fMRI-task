function flatResponse = flattenDSDresponse(pick,pickCoin)
%FLATTENDSDRESPONSE.M
flatResponse = zeros(length(pick),15);
for tCount = 1:length(pick)
    if isnan(pick)
        flatResponse(tCount,:)=nan
    else

        switch pick(tCount,1)
        case 1
            switch pickCoin(tCount)
            case 0
                flatResponse(tCount,1)=1;
            case 1
                flatResponse(tCount,2)=1;
            case 2
                flatResponse(tCount,3)=1;
            case 3
                flatResponse(tCount,4)=1;
            case 4
                flatResponse(tCount,5)=1;
            end
        case 2
            switch pickCoin(tCount)
            case 0
                flatResponse(tCount,6)=1;
            case 1
                flatResponse(tCount,7)=1;
            case 2
                flatResponse(tCount,8)=1;
            case 3
                flatResponse(tCount,9)=1;
            case 4
                flatResponse(tCount,10)=1;
            end
        case 3
            switch pickCoin(tCount)
            case 0
                flatResponse(tCount,11)=1;
            case 1
                flatResponse(tCount,12)=1;
            case 2
                flatResponse(tCount,13)=1;
            case 3
                flatResponse(tCount,14)=1;
            case 4
                flatResponse(tCount,15)=1;
            end
        end
    end
end
return
 