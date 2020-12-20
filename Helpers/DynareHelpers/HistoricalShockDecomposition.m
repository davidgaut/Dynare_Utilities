
% Load variables
varnames = cellstr(M_.endo_names);

% Pick a Shock
shock = {'e_nu'};
shock_number = find(strcmp(shock,M_.exo_names));

% var_names = {'consumption_obs','householdcredit_obs','householdspread_obs','investment_obs',...
%              'firmcredit_obs','firmspread_obs','bankcapital_obs','houseprice_obs',...
%              'stockprice_obs','npl_obs'};
%     
var_names =   options_.varobs;       

%--------------------------------------------------------------------------
% Settings
%--------------------------------------------------------------------------

% Font size
fontsize   = 9; % 11 slides

% Line shape
linewidth = 2;
lineform = 'none';

% Font style and size
set(0,'DefaultTextFontname','times')
set(0,'DefaultAxesFontName','times')
set(0,'DefaultTextFontSize',fontsize)
set(0,'DefaultAxesFontSize',fontsize)
set(0,'DefaultAxesTitleFontWeight','normal')

% Color choice
blue  = [0 0.4470 0.7410];
peach = [0.8500 0.3250 0.0980];

% Rows and columns
l = 5;
r = 5;
n = 1;

% Date range
startDate = 1999;
% startDate = 1980;
endDate  = 2019;

%--------------------------------------------------------------------------
% Block 1 (One for Each Variable)
%--------------------------------------------------------------------------

figure('Name',sprintf('HD for Estimation %s','BG'),'NumberTitle','off','Position',[1000.00        650.00       1316.00        688.00]);

%oo_.shock_decomposition(:, end, :) = (squeeze(oo_.shock_decomposition(:, end, :)) - squeeze(oo_.shock_decomposition(:, end-1, :)));
    
for ij = 1:length(var_names)
% Variable
idx = find(strcmp(varnames,var_names{ij}));

% Simulate variable with nu shock
var  = squeeze(oo_.shock_decomposition(idx,shock_number,:)); 

% Annualize
var4 = var(4:end) + var(3:(end-1)) + var(2:(end-2)) + var(1:(end-3));

% Simulate variable with all shocks
vars  = squeeze(oo_.shock_decomposition(idx, end, :));

% Annualize
vars4 = vars(4:end) + vars(3:(end-1)) + vars(2:(end-2)) + vars(1:(end-3));

% Sample size
sample_size =  length(var4);

% Plot
s1 = subplot(l,r,ij);
p = plot(endDate-sample_size/4+(1:sample_size)/4, var4 * 100, '-',...
    endDate-sample_size/4+(1:sample_size)/4, vars4 * 100, '-.') ; 
p(1).LineWidth = linewidth;
p(2).LineWidth = linewidth;
p(1).Color = peach;
p(2).Color = blue;
p(1).Marker = lineform;
%set(gca,'TitleFontSizeMultiplier',multiplier)

% Axes limits
xlim([startDate, endDate+1])
% ylim([min(vars4)*100, max(var4)*100])
% ylim([-5 5])
xlimits = get(gca,'XLim'); % get axis 

% CEPR_Set recessions
CEPR_Set

% Plot again on top of CEPR_Set recessions
p = plot(endDate-sample_size/4+(1:sample_size)/4, var4 * 100, '-',...
    endDate-sample_size/4+(1:sample_size)/4, vars4 * 100, '-.') ; % var for nushock
p(1).LineWidth = linewidth;
p(2).LineWidth = linewidth;
p(1).Color = peach;
p(2).Color = blue;
p(1).Marker = lineform;

% Ticks X axis
set(gca,'Xtick',[1990 2000 2005 2010 2015 2020])

% Ticks Y axis
NumTicks = 3; L = get(gca,'YLim'); set(gca,'YTick',linspace(L(1),L(2),NumTicks))

% Title
title([var_names{ij} '(corr = ',num2str(corr(var4,vars4),'%.2f'),')'],'FontSize',fontsize)

axegstack{ij} = p;
figstack{ij}  = s1;
end

% suptitle({''})
% set(t6,'FontSize',fontsize)


% Size of adjustment
up   = 0.07; % 0.07 paper, 0.11 slides
down = 0.02; % 0.01 paper, 0.02 slides 


% Subplot 1
% for ij = 1:length(var_names)
% p1    = get(figstack{ij},'position'); % Get position
% p1(2) = p1(2) + up;         % Second element is bottom, adjust bottom
% set(figstack{ij},'position',p1);      % Define new position
% end


%--------------------------------------------------------------------------
% Legend
%--------------------------------------------------------------------------

[L1,hobj,~,~] = legend('Only Collateral Shock','Data (All Shocks)','location',[0.51 0.51 0 0]);
%set(L1,'FontSize',fontsize)
hline = findobj(hobj,'type','line');
set(hline(3),'LineWidth',2.8);
htext = findobj(hobj,'type','text');
set(htext,'FontSize',fontsize);
legend boxoff


%--------------------------------------------------------------------------
% Common Y Label
%--------------------------------------------------------------------------

% height = p1(2) + p1(4) - p4(2);
% h3     = axes('position',[p4(1) p4(2) p4(3) height],'visible','off');

% Common y label
commonlabel = ylabel('Annual Percentage Points','fontsize',fontsize,'visible','on');


%--------------------------------------------------------------------------
% Save figure
%--------------------------------------------------------------------------

if 0
    fig = gcf; fig.PaperUnits = 'inches';
    fig.PaperPosition = [1.3333  3.3125  6.5  3.5]; % [left bottom width height] 
    print('HistDec','-dpng','-r500')
end




