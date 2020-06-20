NBER_recessions=[1948.75, 1949.75;
    1953.25, 1954.25;
    1957.5,  1958.25;
    1960.25, 1961.0;
    1969.75, 1970.75;
    1973.75, 1975.0;
    1980.0, 1980.5;
    1981.5, 1982.75;
    1990.5, 1991.0;
    2001.0, 2001.75;
    2007.75, 2009+1/4];



xlimits=get(gca,'XLim'); %get axis 
min_idx=min(find(NBER_recessions(:,1)-xlimits(1)>=0)); % first recession for the sample (post 1988)
NBER_recessions=NBER_recessions(min_idx:end,:);
if NBER_recessions(1,1)<xlimits(1)
    NBER_recessions(1,1)=xlimits(1);
end
if NBER_recessions(end,end)>xlimits(2)
    NBER_recessions(end,end)=xlimits(2); % insert out of sample recessions
end


ylimits=get(gca,'YLim'); %get axis 
%put nber recessions as bars
for iiii=1:1:size(NBER_recessions,1),

    %full grey area, without edges 
    patch([NBER_recessions(iiii,1),NBER_recessions(iiii,2),...
           NBER_recessions(iiii,2),NBER_recessions(iiii,1)]',...
        [ylimits(1) ylimits(1) ylimits(2) ylimits(2)]',[0.9 0.9 0.9],'EdgeColor','none'); hold on
    
    %edges at bottom
    patch([NBER_recessions(iiii,1),NBER_recessions(iiii,2),...
           NBER_recessions(iiii,2),NBER_recessions(iiii,1)]',...
        [ylimits(1) ylimits(1) ylimits(1) ylimits(1)]',[0.9 0.9 0.9]); hold on
    
    %edges at top
    patch([NBER_recessions(iiii,1),NBER_recessions(iiii,2),...
           NBER_recessions(iiii,2),NBER_recessions(iiii,1)]',...
        [ylimits(2) ylimits(2) ylimits(2) ylimits(2)]',[0.9 0.9 0.9]); hold on
    
    %edges left if first recession date is equal to initial date 
    if NBER_recessions(1)<=xlimits(1) && iiii==1,
    patch([xlimits(1),xlimits(1),xlimits(1),xlimits(1)]',...
        [ylimits(1) ylimits(1) ylimits(2) ylimits(2)]',[0.9 0.9 0.9]); hold on
    end

    %edges right if last recession date is equal to final date 
    if NBER_recessions(end)>=xlimits(2) && iiii==size(NBER_recessions,1),
    patch([xlimits(2),xlimits(2),xlimits(2),xlimits(2)]',...
        [ylimits(1) ylimits(1) ylimits(2) ylimits(2)]',[0.9 0.9 0.9]); hold on
    end
end
