load YD_Estimation_results

var,shocks,M_,oo_,options_

param_nam_C   = {'phii_p'}; % very large impact on debt level response etc
paramspot     = M_.params(strcmp(M_.param_names,param_nam_C));

v2  = [paramspot] * 0.0;
v1  = [paramspot] * 5;
nn  = 10;

vp1 = [paramspot ; linspace(v2(1) * 1,v1(1),nn)'];

vp1 = linspace(0,0.5,nn);

long   = 30;  % number of periods of simulation
drop   = 0;   % truncation (in order 2)
replic = 0;   % number of replications (in order 2)
iorder = 1;   % first or second order approximation

var_list = {'nu' 'c' 'i' 'R_' 'pi' 'l' 'be' 'Se' 'bi' 'Si' 'y' 's'};
mod_var_list       = var_list; %'l' 'b'%{'gdp' 'pi' 'R' 'yy' };  % List variables to match
% mod_shock_list     = {'e_A' 'e_zetac' 'e_zetai' 'e_xp' 'e_gammae'};
mod_shock_list     = {'e_nu'};
snames = mod_shock_list;

std_shocks = 1;
var_irf_plot = 0;
clear VV
icount = 0;
for i1 = 1 : nn
% for i2 = 1 : nn
% for i3 = 1 : nn
% for i4 = 1 : nn
%     for i5 = 1 : nn
    icount = icount +1;
    VV(icount,1) = [vp1(i1)];%vp2(i2) vp3(i3) ];%vp4(i4) vp5(i5)];
%     end
% end
end
% end
% end

clear idx_param idx_variables
for vv = 1 : length(param_nam_C)
idx_param(vv) = find(strcmp(param_nam_C(vv),M_.param_names));
end
for vv = 1 : length(mod_var_list)
idx_variables(vv) = find(strcmp(mod_var_list(vv),M_.endo_names));
end

idx_Color = floor(linspace(1,size(autumn,1),size(VV,1)));
colmp     = hsv;
colmp     = (colmp(idx_Color,:));

options_.qz_criterium = 1.000000001;
count = 0;

nvar_exo = length(mod_shock_list);
% Var_IRF_Plot  = (reshape(Var_IRF,[horizon_est,nvar,nvar_exo]));

for ij = 1 : length(mod_shock_list)
clear VVpass DSGE_IRF
for iji = 1 : size(VV)    
sck     = find(strcmp(M_.exo_names, mod_shock_list{ij}));
e1      = zeros(M_.exo_nbr,1);
e1(sck) = std_shocks;

M_.params(idx_param) = [VV(iji,:)];   

clear y2 

try
    
% M_.params = BLD_Param_Set(M_);

[oo_.dr, info, M_, options_, oo_] = resol(0,M_,options_,oo_);


if info ~= 0; print_info(info, 0, options_);end

count = count + 1;
VVpass(count,:) = VV(iji,:);

y1 = irf(M_,options_,oo_.dr, e1, long, drop, replic, iorder);
y2 = y1(idx_variables,:);
    
% if y2(1,1)>0
    colif = colmp(iji,:);
%     xcond(iji,:) = [1 VV(iji,:)];
% else
%     colif = 'k';
%     xcond(iji,:) = [0 VV(iji,:)];
% end
% for i = 1 : length(IRF_variables)    
% subplot(3,2,i)
% plot(y2(i,:),'Color',colif);hold on; axis tight
% % plot(xlim,[0 0])
% title(IRF_variables(i))
% end

DSGE_IRF(:,:,count) = y2;

catch last
    display([last.message ' , ' num2str([VV(iji,:)])])
end
end

DSGE_IRF_Plot = DSGE_IRF * 100;
idxVar=[1:length(idx_variables)]
horizon_est = 30
% Plot Options
r               = 3;
l               = ceil(length(idxVar) / 2);
lw              = 1.5;
sd              = 1;
ShT             = 1;
idx_p           = 1;
horiz           = horizon_est;
tt              = 1:horiz;
patch_time      = [tt flipdim(tt,2)]';
RGB_middle      = [.7 .7 .7];     % color for the midlle area
RGB_edge_middle = [.6 .6 .6];     % color for edge of the middle area
color_choice
colormap default

cm      = colormap;
idx_col = floor(64 / count);
cm      = cm(1:idx_col:end,:);

% var_Estimate_FullN = {'Output' 'Inflation' 'Policy Rate' 'Invest. / Output' 'Loans' 'Bonds'};
% var_Estimate_FullN = var_Estimate_FullN(idxVar);
var_Estimate_FullN = mod_var_list;
% for ShT = 1 : size(Var_IRF_Plot,3)
fig(ShT) = figure('Name',snames{ij});
for idx_p = 1 : length(mod_var_list)
subplot(l,r,idx_p);hold on
if var_irf_plot
Hpatch = [patch_time [B1(1:horiz,idx_p,ij);flipdim(B2(1:horiz,idx_p,ij),1)]];
patch(Hpatch(:,1),Hpatch(:,2),RGB_middle,'edgecolor',RGB_edge_middle); hold on;	
h2     = plot(Var_IRF_Plot(:,idx_p,ij),'color',blue,'LineWidth',lw); 
end
for paramc = 1 : count 
h1 = plot(real(squeeze(DSGE_IRF_Plot(idx_p,:,paramc))),'Color',cm(paramc,:),'LineWidth',1);hold on;
end
ylims = ylim;
ylim(1.1 * ylims); ylims = get(gca,'ylim');
xlim([1 horizon_est]); xlims = get(gca,'xlim');
plot([sd horizon_est],[0 0],'k','LineStyle','-'); 
plot([xlims(1) xlims(1)],[ylims(1) ylims(end)],'k','LineWidth',0.5);
plot([xlims(end) xlims(end)],[ylims(1) ylims(end)],'k','LineWidth',0.5)
title(var_Estimate_FullN{idx_p})
box on
end

legend([cellstr(num2str(VVpass))'],'Orientation','vertical','Location',[0.5 .025 0 0])
legend('boxoff')

set(findall(fig(ShT) , 'Type', 'Text'),'FontWeight', 'Normal')
end

