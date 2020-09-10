% PriorSensitivityAnalysis

% With dynare estimation structure
% Plot irfs confidence bands and no-solution mapping

addpath D:\Programmes\dynare-4.6.1\matlab\missing\mex\mjdgges

list_var = [{'Output'}    {'Consumption'}    {'Investment'}    {'l'}    {'SpreadLTI'}    {'SpreadLTG'}    {'SpreadLTF'}    {'NetWorth'}    {'r_ann'}    {'pi_ann'}    {'REER'}];
% list_var = [{'y_' 'c_' 'i_' 'l_' 'be_' 'bi_' 'Si_' 'Se_' 'qh' 'qk' 'qhtilde' 'qktilde' 's'}];
list_shk = [M_.exo_names];

NonIterate = [M_.exo_names]% ; fieldnames(oo_.SmoothedMeasurementErrors)];

Text_Font = 'Palatino Linotype';

options_.qz_criterium = 0.99999;

number_draws = 2000;
save_output  = 0;
long   = 30;  % number of periods of simulation
drop   = 0;   % truncation (in order 2)
replic = 0;   % number of replications (in order 2)
iorder = 1;   % first or second order approximation

% Initialize
lim_idx = bayestopt_.p4==Inf;
limits  = zeros(length(bayestopt_.p4),2);
limits(lim_idx ,1)  = bayestopt_.p1(lim_idx) - 2 *bayestopt_.p2(lim_idx);
limits(lim_idx ,2)  = bayestopt_.p1(lim_idx) + 2 *bayestopt_.p2(lim_idx);
limits(~lim_idx ,2) = bayestopt_.p3(~lim_idx);
limits(~lim_idx ,2) = bayestopt_.p4(~lim_idx);

uniform = 1;
if ~uniform
init    = prior_draw(bayestopt_,0,0);
% Draw
draw_param = @() prior_draw()';
else
clear distrib  
for ii = 1 : size(bayestopt_.p2,1)
    p1 = limits((ii),1);
	p2 = limits((ii),2);
[x,f,abscissa,dens,binf,bsup] = draw_prior_density((ii),bayestopt_);
fprintf('Parameter %s: lower %d, upper %d.\n',bayestopt_.name{(ii)},p1,p2)
distrib(ii,1) = makedist('Uniform','lower',p1,'upper',p2);
end
draw_param = @() arrayfun(@random,distrib);
end

% Model
param_estim = bayestopt_.name(~ismember(bayestopt_.name,NonIterate));
% param_estim = param_estim(2:end)
idx_estim1  = cellfun(@(x) find(strcmp(x,M_.param_names)),param_estim);
idx_estim2  = cellfun(@(x) find(strcmp(x,bayestopt_.name)),param_estim);
idx_vars    = cellfun(@(x) find(strcmp(x,M_.endo_names)),list_var);
idx_shck    = cellfun(@(x) find(strcmp(x,M_.exo_names)),list_shk);

count = 0; error_stack = []; param_hist = []; param_all = [];
for draw_iter = 1:number_draws
try
    draw = draw_param(); if ~rem(draw_iter,200); fprintf('Iteration: %s. %s \n',num2str(draw_iter),repmat('\b',1,length(num2str(draw_iter)))); end

M_.params(idx_estim1) = draw(idx_estim2);
param_hist            = [param_hist M_.params(idx_estim1)];
[oo_.dr,info]         = stochastic_solvers(oo_.dr,0,M_,options_,oo_);

if info ~= 0; print_info(info, 0, options_);end
param_all            = [param_all M_.params(idx_estim1)];

count = count + 1;
for shk_nbr = 1 : length(list_shk)
sck     = shk_nbr;
e1      = zeros(M_.exo_nbr,1);
e1(sck) = 0.001;

y1 = irf(M_,options_,oo_.dr, e1, long, drop, replic, iorder);

y2(:,:,shk_nbr,count) = y1(idx_vars,:);
end
catch last
%     display([last.message])
    error_stack = [error_stack last.message];
end
end

%% Plot Responses

snames = idx_shck;
count2 = count;
y2S = y2;

lw              = 1.5;
sd              = 1;
ShT             = 1;
tt              = 1:long;
patch_time      = [tt flipdim(tt,2)]';
RGB_middle      = [.7 .7 .7];     % color for the midlle area
RGB_edge_middle = [.6 .6 .6];     % color for edge of the middle area
color_choice
bb = 0.025;
% bb = 0.0;

colormap default
cm      = repmat(colormap,100,1);
idx_col = floor(64 / count2);
y2S11   = sort(y2S,4)*100;
y2S1    = y2S11(:,:,:,[ceil(count2*bb+1),ceil(count2*(1-bb))]);
y2SB    = y2S11(:,:,:,[1,end]);
y2SM    = mean(y2S1(:,:,:,:),4);

max_shck        = 6;
l               = max_shck;
r               = length(list_var);
Posit1          = [0.4882   -0.4054    0.9848    1.1672] * 1000;
idx_sp          = repmat([[1 6 5 4 2 3]],1,3);
Hpatch          = [(0:long-1)' ; flipdim((0:long-1)',1)];           

for shk_grp = 0 : 1 + ceil(length(idx_shck) / max_shck) : length(idx_shck)
    fig(shk_grp+1) = figure('Name','First','Position',Posit1); ppsb = 1;

for idx_p   = 1 : length(list_var)
for ShT     = shk_grp + 1 : min(shk_grp + max_shck,length(list_shk))% 
    l = length(shk_grp + 1 : min(shk_grp + max_shck,length(list_shk)));

