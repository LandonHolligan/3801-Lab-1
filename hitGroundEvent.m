% Contributors: 
% Course number: ASEN 3801
% File name: hitGroundEvent.m
% Created: 09/01/2025

function [value,stop,direction] = hitGroundEvent(t,x)

posD = x(3);

value = posD;         % when value == 0 -> event
stop = 1;     % stop integration
direction = 1;      % only detect crossing from negative to positive
end