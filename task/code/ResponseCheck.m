function [ pressed, firstPress ] = ResponseCheck(indices)
    pressed = 0;
    firstPress = 0;
    for i = 1:length(indices)
        [p, f] = KbQueueCheck(indices(i));
        pressed = pressed | p;
        firstPress = firstPress + f;
    end
end
