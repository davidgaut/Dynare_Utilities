function VD_table = VD_Display(var_list_)
% David Gauthier 
% Display variance decomposition sorted for the first variable in var_list_
% Bank of England
% 12 - 2019

global M_ oo_ options_

format bank

options_.nograph = 1; options_.noprint = 1; options_.periods = 0;
[info, oo_, options_, M_] = stoch_simul(M_, options_, oo_, M_.endo_names);
print_info(info,~options_.noprint, options_);

% names_var  = M_.endo_names;
names_var  = var_list_;
id_var     = varlist_indices(var_list_,M_.endo_names);
VD         = oo_.variance_decomposition;
[~,order]  = sort(oo_.variance_decomposition(id_var(1),:),'descend');
VD         = VD(id_var,order);

VD_table = array2table(VD,'RowNames',names_var,'VariableNames',M_.exo_names(order));
VD_table.Properties.VariableNames = M_.exo_names(order);