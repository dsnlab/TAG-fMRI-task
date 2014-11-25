function [ shortenedArray ] = popArray( array )
%POPARRAY.m if a vector is longer than 1, pop off the first element
%   Detailed explanation goes here: why isn't this built in?

if size(array,1) > 1;
    shortenedArray = array(2:end,:);
else
    shortenedArray = array;
end
return
