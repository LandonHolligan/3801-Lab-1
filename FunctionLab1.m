% Contributors: Landon, Sayer, Mattias, Finley
% Course number: ASEN 3801
% File name: FunctionLab1.m
% Created: 08/28/2025
%
% Function: returns derivatives for the 4D dynamical system:
% wdot = -9*w + y
% xdot = 4*w*x*y - x^2
% ydot = 2*w - x - 2*z
% zdot = x*y - y^2 - 3*z^3
%
function dydt = FunctionLab1(t,StateVec)
% y is a 4x1 vector: y = [w; x; y; z]
w = StateVec(1);
x = StateVec(2);
y = StateVec(3); % avoid clashing with name 'y'
z = StateVec(4);

dydt = zeros(4,1);
dydt(1) = -9*w + y;
dydt(2) = 4*w*x*y - x^2;
dydt(3) = 2*w - x - 2*z;
dydt(4) = x*y - y^2 - 3*z^3;
end

