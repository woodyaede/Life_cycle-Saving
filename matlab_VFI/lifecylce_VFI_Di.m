%LifeCycle Saving Problem
%HW Di Wu

clear all;
close all;
tic

global v0 beta r smat s0 sgrid t retire wage1 wage0 indext
%set parameters
beta = 0.9;
r = 0.2;
t = 100;
retire = 60;
wage1 = 1;
wage0 = 0;


tol = 1e-6;     % tolerence level
maxit = 1000;   % maximum iterations
dif = 1000+tol; % initial differences
its = 0;        % initial iteration
sgrid = 99;     % saving grid point
smin = 0;
smax = 40;
grid = (smax-smin)/sgrid ; 
smat = smin:grid:smax;
smat = smat';
N = size(smat,1);

v0 = zeros(N,t);
v1 = ones(N,t);
s11 = zeros(N,t); %create space for saving choice
c11 = zeros(N,t); %create space for consumption choice

while dif > tol && its<  maxit
    for j = 1:t
        for i = 1:N
            indext = j;
            s0 = smat(i,1);
            s1 = fminbnd(@Di_valfuniter,smin,smax);
            v1(i,j) = -Di_valfuniter(s1);
            s11(i,j) = s1;
        end
    end
dif = norm(v1 - v0)
v0 = v1;
its = its+1
end

% get consumption decisions
for i = 1:N
    for j = 1:t
        if j < retire
        c11(i,j) = (1+r)*smat(i,1) + wage1 - s11(i,j); 
        elseif j < t
        c11(i,j) = (1+r)*smat(i,1) + wage0 - s11(i,j);
        else
        c11(i,j)= (1+r)*smat(i,1) + wage0;
        end
    end
end

% create a saving path when s0 = 0
spath = zeros(t,1);
spath(1) = s11(1,1);
for j = 2:t-1
    spathlo = max(sum(spath(j-1) > smat),1);
    spathhi = spathlo + 1;
    % interpolation of saving function 
    spath(j) = s11(spathlo,j) + (spath(j-1)-smat(spathlo))*(s11(spathhi,j)-s11(spathlo,j))/grid;
end
spath(t) = 0;
% create a consumption path based on saving path
cpath =  zeros(t,1);
cpath(1) = wage1 - spath(1);
for j = 2:t
    if j < retire
    cpath(j) = (1+r)*spath(j-1) + wage1 - spath(j); 
    elseif j < t
    cpath(j) = (1+r)*spath(j-1) + wage0 - spath(j);
    else
    cpath(j) = (1+r)*spath(j-1) + wage0;
    end
end

figure
age = 1:1:100;
plot(age,spath(age),age,cpath(age))
xlabel('age')
legend('saving','consumption')
title('A life-cyle saving problem')
toc

