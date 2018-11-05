%budget constraint of lifecycle problem
function [c,ceq] = fmincon_constraint(x,r,w,t)

c1 = x(1,1) + x(1,2)- w(1);

i = 2:t;

% budget constriant 0 =  c(t) + s(t) - (1+r)s(t-1) - w(t)
c2 = x(i,1)+x(i,2)-(1+r)*x(i-1,2)-w(i);

c = [c1;c2];

ceq = [];