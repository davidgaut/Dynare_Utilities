
%--------------------------------------------------------------------------
% Collateral Shocks
% YB and DG, PSE, June 2018
% Figure: Cross-Correlations, Data, Baseline, No Collateral, No Impatient
%--------------------------------------------------------------------------


clear; 
clc; 
close all


% Simulate model
%----------------

clear dyn_first_order_solver
cd D:\Codes\Matlab_File\DSGE_Papers\ECS\Model_ECS\
load ECS_Estimation_results

shock1 = 'e_nu';
M_.Sigma_e(~strcmp(shock1,M_.exo_names),~strcmp(shock1,M_.exo_names)) = 0;

var_list_obs_1 = {'y' 'c' 'i' 'be' 'bi' 'firmspread_obs' 'householdspread_obs'};

options_.periods   = 10000;
options_.nodisplay = 0;
options_.parallel  = 0;

stoch_simul(M_, options_, oo_,var_list_obs_1);

treat_one = @(X) cumsum(log(X(2:end) ./ X(1:end-1)));

for ii = 1 : length(var_list_obs_1)
    if ~ismember(var_list_obs_1{ii},{'firmspread_obs' 'householdspread_obs'})
    eval(['model_1_' var_list_obs_1{ii} ,' = treat_one('  var_list_obs_1{ii} ');'])
    else
	eval(['model_1_' var_list_obs_1{ii} ,' = ('  var_list_obs_1{ii} ');'])
    end
    varnames_1{ii} = ['model_1_' var_list_obs_1{ii}] ;
end

% Save output
eval(['save Model_1_Output ' strjoin(varnames_1) ' var_list_obs_1'])

%--------------------------------------------------------------------------

clear dyn_first_order_solver
cd D:\Codes\Matlab_File\Yvan_files

notPresent = {''};

BaselineAllShocks = 0;
if BaselineAllShocks
    cd D:\Matlab_File\YD_RR_Baseline_TotalDebt_Updated\
    load YD_Estimation_results.mat
    var_list_obs_2 = var_list_obs_1;
else
	load BG5_results.mat
    var_list_obs_2 = var_list_obs_1(~ismember(var_list_obs_1,notPresent)); 
    M_.Sigma_e(~strcmp('e_sigmae',M_.exo_names),~strcmp('e_sigmae',M_.exo_names)) = 0;
%     M_.Sigma_e(strcmp('e_zetac',M_.exo_names),strcmp('e_zetac',M_.exo_names)) = 0;
end

options_.periods   = 10000;
options_.nodisplay = 0;
options_.parallel  = 0;

stoch_simul(M_, options_, oo_,var_list_obs_2);

for ii = 1 : length(var_list_obs_2)
    eval(['model_2_' var_list_obs_2{ii} ,' = treat_one('  var_list_obs_2{ii} ');'])
    varnames_1{ii} = ['model_2_' var_list_obs_2{ii}] ;
end

% Save output
eval(['save Model_2_Output ' strjoin(varnames_1) ' var_list_obs_1'])

%--------------------------------------------------------------------------

clear dyn_first_order_solver
cd D:\Codes\Matlab_File\Yvan_files

% notPresent = {'bi' 'Si' 'householdspread_obs'};

BaselineAllShocks = 0;
if BaselineAllShocks
    cd D:\Matlab_File\YD_RR_Baseline_TotalDebt_Updated\
    load YD_Estimation_results.mat
    var_list_obs_2 = var_list_obs_1;
else
	load BG5_results.mat
    var_list_obs_2 = var_list_obs_1(~ismember(var_list_obs_1,notPresent)); 
%     M_.Sigma_e(~strcmp('e_sigmae',M_.exo_names),~strcmp('e_sigmae',M_.exo_names)) = 0;
%     M_.Sigma_e(~strcmp('e_nu',M_.exo_names),~strcmp('e_sigmae',M_.exo_names)) = 0;
    M_.Sigma_e(~strcmp('e_sigmai',M_.exo_names),~strcmp('e_sigmai',M_.exo_names)) = 0;
