%sum of discounted utility function
function y = lifecycle_fmincon_utility(x,beta0,t)
i = 1:t;
beta = beta0.^(i-1);
y = beta*exp(-x(:,1));




