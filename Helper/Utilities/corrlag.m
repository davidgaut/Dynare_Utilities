function CL = corrlag(s1,s2,L)

% the first series is moved

for ii = 1 : L
cor1(ii) = corr(s1(1+ii:end),s2(1:end-ii));
cor2(ii) = corr(s2(1+ii:end),s1(1:end-ii));
end

CL = [flip([flip(cor1),corr(s1,s2),cor2])',(-L:L)'];