end

options_.periods   = 10000;
options_.nodisplay = 0;
options_.parallel  = 0;

stoch_simul(M_, options_, oo_,var_list_obs_2);

for ii = 1 : length(var_list_obs_2)
    eval(['model_3_' var_list_obs_2{ii} ,' = treat_one('  var_list_obs_2{ii} ');'])
    varnames_1{ii} = ['model_3_' var_list_obs_2{ii}] ;
end

% Save output
eval(['save Model_3_Output ' strjoin(varnames_1) ' var_list_obs_2'])

%--------------------------------------------------------------------------

% Load previous results
load D:\Codes\Matlab_File\DSGE_Papers\ECS\Model_ECS\Model_1_Output
%--------------------------------------------------------------------------

% Load previous results
load D:\Codes\Matlab_File\Yvan_files\Model_2_Output
%--------------------------------------------------------------------------

yoy = 1;
yoy_series = @(X) (X(5:end) - X(1:end-4))/ 4;

if yoy == 1
    for ii = 1 : length(var_list_obs_1)
    eval(['model_1_' var_list_obs_1{ii} '_yoy = yoy_series(model_1_' var_list_obs_1{ii} ');'])
    end
    for ii = 1 : length(var_list_obs_2)
    eval(['model_2_' var_list_obs_2{ii} '_yoy = yoy_series(model_2_' var_list_obs_2{ii} ');'])
    end
    for ii = 1 : length(var_list_obs_2)
    eval(['model_3_' var_list_obs_2{ii} '_yoy = yoy_series(model_3_' var_list_obs_2{ii} ');'])
    end
end


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


%% Font and line size
fontsize   = 11;
linewidth  = 1.5;

% Font style and size
set(0,'DefaultTextFontname','times')
set(0,'DefaultAxesFontName','times')
%set(0,'DefaultTextFontname','Palatino LinoType')
%set(0,'DefaultAxesFontName','Palatino LinoType')
set(0,'DefaultTextFontSize',fontsize)
set(0,'DefaultAxesFontSize',fontsize)
set(0,'DefaultAxesTitleFontWeight','normal')


% If yoy = 1, annualize
yoy = 1;

% I and theta are two inputs in the function 'correlate': They are
% parameters used in the estimation of the frequency zero part of the
% spectral density of a certain stochastic process

% Order of the highest non-zero autocorrelation assumed for the process 
I = 2;

% Controls the type of window used
thet = 1;

% If conf = 1, plot a shaded area for the empirical confidence interval on the correlation, and not the point estimate
conf = 1;

% If adj = 1, compute the correlation function in a way that all data are used for each correlation
adj = 1;

% Number of lags
lag = 12;

% Time Interval
startDate = 1987;
endDate   = 2015;
presamp   = 0;

nn  = -lag:lag;

% Array from 1 to number of periods 
ttp = 1:(lag*2+1);

% Array from number of periods to 1
ttm = (lag*2+1):-1:1;

% Create array with quarters
tt    = startDate:1/4:endDate+1/4;
[Y,I] = min(abs(tt-presamp));
tt    = tt(I:end);

% Rows and columns
row = 3;
col = 3;

conf_band =  -2.326347874040841;
conf_band =  -1.96;

% Color choice
blue   = [0 0.4470 0.7410];
peach  = [0.8500 0.3250 0.0980];
green  = [0.4660 0.6740 0.1880];
black  = [0 0 0];
colband = 0.8*[0.9 0.9 0.9];
PosFig  = [420.2000  345.8000  926.4000  270.4000];


%--------------------------------------------------------------------------
% Express Data Series in Annual Percentage Change
%--------------------------------------------------------------------------

% Load observable variables
load D:\Codes\Matlab_File\Yvan_files\BGdata

% Use CMR difftrans function
treat_3 =  @(X) difftrans(demean(X) + 1,yoy,I);

