function f = rabin(m,t)
%RABIN    Irreducible polynomial generator
%   RABIN(m,t) implements a modified version of Rabin's algorithm for 
%   testing the irreducibility of polynomials over finite fields to
%   generate irreducible polynomials of degree t. For best case run-times,
%   n should be prime.
%
%   Primary Reference: "Handbook of Finite Fields chapter 11: Algorithms"
%   CRC Press

q = 2^m;
notirred = 1;
maxiter = 20; %After this number of iterations, give up
iter = 0;
factors = [0,sort(t./unique(factor(t)))];
while (notirred == 1)&&(iter <= maxiter)
    iter = iter+1;
    % step 1 randomly choose a monic polynomial
    f = gf(monicpoly(m,t),m);
    % step 2
    for i = factors(2:end)-factors(1:(end-1))%1:floor(n/2)
        % calculate gcd(x^(q^i)-x,f)
        % first construct the polynomial g = x^q^i-x
        % note that in fields with characteristic 2, -1 = 1
        g = zeros(1,q^i + 1);
        g(1) = 1;
        g(q^i) = 1;
        g = gf(g,m);
        gcd = polygcd(g,f);
        % if gcd ~= 1, make a new monic and try again
        if length(gcd) ~= 1
            if (any(gcd(1:(length(gcd)-1))))||(gcd(length(gcd)) ~= 1)
                notirred = 1;
                break
            end
        else
            if gcd ~= 1
                notirred = 1;
                break
            end
        end
        notirred = 0;
    end
end
if iter > maxiter
    error('failed to find irreducible polynomial in iteration limit')
end
end