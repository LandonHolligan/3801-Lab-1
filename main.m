clear
clc
close all

S_0 = [1,1,1,1];
T_span = [0 20];
options = odeset('RelTol',1e-8,'AbsTol',1e-8);
[T_out,State_out] = ode45(@DerivativeFunction,T_span,S_0,options);


plot(T_out,State_out);
