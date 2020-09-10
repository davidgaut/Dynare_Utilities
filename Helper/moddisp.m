% Displays the estimated parameters to print them on screen
% if comes from mh or opti source = 'mode' or 'mh' or 'modefile'
% if need for init or param use = 'init' or 'param'

function paramstr = moddisp(source,use,para)
format long
global parameter_names
global oo_ 
global xparam1 

% load oo_CMRoriginal
% oo_ = oo_cmr;

if strcmp(source,'modefile') 
    fprintf([char(parameter_names) , repmat('=',length(xparam1),1) , num2str(xparam1) , repmat(';',length(xparam1),1)])
return
end
%     if exist('parameter_names','var') && ~exist('oo_','var')

    if para == 1
    
       param_names = char(parameter_names);
       
       id = cell(size(parameter_names,1),1);
       id(:) = {'e_'};
        
       id_par = find(~strcmp(param_names(:,1:2),id));
       id_std = find(strcmp(param_names(:,1:2),id));
        
       par_param = parameter_names(id_par);
       par_value = xparam1(id_par);
        
       std_param = parameter_names(id_std);
       std_value = xparam1(id_std);
       
        for ii = 1 : size(id_par)
        oo_.posterior_mean.parameters(1).(par_param{ii}) = par_value(ii);
        end
       
        for ii = 1 : size(id_std)
        oo_.posterior_mean.shocks_std(1).(std_param{ii}) = std_value(ii);
        end
    
    
    end
    
        
if strcmp(source,'mode') 
    names_params = fieldnames(oo_.posterior_mode.parameters);
    vecval_par   = oo_.posterior_mode.parameters;
    
    if isfield(oo_.posterior_mode,'shocks_std')
        names_std    = fieldnames(oo_.posterior_mode.shocks_std);
        vecval_std   = oo_.posterior_mode.shocks_std;
    else
        names_std =[];
        vecval_std =[];
    end
else
    
    names_params = fieldnames(oo_.posterior_mean.parameters);
    names_std    = fieldnames(oo_.posterior_mean.shocks_std);
    vecval_par   = oo_.posterior_mean.parameters;
    vecval_std   = oo_.posterior_mean.shocks_std;
    
end

sizeS = '                  ' ;    
    disp(strcat('% Estimation Time: ',datestr(now())))
    disp('%--------------------------------------------------------------------------')
for ii = 1 : length(names_params)
    
    name = names_params(ii); val1 = length(char(name));
    
    value = vecval_par.(names_params{ii});
    
    size1 = sizeS(1 : end - val1);
    
    if strcmp(use, 'init');
    
    display([char(names_params(ii)), ',',size1 ,num2str(value,20) ';'])
    
    elseif strcmp(use, 'param');
	paramstr(ii+1,:) = cellstr([char(names_params(ii)), '=',size1 ,num2str(value,20) ';']);
    
	display([char(names_params(ii)), ' = ',size1 ,num2str(value,20) ';'])
        
    end
    
end

    
for ii = 1 : length(names_std)
    
    name = names_std(ii); val1 = length(char(name));
    
    value = vecval_std.(names_std{ii});
    
    size1 = sizeS(1 : end - val1);
    
    if strcmp(use, 'init');
    
    display(['stderr', '      ', char(names_std(ii)),',', size1  ,num2str(value,20) ';'])
    
    elseif strcmp(use, 'param');
	
	std = char(names_std(ii));
        
    display(['std',std(3:end),'_p = ', size1  ,num2str(value,20) ';'])
        
    end
    
    
    
end
    

paramstr(1,:)     = cellstr('if = 1');
paramstr(end+1,:) = cellstr('end');

