F1 = 'yyyyQQ';
CEPR_recessions = ([  datenum('1974Q3',F1),datenum('1975Q1',F1); 
    datenum('1980Q1',F1),datenum('1982Q3',F1);
    datenum('1992Q1',F1),datenum('1993Q3',F1);
    datenum('2008Q1',F1),datenum('2009Q2',F1);
    datenum('2011Q3',F1),datenum('2013Q1',F1);
    ]);

CEPR_recessions_NUM = ([  
    1974.50 , 1975.00;
    1980.00 , 1982.50;
    1992.00 , 1993.50;
    2008.00 , 2009.25;
    2011.50 , 2013.00;
    ]);

ylimits = ylim; 
xlimits = xlim;

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

xlim(xlimits)
ylim(ylimits)

    plot([xlimits(1) xlimits(end)],[ylimits(1) ylimits(1)],'k')
    plot([xlimits(1) xlimits(end)],[ylimits(end) ylimits(end)],'k')
    plot([xlimits(1) xlimits(1)]  ,[ylimits(1) ylimits(end)],'k')
    plot([xlimits(end) xlimits(end)],[ylimits(1) ylimits(end)],'k')