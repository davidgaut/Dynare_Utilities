function figp = irf_multiplot(snames,vnames,irf_size,new_fig)
global M_ oo_ options_ 

color_choice
idx_sh  = (cell2mat(cellfun(@(x) find(strcmp(x,M_.exo_names)),snames,'UniformOutput',0)));
slnames = M_.exo_names(idx_sh);
sTnames = M_.exo_names_tex(idx_sh);
idx_vr  = (cell2mat(cellfun(@(x) find(strcmp(x,M_.endo_names)),vnames,'UniformOutput',0)));
vlnames = regexprep(M_.endo_names(idx_vr),' ',' ');
vTnames = M_.endo_names_tex(idx_vr);

aux2    = repmat(vnames,1,length(snames));
aux3    = repmat(snames,length(vnames),1);

options_.nograph = 1; options_.noprint = 1; options_.nomoments = 1; options_.nofunctions = 1; options_.nocorr = 1;
[info, oo_, options_, M_] = stoch_simul(M_, options_, oo_, vnames);
print_info(info,~options_.noprint, options_);

names_select = strcat(aux2,'_',aux3);

irfs_stack = cell2mat(cellfun(@(x) getfield(oo_.irfs,x),names_select,'UniformOutput',0))';
irfs_stack = reshape(irfs_stack,[irf_size length(snames) length(vnames)]);
irfs_stack = permute(irfs_stack,[1 3 2]);

r = length(vnames); l = length(snames); Posit1 = [341 42 200+150*l 85*r];


if new_fig
figp = figure('Name','irf_multiplot','Position',Posit1); color = blue; Ls = '-';
else
figp = gcf(); hold on; color = 'r'; Ls = '--';
end
ppsb = 1;
for idx_var = 1 : length(vnames)
for idx_shk = 1 : length(snames)
   
subplot(r,l,ppsb,'align');hold on
plot([0 irf_size],[0 0],'r','LineStyle','-','LineWidth',0.5);  
hm = plot([0 : irf_size-1], squeeze(irfs_stack(:,idx_var,idx_shk))','Color',color,'LineWidth',1.5,'LineStyle',Ls);


ylims = ylim;
xlim([1 irf_size - 1]);    
xlims = get(gca,'xlim');
plot([xlims(1) xlims(1)],[ylims(1) ylims(end)],'k','LineWidth',0.5);
plot([xlims(end) xlims(end)],[ylims(1) ylims(end)],'k','LineWidth',0.5)


grid on

if (idx_shk == 1) || (idx_shk == 1+length(snames))
    ylab{idx_var} = ylabel([strcat('\boldmath $',vTnames(idx_var), '$')],'Interpreter','latex');
    ylpo = get(ylab{idx_var},'Position');
    ylpo(1) = - 15 + 1*(12-2*l);
    set(ylab{idx_var},'Position',ylpo,'Rotation',0)   ;
end

if idx_var == length(vnames) 
    xlabel('Quarters')
else
    set(hm.Parent,'XtickLabel',(''));
end

if idx_var == 1
%     title([strcat('\boldmath $',sTnames(idx_shk), '$') ;  slnames(idx_shk)],'Interpreter','latex')
    title([strcat('\boldmath $',sTnames(idx_shk), '$')],'Interpreter','latex')
end
ppsb = ppsb + 1;
end
end

% aco = cell2mat(get(findobj(gcf,'type','axes'),'OuterPosition'));
% xx  = findobj(gcf,'type','axes');
% for ii = 1 : length(xx)
% set(xx(ii),'OuterPosition',aco(ii,:)+[0.12/(l^2) 0 -0.12/(l^2) 0.00])
% end

set(findall(gca() , 'Type', 'Text'),'FontName', 'Palatino Linotype')
set(findall(figp , 'Type', 'Text'),'FontWeight', 'Bold')
set(findall(figp , 'Type', 'Text'),'FontSize', 12)
set(findall(figp , 'Type', 'Text'),'FontName', 'Palatino Linotype')
end