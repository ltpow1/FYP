function [error,synd_matrix] = mybchdec(synd,n,m,t)


alpha = gf(2,m).*ones(1,n);
alpha = alpha.^(0:(n-1));
% convert sydrome from binary to gf(m)
synd_array = synd.x';
gfsynd = zeros(1,2*t);
for i = 1:(2*t)
    gfsynd(i) = bi2de(synd_array(((i-1)*m+1):(i*m)),'left-msb');
end
gfsynd = gf(gfsynd,m);
%trying out algorithm in table 8.4 of mceliece


% use peterson-gorenstein-zierler algorithm to find error locator
% polynomial sigma
v = t+1;
detM = 0;
while (detM == 0)&&(v>0)
    v = v-1;
    synd_matrix = gf(zeros(v),m);
    for i = 1:v
        synd_matrix(i,:) = gfsynd(i:(i+v-1));
    end
%     detM = det(synd_matrix);
    detM = rank(synd_matrix)==length(synd_matrix);
end

error = gf(zeros(n,1));

if v>0 % if v=0, there are no errors
    Svector = -gfsynd((v+1):(2*v))';
    Lvector = synd_matrix\Svector;
    % Lvector is the error locating polynomial coefficients in column form
    sigma = [Lvector',1];
    sigma_roots = roots(sigma);
    
    error_locations = sigma_roots.^(-1);
    
    if any(error_locations)
        for i = 1:length(error_locations)
            error_index(i) = find(alpha == error_locations(i));
        end
        
        for j = 1:length(error_index)
            error(error_index(j)) = 1;
        end
    end
end

end