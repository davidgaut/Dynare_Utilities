function [Iy,varobs_idx] = frequency_estimation_init(dataset_info,M_,oo_,options_)

fprintf('Initialize frequency domain estimation, frequency is %d, %d.\n',options_.estim_frequency)

x     = dataset_info.rawdata';
T     = length(x);
t     = repmat((1 : T),size(x,1),1);
q     = @(omega) sum(x .* exp(-1i * omega * t),2);
Iy    = @(omega) 1 / (2*pi*T) * q(omega) * q(omega)'; 

varobs_idx = oo_.dr.inv_order_var(cellfun(@(n) find(strcmp(n,M_.endo_names)),options_.varobs));
end

