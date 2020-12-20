function [ys,MsD] = risky_steadystate(ys,M_,options_,nfun)
% David Gauthier - 2019 / Jan
% Risky steady state (EL - De Groot 2013)
%-----------------------------------

%--------------------------------------------------------------------------------
% Moments must enter equations positively on the right hand side:
% y + x + M = 0;
% As in Dynare residuals for equation x = y + M is computed as r = x - (y + M).
%--------------------------------------------------------------------------------

fun = str2func(nfun); if options_.order ~= 2; warning('Dynare approx order should be 2.'); end

% Provide Good Starting Values
improv = 1; 
% Possible to reduce the problem dimension by specifying non-zero moments
% else set:
options_.rss_id = linspace(1,M_.endo_nbr,M_.endo_nbr);
MsD_First = zeros(M_.endo_nbr,1);
while improv > 1e-3
MsD_First = moment_compute(ys,M_,options_);
ys_upd    = fun(MsD_First(options_.rss_id),ys,M_);

improv    = norm(ys - ys_upd);
ys        = ys_upd;
end

% Solve
MsD = csolve(@tbn_fun,MsD_First(options_.rss_id),[],1e-14,5,ys,M_,options_,fun);
ys  = fun(MsD,ys,M_,options_);
end


function [tbn,ys_upd,MsD] = tbn_fun(MsD,ys,M_,options_,fun)
    
    tbn = NaN(size(MsD,1),size(MsD,2));
    % Search Moment Convergence
    for i=1:size(MsD,2)
    MsD_try = MsD(:,i); 
    ys_upd  = fun(MsD_try,ys,M_,options_);

        try % Compute moments with last risky ss
            MsD_upd = moment_compute(ys_upd,M_,options_);
        catch
            tbn = inf(size(MsD,1),size(MsD,2)); 
            return
        end
        % Convergence of moments (solving eps_new = eps + Mom)
        tbn(:,i)  =  (MsD_try - MsD_upd(options_.rss_id));
    end

end