subplot(r,l,ppsb);hold on
patch([Hpatch(:,1)],...
    [(y2S1(idx_p,:,ShT,1))'; flipdim(y2S1(idx_p,:,ShT,2)',1)],...
	RGB_middle,'edgecolor',RGB_edge_middle,'FaceAlpha',0.5); hold on;	

plot([0 long],[0 0],'r','LineStyle','-','LineWidth',1); 

for paramc = 1 : 1
% if squeeze(y2(1,1,ShT,paramc)) < 0; break;end
hm = plot([0 : length(y2SM(idx_p,:,ShT))-1], real(squeeze(y2SM(idx_p,:,ShT))),'Color',cm(paramc,:),'LineWidth',2,'LineStyle','--');hold on;
h1 = plot([0 : length(y2SM(idx_p,:,ShT))-1],real(squeeze(y2S1(idx_p,:,ShT,:))),'Color',cm(paramc,:),'LineWidth',1);hold on;
% h2 = plot(real(squeeze(y2SB(idx_p,:,ShT,paramc))),'Color','r','LineWidth',1);hold on;
end
ylims = ylim;
ylim(1.0 * ylims);  ylims = get(gca,'ylim');
xlim([0 long / 2]); xlims = get(gca,'xlim');
plot([xlims(1) xlims(1)],[ylims(1) ylims(end)],'k','LineWidth',0.5);
plot([xlims(end) xlims(end)],[ylims(1) ylims(end)],'k','LineWidth',0.5)

if rem(shk_grp + 1,ShT) == 0
    ylab{idx_p} = ylabel(list_var{idx_p}, 'Interpreter', 'none');
    ylpo = get(ylab{idx_p},'Position');
    ylpo(1) = -10.0;
    set(ylab{idx_p},'Position',ylpo)
    set(get(gca,'YLabel'),'Rotation',0)
end
if idx_p == r
    xlabel('Quarters')
end

if idx_p == 1
    title(list_shk{ShT})
end

ppsb = ppsb + 1;
end
end

% cellfun(@(x) set(x,'Position',[-4.1118    0.1000   -1.0000]),ylab)
set(findall(fig(shk_grp+1) , 'Type', 'Text'),'FontWeight', 'Normal')
set(findall(fig(shk_grp+1) , 'Type', 'Text'),'FontSize', 10)
set(findall(fig(shk_grp+1) , 'Type', 'Text'),'FontName', Text_Font)

if save_output
print([pathSave,'/',char('ResponseInterval_01'),num2str(shk_grp)],'-dpng')
end
end

%% Accepted and Rejected
n1=7;n2=7;
FigDraws = figure('Name','Parameter Space','Position',[437   228   710   856]);
param_names_Tex = M_.param_names_tex(idx_estim1);
for ii = 1 : size(param_hist,1)
hsp = subplot(n1,n2,ii);

[hh,edged] = histcounts(param_all(ii,:),40,'Normalization','pdf'); 
% plot(edged(1:end-1),hh,'LineWidth',1.5); hold on; axis tight
h1=histogram(param_all(ii,:) ,40,'Normalization','pdf'); hold on; axis tight
h2=histogram(param_hist(ii,:),40,'Normalization','pdf'); hold on; axis tight
h1.FaceColor = peach; h1.EdgeAlpha = 0; h1.FaceAlpha = 0.8;
h2.FaceColor = blue;  h2.EdgeAlpha = 0; h2.FaceAlpha = 0.8;
% hsp.XLim = round(hsp.XLim,1);
hsp.YTick = []; hsp.XTick = (linspace(hsp.XLim(1),hsp.XLim(end),5));
hsp.XTick = round(linspace(hsp.XTick(1),hsp.XTick(end),3),3);
hsp.XLim  = round(linspace(hsp.XTick(1),hsp.XTick(end),2),3);

[x,f,abscissa,dens,binf,bsup] = draw_prior_density(idx_estim2(ii),bayestopt_);
plot(abscissa,dens,'Color','r','LineWidth',0.5);hold on
title(bayestopt_.name{idx_estim2(ii)});

xlim([bayestopt_.p3(idx_estim2(ii)),bayestopt_.p4(idx_estim2(ii))])
xticks([bayestopt_.p3(idx_estim2(ii)),bayestopt_.p5(idx_estim2(ii)),bayestopt_.p4(idx_estim2(ii))])

title(param_names_Tex((ii)),'Interpreter','Tex')  
% title(param_names((ii)))  
end    
% Plg = [0.4740    0.0331    0.1390    0.0225];
Plg = [0.6998 0.1346 0.2225 0.0204];
Leg = legend({'Draws','Positive'},'Orientation','Horizontal','box','off','Position',Plg);  
set(findall(FigDraws  , 'Type', 'Text'),'FontWeight', 'Normal')
set(findall(FigDraws  , 'Type', 'Text'),'FontSize', 12)
set(findall(FigDraws  , 'Type', 'Text'),'FontName', Text_Font)
set(findall(Leg  , 'Type', 'Text'),'FontWeight', 'Normal')
set(findall(Leg  , 'Type', 'Text'),'FontSize', 12)
set(findall(Leg  , 'Type', 'Text'),'FontName', Text_Font)

Txt = findall(gcf,'-property','FontSize');
set(findall(findall(Txt),'Type','Axes'),'FontName',Text_Font)

set(gcf,  'Color',    [1 1 1]); 
set(gcf,  'PaperUnits', 'inches');
set(gcf,  'InvertHardCopy', 'off'); 

if save_output
    print([pathSave,'/',char('ParamInterval') '_Horizontal'],'-dpng','-r200')
end

