function fig = plot_timetable(TT)

% [nbplt,nr,nc,lr,lc,nstar] = pltorg(size(TT,2));


ll = ceil(sqrt(size(TT,2)));
rr = ceil(sqrt(size(TT,2)));

fig = figure('Position',[108         118        1830         770]);
for nn = 1 : size(TT,2)
subplot(ll,rr,nn)
plot(datenum(TT.Time),TT{:,nn},'LineWidth',.5);
NBER_Set
plot(datenum(TT.Time),TT{:,nn},'LineWidth',.5);

datetick
axis tight

xlabel('Time');
title(TT.Properties.VariableNames{nn},'FontWeight','Normal');
end


