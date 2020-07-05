function disp_fig = irf_sensitivity_run(para,vari,shocks,bounds,div,M_,oo_,options_)

% Plots Dynare irfs for different values of para
%-----------------------------------------------
% David Gauthier - Bank of England - 07/2020
%-----------------------------------------------
% para   - parameters to change
% shocks - shocks to plot
% vari   - variables to plot
% bounds - bounds for param
% div    - number for param val
%----------------------------------------------------------------------------------------------------------------
% disp_fig = irf_sensitivity_run(M_.param_names(1),M_.endo_names(1),M_.exo_names(1),[0,1],5,M_,oo_,options_);
%----------------------------------------------------------------------------------------------------------------

% Init
vp1 = linspace(bounds(1),bounds(2),div)';

idx_var = cellfun(@(x) find(strcmp(x,cellstr(M_.endo_names))),cellstr(vari));
idx_par = cellfun(@(x) find(strcmp(x,cellstr(M_.param_names))),cellstr(para));
idx_shk = cellfun(@(x) find(strcmp(x,cellstr(M_.exo_names))),cellstr(shocks));


long = 30;

% Simul
for ij =  1 : length(shocks)
count   = 0;    

sck     = find(strcmp(M_.exo_names, shocks{ij}));
e1      = zeros(M_.exo_nbr,1);
e1(sck) = 1;

for iji = 1 : size(vp1)  
    
    M_.params(idx_par) = vp1(iji,:);   

try
    [oo_.dr, info, M_, options_, oo_] = resol(0,M_,options_,oo_);
    
    if info ~= 0; print_info(info, 0, options_);end; count = count + 1;
    
    VVpass(count,:,ij) = vp1(iji,:);
    
    y1 = irf(M_,options_,oo_.dr, e1, long, 0, 0, 1);
    y2 = y1(idx_var,:);
    
    DSGE_IRF(:,:,count,ij) = y2 * 100;

catch last
    display([last.message ' , ' num2str([vp1(iji,:)])])
end
end
end

% Plot
r  = ceil(sqrt(length(idx_var))); 
l  = ceil(sqrt(length(idx_var)));
lw = 1.0; sd = 1;

color_choice
% colormap hsv
colormap default
cm      = colormap;
idx_col = ceil(linspace(1,length(cm),count));
cm      = cm(idx_col,:);

for ij = 1 : length(shocks)
disp_fig(ij) = figure('Name',shocks{ij},'Position',[58         252        1744         732]);
for idx_p = 1 : length(vari)
subplot(l,r,idx_p);hold on
for paramc = 1 : count 
h1 = plot(real(squeeze(DSGE_IRF(idx_p,:,paramc))),'Color',cm(paramc,:),'LineWidth',lw);hold on;
end
ylims = ylim;
ylim(1.1 * ylims); ylims = get(gca,'ylim');
xlim([1 long]); xlims = get(gca,'xlim');
plot([sd long],[0 0],'k','LineStyle','-'); 
plot([xlims(1) xlims(1)],[ylims(1) ylims(end)],'k','LineWidth',0.5);
plot([xlims(end) xlims(end)],[ylims(1) ylims(end)],'k','LineWidth',0.5)
title(vari{idx_p})
box on
end

legend(cellstr(num2str(VVpass(:,:,1)))','Orientation','vertical','position',[0.0295    0.4598    0.0430    0.1851])
legend('boxoff')

set(findall(disp_fig(ij) , 'Type', 'Text'),'FontWeight', 'Normal')
end
