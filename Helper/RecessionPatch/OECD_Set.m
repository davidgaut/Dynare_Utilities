% UK-OECD recessions dates (ref: Fred GBRRECDM)
%-----------------------------------------------

OECD_recessions = [
      714292      715541
      716272      716971
      717580      718432
      719010      719590
      720714      721597
      722966      723667
      724550      724854
      726438      727746
      728537      729237
      729511      730271
      731002      731398
      731885      732282
      733407      733955
      735934      736542];
      
ylimits = ylim; 
xlimits = xlim;

for iiii=1:1:size(OECD_recessions,1)

    %full grey area, without edges 
    patch([OECD_recessions(iiii,1),OECD_recessions(iiii,2),...
           OECD_recessions(iiii,2),OECD_recessions(iiii,1)]',...
        1*[ylimits(1) ylimits(1) ylimits(2) ylimits(2)]',[0.9 0.9 0.9],'EdgeColor','none'); hold on
    
    %edges at bottom
    patch([OECD_recessions(iiii,1),OECD_recessions(iiii,2),...
           OECD_recessions(iiii,2),OECD_recessions(iiii,1)]',...
        1*[ylimits(1) ylimits(1) ylimits(1) ylimits(1)]',[1. 1. 1.]); hold on
    
    %edges at top
    patch([OECD_recessions(iiii,1),OECD_recessions(iiii,2),...
           OECD_recessions(iiii,2),OECD_recessions(iiii,1)]',...
        1*[ylimits(2) ylimits(2) ylimits(2) ylimits(2)]',[1. 1. 1.]); hold on
    
end

plot([xlimits(1) xlimits(end)],[ylimits(1) ylimits(1)],'k')
plot([xlimits(1) xlimits(end)],[ylimits(end) ylimits(end)],'k')