%
% Status : main Dynare file
%
% Warning : this file is generated automatically by Dynare
%           from model file (.mod)

if isoctave || matlab_ver_less_than('8.6')
    clear all
else
    clearvars -global
    clear_persistent_variables(fileparts(which('dynare')), false)
end
tic0 = tic;
% Save empty dates and dseries objects in memory.
dates('initialize');
dseries('initialize');
% Define global variables.
global M_ options_ oo_ estim_params_ bayestopt_ dataset_ dataset_info estimation_info ys0_ ex0_
options_ = [];
M_.fname = 'IRFmatch';
M_.dynare_version = '4.5.6';
oo_.dynare_version = '4.5.6';
options_.dynare_version = '4.5.6';
%
% Some global variables initialization
%
global_initialization;
diary off;
diary('IRFmatch.log');
M_.exo_names = 'eps1';
M_.exo_names_tex = 'eps1';
M_.exo_names_long = 'eps1';
M_.exo_names = char(M_.exo_names, 'eps2');
M_.exo_names_tex = char(M_.exo_names_tex, 'eps2');
M_.exo_names_long = char(M_.exo_names_long, 'eps2');
M_.endo_names = 'X1';
M_.endo_names_tex = 'X1';
M_.endo_names_long = 'X1';
M_.endo_names = char(M_.endo_names, 'X2');
M_.endo_names_tex = char(M_.endo_names_tex, 'X2');
M_.endo_names_long = char(M_.endo_names_long, 'X2');
M_.endo_partitions = struct();
M_.param_names = 'f11';
M_.param_names_tex = 'f11';
M_.param_names_long = 'f11';
M_.param_names = char(M_.param_names, 'f12');
M_.param_names_tex = char(M_.param_names_tex, 'f12');
M_.param_names_long = char(M_.param_names_long, 'f12');
M_.param_names = char(M_.param_names, 'f21');
M_.param_names_tex = char(M_.param_names_tex, 'f21');
M_.param_names_long = char(M_.param_names_long, 'f21');
M_.param_names = char(M_.param_names, 'f22');
M_.param_names_tex = char(M_.param_names_tex, 'f22');
M_.param_names_long = char(M_.param_names_long, 'f22');
M_.param_names = char(M_.param_names, 'b12');
M_.param_names_tex = char(M_.param_names_tex, 'b12');
M_.param_names_long = char(M_.param_names_long, 'b12');
M_.param_names = char(M_.param_names, 'b21');
M_.param_names_tex = char(M_.param_names_tex, 'b21');
M_.param_names_long = char(M_.param_names_long, 'b21');
M_.param_partitions = struct();
M_.exo_det_nbr = 0;
M_.exo_nbr = 2;
M_.endo_nbr = 2;
M_.param_nbr = 6;
M_.orig_endo_nbr = 2;
M_.aux_vars = [];
options_.varobs = cell(1);
options_.varobs(1)  = {'X1'};
options_.varobs_id = [ 1  ];
M_.Sigma_e = zeros(2, 2);
M_.Correlation_matrix = eye(2, 2);
M_.H = 0;
M_.Correlation_matrix_ME = 1;
M_.sigma_e_is_diagonal = 1;
M_.det_shocks = [];
options_.block=0;
options_.bytecode=0;
options_.use_dll=0;
M_.hessian_eq_zero = 1;
erase_compiled_function('IRFmatch_static');
erase_compiled_function('IRFmatch_dynamic');
M_.orig_eq_nbr = 2;
M_.eq_nbr = 2;
M_.ramsey_eq_nbr = 0;
M_.set_auxiliary_variables = exist(['./' M_.fname '_set_auxiliary_variables.m'], 'file') == 2;
M_.lead_lag_incidence = [
 1 3;
 2 4;]';
