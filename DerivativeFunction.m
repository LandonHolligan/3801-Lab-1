function [S_prime] = DerivativeFunction(S)
%DERIVATIVEFUNCTION Summary of this function goes here
%   Detailed explanation goes here

w = S(1,1);
x = S(1,2);
y = S(1,3);
z = S(1,4);

w_prime = -9*w + y;
x_prime = 4*w*x*y - x^2;
y_prime = 2*w - x - 2*z;
z_prime = x*y - y^2 - 3*z^3;

S_prime = [w_prime, x_prime, y_prime, z_prime];

end

