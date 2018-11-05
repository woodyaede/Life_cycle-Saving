function val = Di_valfuniter(s)

global v0 beta r smat s0 sgrid t retire wage1 wage0 indext

slo = max(sum(s>smat),1); % identify the gridpoint that falls just below
shi = slo + 1;            % gridpoint ahead of s

% do the linear interpolation 
if indext < t
vinterp =  v0(slo,indext+1) + (s - smat(slo))*(v0(shi,indext+1)-v0(slo,indext+1))/(smat(shi)-smat(slo));
else
    vinterp = 0;
end

% consumption
if indext < retire
c = (1+r)*s0 + wage1 - s; 
elseif indext < t
    c = (1+r)*s0 + wage0 - s;
else
    c = (1+r)*s0 + wage0;
end

if c <= 0 
    val = -999999-999*abs(c);
else
    val = -exp(-c) + beta*vinterp;
end
val = -val;
