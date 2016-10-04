function f = benor(m,n)
%BENOR    Irreducible polynomial generator
%   BENOR(m,n) implements Ben-Or's algorithm for randomly generating an
%   irreducible polynomial f of degree n over the finite field gf(m).
%
%   Primary Reference: "Handbook of Finite Fields chapter 11: Algorithms"
%   CRC Press

q = 2^m;
not_irred = 1;
max_iter = 20; %After this number of iterations, give up
iter = 0;
factors = [0,sort(n./unique(factor(n)))];
while (not_irred == 1)&&(iter <= max_iter)
    iter = iter+1;
    % step 1 randomly choose a monic polynomial
    f = gf(monic_poly(m,n),m);
    % step 2
    for i = factors(2:end)-factors(1:(end-1))%1:floor(n/2)
        % calculate gcd(x^(q^i)-x,f)
        % first construct the polynomial g = x^q^i-x
        % note that in fields with characteristic 2, -1 = 1
        g = zeros(1,q^i + 1);
        g(1) = 1;
        g(q^i) = 1;
        g = gf(g,m);
        gcd = poly_gcd(g,f);
        % if gcd ~= 1, make a new monic and try again
        if length(gcd) ~= 1
            if (any(gcd(1:(length(gcd)-1))))||(gcd(length(gcd)) ~= 1)
                not_irred = 1;
                break
            end
        else
            if gcd ~= 1
                not_irred = 1;
                break
            end
        end
        not_irred = 0;
        
    end
end

if iter > max_iter
    error('failed to find irreducible polynomial in iteration limit')
end

end
