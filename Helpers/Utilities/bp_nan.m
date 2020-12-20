
function treated_series = bp_nan(series) 

treated_series = NaN(size(series,1),size(series,2));

for ii = 1:size(series,2)
    
    treated_series(~isnan(series(:,ii)),ii) = bp(series(~isnan(series(:,ii)),ii),6,32);
    
end
