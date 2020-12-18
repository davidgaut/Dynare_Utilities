

CEPR_recessions= ([  1974.50 , 1975.00;
    1980.00 , 1982.50;
    1992.00 , 1993.50;
    2008.00 , 2009.25;
    2011.50 , 2013.00;
    ]);

% ylimits = get(gca,'Ylim');

for iiii=1:1:size(CEPR_recessions,1),

    %full grey area, without edges 
    patch([CEPR_recessions(iiii,1),CEPR_recessions(iiii,2),...
           CEPR_recessions(iiii,2),CEPR_recessions(iiii,1)]',...
        [ylimits(1) ylimits(1) ylimits(2) ylimits(2)]',[0.9 0.9 0.9],'EdgeColor','none'); hold on
    
    
    %edges at bottom
    patch([CEPR_recessions(iiii,1),CEPR_recessions(iiii,2),...
           CEPR_recessions(iiii,2),CEPR_recessions(iiii,1)]',...
        [ylimits(1) ylimits(1) ylimits(1) ylimits(1)]',[0.9 0.9 0.9]); hold on
    
    %edges at top
    patch([CEPR_recessions(iiii,1),CEPR_recessions(iiii,2),...
           CEPR_recessions(iiii,2),CEPR_recessions(iiii,1)]',...
        [ylimits(2) ylimits(2) ylimits(2) ylimits(2)]',[0.9 0.9 0.9]); hold on
    
end

    plot([xlimits(1) xlimits(end)],[ylimits(1) ylimits(1)],'k')
    plot([xlimits(1) xlimits(end)],[ylimits(end) ylimits(end)],'k')