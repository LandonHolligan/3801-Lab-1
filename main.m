clear
clc
close all

S_0 = [1,1,1,1];
T_span = [0 20];
options = odeset('RelTol',1e-8,'AbsTol',1e-8);
[T_out,State_out] = ode45(@DerivativeFunction,T_span,S_0,options);

hold on;

figure(1);
stateNames = ['W','X','Y','Z'];

for i = 1:4
    subplot(4,1,i)
    plot(T_out, State_out(:,i), 'LineWidth', 1.5)
    grid on
    xlabel('Time (n.d.)')
    ylabel([stateNames(i) '(n.d.)'])
    title(['Time vs. ' stateNames(i)])
end

tolerances = [1e-2,1e-4,1e-6,1e-8,1e-10];
State_final = zeros(5,4);
options2 = odeset('RelTol',1e-12,'AbsTol',1e-12);
[T_out_reference,State_out_reference] = ode45(@DerivativeFunction,T_span,S_0,options2);
State_final_reference = State_out_reference(end,:);

for i = 1:length(tolerances)
    options3 = odeset('RelTol',tolerances(i),'AbsTol',tolerances(i));
    [T_out,State_out] = ode45(@DerivativeFunction,T_span,S_0,options3);
    %Time_total = T_out(i);
    State_final(i,:) = State_out(end,:);
end

Table_Data = State_final - State_final_reference;

Relative_Tolerance = {'W(t=20)-W_r(t=20)';'X(t=20)-X_r(t=20)';'Y(t=20)-Y_r(t=20)';'Z(t=20)-Z_r(t=20)'};
Tol_1e_neg2 = Table_Data(1,:)';
Tol_1e_neg4 = Table_Data(2,:)';
Tol_1e_neg6 = Table_Data(3,:)';
Tol_1e_neg8 = Table_Data(4,:)';
Tol_1e_neg10 = Table_Data(5,:)';


T = table(Relative_Tolerance,Tol_1e_neg2,Tol_1e_neg4,Tol_1e_neg6,Tol_1e_neg8,Tol_1e_neg10);

f = uifigure;
uit = uitable(f,'Data',T,'ColumnName',{'Variable','1e-2','1e-4','1e-6','1e-8','1e-10'});

h = 1655; % meters (altitude of Boulder)
[rho] = stdatmo(h); % units are in SI 

Cd = 0.6;
d = 0.02;
m = 0.05; % kg
g = 9.8;
A = ((d/2)^2)*pi; % m^2
x = 0;
y = 0;
z = 0;
x_dot = 0;
y_dot = 20;
z_dot = -20;
State_Vector_Initial = [x, y, z, x_dot, y_dot, z_dot]';
Time_span = [0 20];
wind_vel = [0, 0, 0]';
[T_out_again, State_Vector_dot_out] = ode45( @(t,State_Vector) ObjectEOM(t,State_Vector,rho,Cd,A,m,g,wind_vel), Time_span, State_Vector_Initial, options);

figure(2); 
plot3(State_Vector_dot_out(:,1), State_Vector_dot_out(:,2), -State_Vector_dot_out(:,3), 'LineWidth',1.5);
grid on; axis equal; set(gca,'ZDir','reverse');
xlabel('x (m)'); ylabel('y (m)'); zlabel('z (m)');
title('Trajectory (negative z shown above xy-plane)');
xlim([-100,100]);
ylim([-100,100]);
zlim([0,200]);