[y_growth]  = treat_3(gdp_obs);
[c_growth]  = treat_3(consumption_obs);
[i_growth]  = treat_3(investment_obs);
[l_growth]  = treat_3(hours_obs);
[bi_growth] = treat_3(householdcredit_obs);
[be_growth] = treat_3(firmcredit_obs);
[qh_growth] = treat_3(houseprice_obs);
[householdspread_obs_growth] = treat_3(householdspread_obs);
[firmspread_obs_growth]      = treat_3(firmspread_obs);

model_1_firmspread_obs_yoy = model_1_firmspread_obs_yoy(2:end);
model_1_householdspread_obs_yoy = model_1_householdspread_obs_yoy(2:end);

title_vex = {'Panel A. GDP' 'Panel B. Consumption' 'Panel C. Investment' 'Panel D. Firm Loans' 'Panel E. Household Loans' 'Panel F. Firm Spread' 'Panel G.  Household Spread' 'Panel H. GDP'};

CrossCorrFig      = figure('Position',PosFig);
CrossCorrFig.Name = 'CrossCorrelation';
p = 1;
for ii = 1 : length(var_list_obs_1)
    
    var_model_1 = eval(['model_1_' var_list_obs_1{ii} '_yoy']);
    [V,var_model_1,snsw,B,S,T] = correlate(model_1_y_yoy,var_model_1,lag,thet,I);

     var_model_2 = eval(['model_2_' var_list_obs_1{ii} '_yoy']);
    [V,var_model_2,snsw,B,S,T] = correlate(model_2_y_yoy,var_model_2,lag,thet,I);

    if BaselineAllShocks && strcmp(var_list_obs_1{ii},notPresent);
    var_model_3 = eval(['model_3_' var_list_obs_1{ii} '_yoy']);
	[V,var_model_3,snsw,B,S,T] = correlate(model_3_y_yoy,var_model_3,lag,thet,I);
    elseif ~BaselineAllShocks && sum(strcmp(var_list_obs_1{ii},notPresent));
    var_model_3 = [];
    else
	var_model_3 = eval(['model_3_' var_list_obs_1{ii} '_yoy']);
    [V,var_model_3,snsw,B,S,T] = correlate(model_3_y_yoy,var_model_3,lag,thet,I);
    end
    
    % Data
    s1 = y_growth;
    s2 = eval([var_list_obs_1{ii} '_growth']);
    idx_not_nan = find(~isnan(s2));
    [V,data,snsw,B,S,T] = correlate(s1(idx_not_nan),s2(idx_not_nan),lag,thet,I);

    % Data confidence interval
    lower_bound=data-conf_band*B(2,1:end-1)';
    upper_bound=data+conf_band*B(2,1:end-1)'; 
    confb      = [ttp' lower_bound(ttp) ; ttm' upper_bound(ttm)];

s1 = subplot(row,col,p);hold on; p = p + 1;
patch(nn(confb(:,1)),confb(:,2),colband,'edgecolor',[0.8 0.8 0.8]);
p11=plot(nn,var_model_1,'o-','Color',peach,'LineWidth',linewidth);
p12=plot(nn,var_model_2,'o-','Color',green,'LineWidth',linewidth);
if ~(~BaselineAllShocks && sum(strcmp(var_list_obs_1{ii},notPresent)))
    p13=plot(nn,var_model_3,'+-','Color',blue,'LineWidth',linewidth);
end
vline(0,'k')
plot(nn,zeros(length(nn),1),'Color',black)
hold off
set(gca,'xlim',[-12 12],'Xtick',[-10 0 10],'ylim',[-1.0 1],'Ytick',[-1 -0.5 0 0.5 1]);
box on

% To have box in black overriding other lines
xl = xlim;
yl = ylim;
hold on
plot([xl(1) xl(1)], [yl(1) yl(2)],'k')
plot([xl(2) xl(2)], [yl(1) yl(2)],'k')
plot([xl(1) xl(2)], [yl(1) yl(1)],'k')
plot([xl(1) xl(2)], [yl(2) yl(2)],'k')

% Title
title(title_vex{ii},'FontSize',fontsize)
end
legend('Baseline Model, Only Collateral Shock')
% yaxis