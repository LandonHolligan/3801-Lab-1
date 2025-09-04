% Contributors: 
% Course number: ASEN 3801
% File name: Lab1_problem2_script.m
% Created: 08/28/2025

clear;
close all;
clc;

% ---- Constants ----
m = 0.050;            % kg (50 g)
diam = 0.02;          % m (2.0 cm)
A = pi*((diam/2)^2);    % cross-sectional area (m^2)
Cd = 0.6;             % drag coefficient
g = 9.81;          % m/s^2

% 2b: get air density at Boulder geopotential altitude 1655 m

[rho] = stdatmo(1655); 

% 2c: initial condition & simulate until ground

p0 = [0; 0; 0]; % origin
v0 = [0; 20; -20]; % [vN; vE; vD] where vE = +20 m/s East, vD = -20 m/s (upwards)
x0 = [p0; v0];

% If starting at ground and velocity upward you immediately have pD=0 and event triggers.

x0(3) = -1e-3; % start 1 mm above ground (down positive) to allow flight
tspan = [0 100];
wind_vel = [0;0;0]; % zero wind

options = odeset('RelTol',1e-8,'AbsTol',1e-8,'Events',@hitGroundEvent);
[t,x] = ode45(@(t,x) objectEOM(t,x,rho,Cd,A,m,g,wind_vel), tspan, x0, options);

% extract trajectory
pos = x(:,1:3);

% Convert to x = North, y = East, z = -Down so that positive up
X = pos(:,1);
Y = pos(:,2);
Z = -pos(:,3);

% 3D plot
figure('Name','Problem 2c: 3D trajectory');
plot3(X,Y,Z,'LineWidth',1);
xlabel('North (m)'); ylabel('East (m)'); zlabel('Up (m)');
title('Problem 2c: 3D Trajectory');
grid on; 


% 2d: vary wind speed in North direction and record landing x-coordinate and distance
winds = linspace(-30,30,21);

landingN = zeros(size(winds));
landingE = zeros(size(winds));
landingDist = zeros(size(winds));

for i=1:length(winds)
    NorthWind = winds(i);
    wind_vel = [NorthWind;0;0]; % varies north wind
    [t_i,x_i,te_i,xe_i] = ode45(@(t,x) objectEOM(t,x,rho,Cd,A,m,g,wind_vel), tspan, x0, options);
        land = xe_i(1:3);
        landingN(i) = land(1); % N coordinate at landing
        landingE(i) = land(2);
        landingDist(i) = norm(land); % distance from origin in 3D
end

% Plot results for 2d

dNdw = gradient(landingN, winds);

figure();
plot(winds, dNdw, '-o','LineWidth',1);
grid on; xlabel('North wind w_x (m/s)');
ylabel('North Landing distance / North wind w_x  [m per (m/s)]');
title('2(d)(1): North deflection per m/s of wind');

dRdw = gradient(landingDist, winds);

figure();
plot(winds, dRdw, '-o','LineWidth',1);
grid on; xlabel('North wind w_x (m/s)');
ylabel('Change in Range / North wind w_x  [m per (m/s)]');
title('2(d)(2): Change in total distance per m/s of wind');
