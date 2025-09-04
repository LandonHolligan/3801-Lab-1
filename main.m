% Contributors: Landon, Sayer, Mattias, Finley
% Course number: ASEN 3801
% File name: Lab1_problem2_script.m
% Created: 08/28/2025

clear;
close all;
clc;

m = 0.050;  % kg
diam = 0.02; 
A = pi * ((diam / 2) ^ 2);
Cd = 0.6; 
g = 9.81;

%% 2b: get air density at Boulder geopotential altitude 1655 m

[rho] = stdatmo(1655); 

%% 2c: initial condition & simulate until ground

p0 = [0, 0, 0]';
v0 = [0, 20, -20]';
x0 = [p0; v0];

% If starting at ground and velocity upward you immediately have pD=0 and event triggers.

x0(3) = -1e-3; 
tspan = [0 100];
wind_vel = [0;0;0];

options = odeset('RelTol',1e-8,'AbsTol',1e-8,'Events',@hitGroundEvent);
[t,xc] = ode45(@(t,x) objectEOM(t,x,rho,Cd,A,m,g,wind_vel), tspan, x0, options);

% extract trajectory
pos = xc(:,1:3);

X = pos(:,1);
Y = pos(:,2);
Z = -pos(:,3);

% 3D plot
figure();
plot3(X,Y,Z,'LineWidth',1);
xlabel('North (m)'); ylabel('East (m)'); zlabel('Up (m)');
title('2(c): 3D Trajectory');
grid on; 


%% 2d: vary wind speed in North direction and record landing x-coordinate and distance
winds = linspace(-30,30,21);

landingN = zeros(size(winds));
landingDist = zeros(size(winds));

for i=1:length(winds)
    NorthWind = winds(i);
    wind_vel = [NorthWind;0;0]; % varies north wind
    [~,~,~,xd] = ode45(@(t,x) objectEOM(t,x,rho,Cd,A,m,g,wind_vel), tspan, x0, options);
    land = xd(end, 1:3);
        landingN(i) = land(1); % N coordinate at landing
        landingDist(i) = norm(land(1:2)); % distance from origin in 3D
end

% Plot 1: North feflection per m/s of wind

dNdw = gradient(landingN, winds);

figure();
plot(winds, dNdw, '-o','LineWidth',1);
grid on; xlabel('North wind w_x (m/s)');
ylabel('North Landing distance / North wind w_x  [m per (m/s)]');
title('2(d)(1): North deflection per m/s of wind');

% Plot 2: Change in total Distance per m/s of wind

dRdw = gradient(landingDist, winds);

figure();
plot(winds, dRdw, '-o','LineWidth',1);
grid on; 
xlabel('North wind w_x (m/s)');
ylabel('Change in Range / North wind w_x  [m per (m/s)]');
title('2(d)(2): Change in total distance per m/s of wind');

%% 2e: Vary Geopotential Altitude

h_vals = [0 500 1000 1500 2000 3000 4000 5000];

landingDist_height = zeros(length(h_vals), length(winds));

for a = 1:length(h_vals)
    rho_a = stdatmo(h_vals(a));

    for i = 1:length(winds)
        NorthWind = winds(i);
        wind_vel = [NorthWind; 0; 0];

        [~,~,~,xe] = ode45(@(t,x) objectEOM(t,x,rho_a,Cd,A,m,g,[winds(i);0;0]), tspan, x0, options);

        landingDist_height(a,i) = norm(xe(1:2));
    end
end

% Plot 1: distance vs wind
figure; 
hold on; 
grid on;

for a = 1:length(h_vals)
    plot(winds, landingDist_height(a,:), 'LineWidth', 1.5, 'DisplayName', sprintf('H = %d m', h_vals(a)));
end

xlabel('North wind w_x (m/s)'); 
ylabel('Landing distance (m)');
title('2(e)(1): Distance vs wind for various geopotential altitudes');
legend('Location','best'); 
hold off;

% Plot 2: minimum distance vs altitude

minDist = min(landingDist_height, [], 2);

figure; 
plot(h_vals, minDist, '-o', 'LineWidth', 1.5);
grid on;
xlabel('Geopotential altitude (m)'); 
ylabel('Minimum landing distance (m)');
title('2(e)(2): Minimum landing distance vs altitude');

%% 2f Vary Weight With Constant KE

winds = linspace(-30,30,5);

m_vals = linspace(0.02, 0.20, 11);
E0 = 0.5 * m * (norm(v0)^2);
vdir = v0 / norm(v0);
landingDist_mass = zeros(length(m_vals), length(winds));

for k = 1:length(m_vals)
    m_i = m_vals(k);
    vmag = sqrt(2 * E0 / m_i);
    v_i = vmag * vdir;
    for i = 1:length(winds)
        wind_vel = [winds(i), 0, 0]';
        x0_f = [0, 0, -1e-3, v_i(1), v_i(2), v_i(3)]';
        [~,~,~,xe] = ode45(@(t,x) objectEOM(t,x,rho,Cd,A,m_i,g,wind_vel), tspan, x0_f, options);
        landingDist_mass(k,i) = norm(xe(end,1:2));
    end
end

figure; 
hold on; 
grid on;
for i = 1:length(winds)
    plot(m_vals, landingDist_mass(:,i), 'LineWidth', 1.5, 'DisplayName', sprintf('w_x = %d m/s', winds(i)));
end
xlabel('Mass (kg)'); 
ylabel('Landing distance (m)');
title('2(f): Distance vs mass at fixed KE');
legend('Location','best'); 
hold off;