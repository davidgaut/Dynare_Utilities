

function data_compare(p1,p2)

% Plot two datafiles with the same variables
% Each set must contain a 'dates' array in yyyyQQ form

x1=load(p1);
x2=load(p2);

Names = fieldnames(x1);

% if istype(x1.dates)
date_str = 1;
for ii = 1:length(Names)
    subplot(5,5,ii)
    if ~strcmp(Names{ii},'dates')
    if date_str
        plot(datenum(x1.dates,'yyyyQQ'),x1.(Names{ii}));hold on
        plot(datenum(x2.dates,'yyyyQQ'),x2.(Names{ii}),'LineStyle','-.')
    else
%     plot((x1.dates),x1.(Names{ii}));hold on
%     plot((x2.dates),x2.(Names{ii}))
    end
    title(Names{ii})
end
end