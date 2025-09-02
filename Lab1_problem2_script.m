% Contributors: 
% Course number: ASEN 3801
% File name: Lab1_problem2_script.m
% Created: 09/01/2025

clear;
close all;
clc;

% ---- Constants ----
m = 0.050;            % kg (50 g)
diam = 0.02;          % m (2.0 cm)
A = pi*(diam/2)^2;    % cross-sectional area (m^2)
Cd = 0.6;             % drag coefficient
g = 9.80665;          % m/s^2

% ---- 2b: get air density at Boulder geopotential altitude 1655 m ----

    [rho] = stdatmo(1655); % replace with the appropriate calling signature if re

% ---- 2c: initial condition & simulate until ground ----

% initial position at origin: p = [0;0;0] with "height" zero at ground.

p0 = [0; 0; 0]; % origin (on ground)
v0 = [0; 20; -20]; % [vN; vE; vD] where vE = +20 m/s East, vD = -20 m/s (upwards)
x0 = [p0; v0];

% If starting at ground and velocity upward you immediately have pD=0 and event triggers.
% For the event function to make sense, start slightly above ground (tiny positive down)
x0(3) = 1e-3; % start 1 mm above ground (down positive) to allow flight
tspan = [0 100]; % long enough
wind_vel = [0;0;0]; % zero wind for 2c

opts = odeset('RelTol',1e-8,'AbsTol',1e-8,'Events',@hitGroundEvent);
[t,x,te,xe,ie] = ode45(@(t,x) objectEOM(t,x,rho,Cd,A,m,g,wind_vel), tspan, x0, opts);

% extract trajectory
pos = x(:,1:3);
% Convert to plotting-friendly coordinates (x = North, y = East, z = -Down so that positive up)
X = pos(:,1);
Y = pos(:,2);
Z = -pos(:,3);

% 3D plot with flipped vertical so negative Down values appear above plane (as requested)
figure('Name','Problem 2c: 3D trajectory');
plot3(X,Y,Z,'LineWidth',1);
xlabel('North (m)'); ylabel('East (m)'); zlabel('Up (m)');
title('Problem 2c: 3D trajectory (wind = 0)');
grid on; 


%2d: vary wind speed in North direction and record landing x-coordinate and distance
winds = linspace(-30,30,20);
landing_N = zeros(size(winds));
landing_dist = zeros(size(winds));

for i=1:length(winds)
    NorthWind = winds(i);
    wind_vel = [NorthWind;0;0]; % north wind
    [t_i,x_i,te_i,xe_i] = ode45(@(t,x) objectEOM(t,x,rho,Cd,A,m,g,wind_vel), tspan, x0, opts);
        land = xe_i(1:3);
        landing_N(i) = land(1); % N coordinate at landing
        landing_dist(i) = norm(land'); % distance from origin in 3D
end


% Plot results for 2d
figure();
plot(winds, landing_N,'-o','LineWidth',1);
grid on; 
xlabel('North wind speed (m/s)');
ylabel('Landing North (m)');
title('Problem 2d: Landing N Coordinate vs Northward Wind Speed');

figure();
plot(winds, landing_dist,'-o','LineWidth', 1);
grid on;
xlabel('North wind speed (m/s)');
ylabel('Landing distance from origin (m)');
title('Problem 2d: Distance (E) vs Northward Wind Speed');


