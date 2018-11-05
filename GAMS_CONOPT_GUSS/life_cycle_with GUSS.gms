*Life time saving problem
*HW Di Wu
set t /1*50/;
scalars
retire  age of retirement /60/
beta discount rate /0.9/
r interest rate/0.2/
s0 intial savings/0/
st ending savings/0/
w0 wage /1/
epsilon lower bound of consumption /0.0001/
;
parameters
w(t) wages
betas(t) discounts;
w(t) = 0;
w(t)$(ord(t) <= retire) = w0;
betas(t) = beta**(ord(t)-1);

variables
obj objectice creterion
u(t) utility
s(t) savings
c(t) consumption
;

equations
obj1 objective function
util(t) utility function
sav(t) saving process
sav0(t) initial saving bound
savt(t) ending saving bound
;

sav0(t)$(ord(t)=1).. s(t) =e= (1+r)*s0 + w(t) - c(t);
sav(t)$(ord(t) > 1).. s(t) =e= (1+r)*s(t-1)+w(t)-c(t);
savt(t)$(ord(t) = card(t)).. s(t) =e= st;
util(t).. u(t) =e= -exp(-c(t));
obj1.. obj =e= sum(t,betas(t)*u(t));

*bound constraint
s.lo(t) = 0;
c.lo(t) = epsilon;

*initial guess
s.l(t) = 0;
c.l(t) = 0.5;
u.l(t) = -exp(-c.l(t));
obj.l  = sum(t,betas(t)*u.l(t));

Option limrow=0,limcol=0,solprint=off;
OPTION ITERLIM = 500000;
OPTION RESLIM = 500000;
OPTION DOMLIM = 1000;
OPTION NLP= conopt;
option decimals = 7;

model lifetimec /all/;

***************************************
* GUSS set up
* we build up scenarioes with 100*100 different combination of beginning savings and ending savings
***************************************

set v1 /1*100/;
alias(v1,v2);
set S1(v1,v2) /#v1.#v2/;
parameter
         s0_s(v1,v2) scenario data
         st_s(v1,v2);
s0_s(v1,v2) = uniform(0,1);
st_s(v2,v2) = uniform(0,1);

Parameter
   o / SkipBaseCase 1, UpdateType 2/;


set dict / S1. scenario. ''
            o.   opt.    ''
           s0. param.   s0_s
           st. param.   st_s/;

solve lifetimec using nlp maximizing obj scenario dict;
