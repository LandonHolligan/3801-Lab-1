% Contributors: 
% Course number: ASEN 3801
% File name: hitGroundEvent.m
% Created: 09/01/2025

% State uses NED convention: p(3) is Down; ground corresponds to pD = 0 (origin at ground).
function [value,isterminal,direction] = hitGroundEvent(t,x)
% pD = down coordinate;
pD = x(3);
value = pD;         % when value == 0 -> event
isterminal = 1;     % stop integration
direction = 1;      % only detect crossing from negative to positive (ascending -> descending depends on your initial)
% Note: adjust direction sign if your initial coordinate system differs.
end