M_.nstatic = 0;
M_.nfwrd   = 0;
M_.npred   = 2;
M_.nboth   = 0;
M_.nsfwrd   = 0;
M_.nspred   = 2;
M_.ndynamic   = 2;
M_.equations_tags = {
};
M_.static_and_dynamic_models_differ = 0;
M_.exo_names_orig_ord = [1:2];
M_.maximum_lag = 1;
M_.maximum_lead = 0;
M_.maximum_endo_lag = 1;
M_.maximum_endo_lead = 0;
oo_.steady_state = zeros(2, 1);
M_.maximum_exo_lag = 0;
M_.maximum_exo_lead = 0;
oo_.exo_steady_state = zeros(2, 1);
M_.params = NaN(6, 1);
M_.NNZDerivatives = [10; -1; -1];
clc, close all
X1 = [1:10];
save fsdat X1
addpath(genpath('Codes'))
M_.params( 1 ) = 0.4;
f11 = M_.params( 1 );
M_.params( 2 ) = 0.4;
f12 = M_.params( 2 );
M_.params( 3 ) = 0.4;
f21 = M_.params( 3 );
M_.params( 4 ) = 0.4;
f22 = M_.params( 4 );
M_.params( 5 ) = 1.;
b12 = M_.params( 5 );
M_.params( 6 ) = 0.6;
b21 = M_.params( 6 );
%
% SHOCKS instructions
%
M_.exo_det_length = 0;
M_.Sigma_e(1, 1) = (1)^2;
M_.Sigma_e(2, 2) = (1)^2;
steady;
options_.order = 1;
var_list_ = char();
info = stoch_simul(var_list_);
calib = M_.params;
clear X1_resp_eps1 X1_resp_eps2 X2_resp_eps1 X2_resp_eps2 Var_IRF
F11 = 0.3;
F12 = 0.2;
F21 = 0.5;
F22 = 0.1;
B12 = 1;
B21 = 0.5;
sd = 0.5;
X1_resp_eps1(:,1) = 1+sd*randn(1e3,1);
X2_resp_eps1(:,1) = (1/B21)*X1_resp_eps1(:,1);
X2_resp_eps2(:,1) = 1+sd*randn(1e3,1);
X1_resp_eps2(:,1) = (1/B12)*X2_resp_eps2(:,1);
for horiz = 2 : 10
X1_resp_eps1(:,horiz) = F11*X1_resp_eps1(:,horiz-1) + F12*X2_resp_eps1(:,horiz-1) ;
X2_resp_eps1(:,horiz) = F21*X1_resp_eps1(:,horiz-1) + F22*X2_resp_eps1(:,horiz-1);
X1_resp_eps2(:,horiz) = F11*X1_resp_eps2(:,horiz-1) + F12*X2_resp_eps2(:,horiz-1) ;
X2_resp_eps2(:,horiz) = F21*X1_resp_eps2(:,horiz-1) + F22*X2_resp_eps2(:,horiz-1);
end
estim_params_.var_exo = [];
estim_params_.var_endo = [];
estim_params_.corrx = [];
estim_params_.corrn = [];
estim_params_.param_vals = [];
estim_params_.param_vals = [estim_params_.param_vals; 1, NaN, (-Inf), Inf, 3, F11, 1, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 2, NaN, (-Inf), Inf, 3, F12, 1, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 3, NaN, (-Inf), Inf, 3, F21, 1, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 4, NaN, (-Inf), Inf, 3, F22, 1, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 5, NaN, (-Inf), Inf, 3, B12, 1, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 6, NaN, (-Inf), Inf, 3, B21, 1, NaN, NaN, NaN ];
mod_var_list = {'X2' 'X1'};                                                
mod_shock_list = {'eps1' 'eps2'};                                          
options_.irfs_match_estimation = 1;                                        
horizon_est  = 10;                                                         
FigSize
subplot(2,2,1)
H = PlotSwathe(mean(X1_resp_eps1),squeeze(prctile(X1_resp_eps1,[5 95]))); hold on; h = plot([oo_.irfs.X1_eps1(1:horizon_est)'],'--','LineWidth',1.5,'Color',cmap(2)); 
title('X1 to eps1'); legend([H.patch h],{'VAR';'Calibrated DSGE'})
subplot(2,2,2)
H = PlotSwathe(mean(X1_resp_eps2),squeeze(prctile(X1_resp_eps2,[5 95]))); hold on; h = plot([oo_.irfs.X1_eps2(1:horizon_est)'],'--','LineWidth',1.5,'Color',cmap(2)); 
title('X1 to eps2'); legend([H.patch h],{'VAR';'Calibrated DSGE'})
subplot(2,2,3)
H = PlotSwathe(mean(X2_resp_eps1),squeeze(prctile(X2_resp_eps1,[5 95]))); hold on; h = plot([oo_.irfs.X2_eps1(1:horizon_est)'],'--','LineWidth',1.5,'Color',cmap(2)); 
title('X2 to eps1'); legend([H.patch h],{'VAR';'Calibrated DSGE'})
subplot(2,2,4)
H = PlotSwathe(mean(X2_resp_eps2),squeeze(prctile(X2_resp_eps2,[5 95]))); hold on; h = plot([oo_.irfs.X2_eps2(1:horizon_est)'],'--','LineWidth',1.5,'Color',cmap(2)); 
title('X2 to eps2'); legend([H.patch h],{'VAR';'Calibrated DSGE'})
X1_resp_eps1 = permute(X1_resp_eps1,[2 , 3 , 4 ,1]);
X1_resp_eps2 = permute(X1_resp_eps2,[2 , 3 , 4 ,1]);
X2_resp_eps1 = permute(X2_resp_eps1,[2 , 3 , 4 ,1]);
X2_resp_eps2 = permute(X2_resp_eps2,[2 , 3 , 4 ,1]);
Var_IRF(:,:,1,:) = [X2_resp_eps1 X1_resp_eps1];
Var_IRF(:,:,2,:) = [X2_resp_eps2 X1_resp_eps2];
StdNorm          = std(Var_IRF,0,4);
Var_IRF          = mean(Var_IRF,4);
Var_IRF          = Var_IRF(:);
StdNorm          = StdNorm(:);
VarNorm          = StdNorm.^2;
VarNorm          = diag(VarNorm);
invVarNorm       = inv(VarNorm);
logdetVarNorm    = logdet(VarNorm);
M_.Var_IRF         = Var_IRF;
M_.invVarNorm      = invVarNorm;
M_.logdetVarNorm   = logdetVarNorm;
M_.horizon_est     = horizon_est;
M_.invVarNorm      = invVarNorm;
M_.mod_var_list    = mod_var_list;
M_.mod_shock_list  = mod_shock_list;
M_.SR              = [];                 
options_.mh_jscale = 0.8;
options_.mh_nblck = 2;
options_.mh_replic = 0;
options_.mode_compute = 7;
options_.plot_priors = 1;
options_.datafile = 'fsdat.mat';
options_.order = 1;
var_list_ = char();
oo_recursive_=dynare_estimation(var_list_);
xparam = get_posterior_parameters('mode',M_,estim_params_,oo_,options_);
M_ = set_all_parameters(xparam,estim_params_,M_);
options_.order = 1;
var_list_ = char();
info = stoch_simul(var_list_);
FigSize
subplot(2,2,1)
H = PlotSwathe(mean(X1_resp_eps1,4),squeeze(prctile(X1_resp_eps1,[5 95],4))); hold on; h = plot([oo_.irfs.X1_eps1(1:horizon_est)'],'--','LineWidth',1.5,'Color',cmap(2)); 
title('X1 to eps1'); legend([H.patch h],{'VAR';'Estimated DSGE'})
subplot(2,2,2)
H = PlotSwathe(mean(X1_resp_eps2,4),squeeze(prctile(X1_resp_eps2,[5 95],4))); hold on; h = plot([oo_.irfs.X1_eps2(1:horizon_est)'],'--','LineWidth',1.5,'Color',cmap(2)); 
title('X1 to eps2'); legend([H.patch h],{'VAR';'Estimated DSGE'})
subplot(2,2,3)
H = PlotSwathe(mean(X2_resp_eps1,4),squeeze(prctile(X2_resp_eps1,[5 95],4))); hold on; h = plot([oo_.irfs.X2_eps1(1:horizon_est)'],'--','LineWidth',1.5,'Color',cmap(2)); 
title('X2 to eps1'); legend([H.patch h],{'VAR';'Estimated DSGE'})
subplot(2,2,4)
H = PlotSwathe(mean(X2_resp_eps2,4),squeeze(prctile(X2_resp_eps2,[5 95],4))); hold on; h = plot([oo_.irfs.X2_eps2(1:horizon_est)'],'--','LineWidth',1.5,'Color',cmap(2)); 
title('X2 to eps2'); legend([H.patch h],{'VAR';'Estimated DSGE'})
aux = [F11; F12; F21; F22; B12; B21;];
aux = [calib aux xparam oo_.prior.mean ]
in.cnames = strvcat('calibrated', 'true','posterior','prior');
in.rnames = ['   '; char(M_.param_names)];
disp('-----------')
disp('Estimation results:')
mprint(aux,in)
save('IRFmatch_results.mat', 'oo_', 'M_', 'options_');
if exist('estim_params_', 'var') == 1
  save('IRFmatch_results.mat', 'estim_params_', '-append');
end
if exist('bayestopt_', 'var') == 1
  save('IRFmatch_results.mat', 'bayestopt_', '-append');
end
if exist('dataset_', 'var') == 1
  save('IRFmatch_results.mat', 'dataset_', '-append');
end
if exist('estimation_info', 'var') == 1
  save('IRFmatch_results.mat', 'estimation_info', '-append');
end
if exist('dataset_info', 'var') == 1
  save('IRFmatch_results.mat', 'dataset_info', '-append');
end
if exist('oo_recursive_', 'var') == 1
  save('IRFmatch_results.mat', 'oo_recursive_', '-append');
end


disp(['Total computing time : ' dynsec2hms(toc(tic0)) ]);
if ~isempty(lastwarn)
  disp('Note: warning(s) encountered in MATLAB/Octave code')
end
diary off
