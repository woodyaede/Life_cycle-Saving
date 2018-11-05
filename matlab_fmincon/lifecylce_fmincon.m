%lifecylce saving problem solved with fmincon
clear all
tic
beta0 = 0.9;
r = 0.2;
t = 100;
retire = 60;
w = ones(t,1);
w(retire:t) = 0;
%we set consumption the first column of x--x(:,1)
% and set saving the second colum of x--x(:,2)
x0 = 0.2*ones(t,2);
% call utility function
f = @(x)lifecycle_fmincon_utility(x,beta0,t);
% budget constraint
nonlcon = @(x)fmincon_constraint(x,r,w,t);
lb = zeros(size(x0));
A = [];
b = [];
%set findal saving s(t) equals to 0
aeq1 = zeros(2*t,2*t);
aeq1(2*t,2*t) = 1;
beq1 = zeros(2*t,1);
Aeq = aeq1;
beq = beq1;
ub =[];
opts = optimoptions('fmincon','Display','iter','Algorithm','interior-point','OptimalityTolerance',1e-8,'MaxIter', 1e8, 'MaxFunEvals', 1e8);
x = fmincon(f,x0,A,b,Aeq,beq,lb,ub,nonlcon,opts);

toc


