% https://eabcn.org/dc/chronology-euro-area-business-cycles

F1 = 'yyyyQQ';
CEPR_recessions = ([ datenum('1974Q4',F1),datenum('1975Q1',F1); 
                     datenum('1980Q2',F1),datenum('1982Q3',F1);
                     datenum('1992Q2',F1),datenum('1993Q3',F1);
                     datenum('2008Q2',F1),datenum('2009Q2',F1);
                     datenum('2011Q4',F1),datenum('2013Q1',F1);
                  ]);

CEPR_recessions_NUM = ([  
    1974.75 , 1975.00;
    1980.25 , 1982.50;
    1992.25 , 1993.50;
    2008.25 , 2009.25;
    2011.75 , 2013.00;
    ]);

ylimits = ylim; 
xlimits = xlim;

shade = [0.9 0.9 0.9];
% shade = 0.5;

for iiii=1:1:size(CEPR_recessions,1)

    %full grey area, without edges 
    patch([CEPR_recessions(iiii,1),CEPR_recessions(iiii,2),...
           CEPR_recessions(iiii,2),CEPR_recessions(iiii,1)]',...
        [ylimits(1) ylimits(1) ylimits(2) ylimits(2)]',shade,'EdgeColor','none'); hold on
    
    
    %edges at bottom
    patch([CEPR_recessions(iiii,1),CEPR_recessions(iiii,2),...
           CEPR_recessions(iiii,2),CEPR_recessions(iiii,1)]',...
        [ylimits(1) ylimits(1) ylimits(1) ylimits(1)]',shade); hold on
    
    %edges at top
    patch([CEPR_recessions(iiii,1),CEPR_recessions(iiii,2),...
           CEPR_recessions(iiii,2),CEPR_recessions(iiii,1)]',...
        [ylimits(2) ylimits(2) ylimits(2) ylimits(2)]',shade); hold on
    
end

xlim(xlimits)
ylim(ylimits)

    plot([xlimits(1) xlimits(end)],[ylimits(1) ylimits(1)],'k')
    plot([xlimits(1) xlimits(end)],[ylimits(end) ylimits(end)],'k')
    plot([xlimits(1) xlimits(1)]  ,[ylimits(1) ylimits(end)],'k')
    plot([xlimits(end) xlimits(end)],[ylimits(1) ylimits(end)],'k')