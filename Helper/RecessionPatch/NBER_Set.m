
F1             = 'dd/mm/yyyy';

% Events
NBER_recessions= ([ ...
    datenum( '01/09/1948',F1),datenum('01/09/1949',F1); 
    datenum( '01/03/1953',F1),datenum('01/03/1954',F1); 
    datenum( '01/06/1957',F1),datenum('01/03/1958',F1); 
    datenum( '01/03/1960',F1),datenum('01/01/1961',F1); 
    datenum( '01/09/1969',F1),datenum('01/09/1970',F1); 
    datenum( '01/11/1973',F1),datenum('01/03/1975',F1); 
    datenum( '01/02/1980',F1),datenum('01/07/1980',F1); 
    datenum( '01/08/1981',F1),datenum('01/11/1982',F1); 
    datenum( '01/08/1990',F1),datenum('01/03/1991',F1); 
    datenum( '01/04/2001',F1),datenum('01/11/2001',F1);
    datenum( '01/01/2008',F1),datenum('01/06/2009',F1)]);

ylimits = ylim; 
xlimits = xlim;

for iiii=1:1:size(NBER_recessions,1)

    %full grey area, without edges 
    patch([NBER_recessions(iiii,1),NBER_recessions(iiii,2),...
           NBER_recessions(iiii,2),NBER_recessions(iiii,1)]',...
        1*[ylimits(1) ylimits(1) ylimits(2) ylimits(2)]',[0.9 0.9 0.9],'EdgeColor','none'); hold on
    
    %edges at bottom
    patch([NBER_recessions(iiii,1),NBER_recessions(iiii,2),...
           NBER_recessions(iiii,2),NBER_recessions(iiii,1)]',...
        1*[ylimits(1) ylimits(1) ylimits(1) ylimits(1)]',[1. 1. 1.]); hold on
    
    %edges at top
    patch([NBER_recessions(iiii,1),NBER_recessions(iiii,2),...
           NBER_recessions(iiii,2),NBER_recessions(iiii,1)]',...
        1*[ylimits(2) ylimits(2) ylimits(2) ylimits(2)]',[1. 1. 1.]); hold on
    
end

    plot([xlimits(1) xlimits(end)],[ylimits(1) ylimits(1)],'k')
    plot([xlimits(1) xlimits(end)],[ylimits(end) ylimits(end)],'k')