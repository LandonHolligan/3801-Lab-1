function State_Vectordot = ObjectEOM(t,State_Vector,rho,Cd,A,m,g,wind_vel)

Position = State_Vector(1:3); % x,y,z

Velocity = State_Vector(4:6); % v_x, v_y, v_y
Rel_vel = Velocity - wind_vel;
V_rel = norm(Rel_vel);

F_drag = -0.5 .* rho .* Cd .* A * (V_rel) .^2 * (Rel_vel/V_rel); % drag in direction of v
Gravity = [0,0,-m*g]';

acceleration = (F_drag + Gravity) / m;

State_Vectordot = [Velocity; acceleration];

end
