function ts = synchnan(ts1,ts2)

[tmp1,~] = synchronize(ts1,ts2,'intersection');

for ij = 1 : size(ts1.data,2)
val((~ismember(ts2.time,tmp1.time))) = NaN;
val((ismember(ts2.time,tmp1.time)))  = tmp1.data(:,ij);
valfin(:,ij) = val(:);
end
ts = timeseries(valfin,ts2.time);
ts.Name = ts1.Name;
