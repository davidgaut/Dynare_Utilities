

function data_compare(p1,p2)

% Plot two datafiles with the same variables
% Each set must contain a 'dates' array in yyyyQQ form

x1=load(p1);
x2=load(p2);

Names = fieldnames(x1);

for ii = 1:length(Names)
    subplot(3,4,ii)
    plot(datestr(x1.dates,'yyyyQQ'),x1.(Names{ii}));hold on
    plot(datestr(x2.dates,'yyyyQQ'),x2.(Names{ii}))
    title(Names{ii})
end