% Contributors: 
% Course number: ASEN 3801
% File name: objectEOM.m
% Created: 09/01/2025

function xdot = objectEOM(t,x,rho,Cd,A,m,g,wind_vel)
pos = x(1:3); 
vel = x(4:6);

v_rel = vel - wind_vel(:);

Vspeed = norm(v_rel);

if Vspeed == 0
    F_drag = [0, 0, 0]';
else
    F_drag = -0.5 * rho * Cd * A * Vspeed * v_rel; 
end

F_grav = [0, 0, m*g]';

% total acceleration
accel = (F_drag + F_grav) / m;

xdot = zeros(6,1);
xdot(1:3) = vel;
xdot(4:6) = accel;
end