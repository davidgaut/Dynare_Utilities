function [x,FVAL,EXITFLAG,OUTPUT,GRAD,HESSIAN] = fminunc_dynare(FUN,x,varargin)
% options = [];
% dsge_likelihood(xparam1,DynareDataset,DatasetInfo,DynareOptions,Model,EstimatedParameters,BayesInfo,BoundsInfo,DynareResults,derivatives_info)

% options = optimset('fminunc');
% options = optimset('Display','iter-detailed','Diagnostics','off','TolX',1e-12,'TolFun',1e-12,'Algorithm','quasi-newton');
options.('Display') = 'iter-detailed';
% options.('MaxFunEvals') = 1e8;
% options.('MaxIter') = 1e8;
options.('TolFun')  = 1e-10;
options.('TolX')  = 1e-10;
% options.('Algorithm') = 'sqp';

if 0
options = optimoptions(@fminunc,'Display','iter','Algorithm','quasi-newton');
[x,FVAL,EXITFLAG,OUTPUT,GRAD,HESSIAN] = fminunc(FUN,x,options,varargin{:});
elseif 0
options = optimoptions(@fminunc,'Display','iter','Algorithm','quasi-newton');
[x,FVAL,EXITFLAG,OUTPUT,GRAD,HESSIAN] = fminunc(FUN,x,options,varargin{:});
elseif 0
options.('UseParallel') = true;
options.('Display') = 'iter';
% options.('HybridFcn') = 'fmincon';
% options.('MaxTime') = 30;
% options = optimoptions('ga','MaxTime',30,'Display','iter','HybridFcn','fmincon');

FUN = @(x) dsge_likelihood(x,varargin{:});
bounds = varargin{end-1};
[x,FVAL,EXITFLAG,OUTPUT,GRAD,HESSIAN] = ga(FUN,length(x),[],[],[],[],bounds.lb,bounds.ub,[],options);

x = x(:);
elseif 1
options = optimoptions('particleswarm');

options.('UseParallel') = true;
options.('Display') = 'iter';
% options.('HybridFcn') = 'fmincon';
% options.('MaxTime') = 30;
% options.('UseVectorized') = true;
options.('SwarmSize') = 256;
FUN = @(x) dsge_likelihood(x,varargin{:});
bounds = varargin{end-1};
[x,FVAL,EXITFLAG] = particleswarm(FUN,length(x),bounds.lb,bounds.ub,options);

x = x(:);
end
disp('End Optimization!')
disp(char(strcat((varargin{6}.name),' = ', num2str(x),';')))


