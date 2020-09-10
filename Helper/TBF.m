[ConditionalVarianceDecomposition, ConditionalVarianceDecomposition_ME]= conditional_variance_decomposition(StateSpaceModel, Steps, SubsetOfVariables,sigma_e_is_diagonal)


function [q1] = VAR_VDC(Beta,vmat,nvars,nlags,filter,frequency,target)
% David Gauthier
% 03 - 2020
% Bank of England


% Companion matrix of the demeaned VAR 
M                                          = zeros(nvars*nlags,nvars*nlags);			
M(1:nvars,:)                               = Beta(1:nvars*nlags,:)';
M(nvars+1:nvars*nlags,1:nvars*nlags-nvars) = eye(nvars*nlags-nvars);

vmat = [vmat ; zeros(nvars*(nlags-1),nvars)]';


if ~filter
Ij    = eye(size(vmat,2));
ej    = Ij(:,target);

% Variance, S / [S = F*S*F' + Q (Hamilton 10.2.13 )]
VV = lyapunov_symm(M,vmat'*vmat,1e-10,1,1e-15,[],0); % VV - (M*VV*M'+vmat'*vmat) % A*X*A' - E*X*E' + C % A = randn(5,5);A=A'*A;C = randn(5,5);C=C'*C; % X - (A*X*A'+C'*C)  % X = lyapunov_symm(A,C'*C,1e-10,1,1e-15,1,0)
VV - (M * VV * M' + vmat'*vmat)
% VD  = transpose(VD)*transpose(VD);

VD  = VV(1:nvars,1:nvars);
V  = 2*pi*real(integral(@(omega) DensLoop(omega,M,vmat,target),0,2*pi,'ArrayValued',true,'AbsTol'));
[VD(:) V(:)]


[V,D]   = eig(VD);                 
[~,idx] = sort(diag(D));
q1      = V(:,idx(end));

else

V  = real(integral(@(omega) DensLoop(omega,M,vmat,target),2*pi / frequency(2),2*pi / frequency(1),'ArrayValued',true));
VD = V(1:nvars,1:nvars);

[V,D]   = eig(VD);                 
[~,idx] = sort(diag(D));
q1      = V(:,idx(end));
end

function Dens = DensLoop(omega,M,vmat,target)

% Contribution to filtered variance of the targeted variable
% Giannone International Journal of Central Banking 2019 p 147

Ij    = eye(size(vmat,2));
ej    = Ij(:,target);

S     = ej' * ((eye(size(M)) - M * exp(-1i.*omega)) \ vmat') ;
Dens  = (ctranspose(S) * (S)) / (2*pi);

% Ij    = eye(size(vmat,1));
% ej    = Ij(:,target);
% 
% S     =  ((eye(size(M)) - M * exp(-1i.*omega)) \ vmat')* ej ;
% Dens1  = ((S) * ctranspose(S)) / (2*pi);
% 
% 


