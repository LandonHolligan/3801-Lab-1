clear
clc
close all

S_0 = [1,1,1,1];
T_span = [0 20];
options = odeset('RelTol',1e-8,'AbsTol',1e-8);
[T_out,State_out] = ode45(@DerivativeFunction,T_span,S_0,options);


plot(T_out,State_out);
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
