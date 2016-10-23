%key sizes
m = [10,11,12];
t = [53,71];
n = 2.^m;

for i = 1:length(t)
    k = n-m*t(i);
    McGoppa = (n.*k)./8000
    NiGoppa = ((n-k).*n)./8000
    HyMes = (k.*(n-k))./8000
end