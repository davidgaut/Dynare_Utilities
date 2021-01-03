function [fval,dlik] = logFreq(Iy,T,frequency,iky,dr,M_,lnprior)
% Compute log-likelihood function in the frequency domain (Sala 2015)

% David Gauthier - Bank of England
% davd.gauthier@gmail.com

S = Dens(iky,dr,M_);

% Initialize filter
freqs = (2*pi * (1:T - 1) / T)';
lowest_periodicity=frequency(2);
highest_periodicity=frequency(1);
filter_gain = zeros(1,T);
highest_periodicity=max(2,highest_periodicity); % restrict to upper bound of pi
filter_gain(freqs>=2*pi/lowest_periodicity & freqs<=2*pi/highest_periodicity)=1;
filter_gain(freqs<=-2*pi/lowest_periodicity+2*pi & freqs>=-2*pi/highest_periodicity+2*pi)=1;

omega = freqs; t1 = 0; t2 = 0;
for ig = 1:length(freqs)
    if filter_gain(ig) == 0
    t1 = t1 + 0;
    t2 = t2 + 0;        
    else
    t1 = t1 + log(det(S(omega(ig))));
    t2 = t2 + trace(S(omega(ig)) \ Iy(omega(ig)));
    end
end

likelihood = - 1/2 * real(t1 + t2);

dlik =  likelihood; 
fval = -(likelihood + lnprior);
end

function S = Dens(iky,dr,M_)
% Compute density in frequency domain

nspred  = M_.nspred;
nstatic = M_.nstatic;
ipred   = nstatic+(1:nspred)';

[A,B] = kalman_transition_matrix(dr,ipred,1:nspred,M_.exo_nbr);
Sigma = sqrt(M_.Sigma_e);
aa    = dr.ghx(iky,:); 
bb    = dr.ghu(iky,:); 

A = @(omega) [aa * exp(-1i*omega) bb]*[((eye(size(A)) - A * exp(-1i*omega)) \ B) ; eye(size(B,2))] *(Sigma);
S = @(omega) 1/(2*pi) * (A(omega)) * ctranspose(A(omega));

end