function TCVD = CVD(oo_, var_list_, M_, options_)

% Computation of the covariance contribution using dynare output
% Run CVD(oo_.dr, var_list_, M_, options_) after Dynare simulation

% Unconditional variance-covariance of states space 'vx', using Lyapunov
% Equation from initialized Kalman Filter: vx =  aa*vx*aa'+b2*b2'

% David Gauthier
% 23/05/2018


options_.qz_criterium = 1; 
nvar                  = length(var_list_);
var_list_             = cellstr(var_list_);

ivar=zeros(nvar,1);
for i=1:nvar
    i_tmp = strmatch(var_list_(i), deblank(M_.endo_names), 'exact');
    if isempty(i_tmp)
        error ('One of the variable specified does not exist');
    else
        ivar(i) = i_tmp;
    end
end

dr                  = oo_.dr;
exo_names_orig_ord  = M_.exo_names_orig_ord;
iky                 = dr.inv_order_var(ivar);

ghx = dr.ghx;
ghu = dr.ghu;
nx  = size(ghx,2);

nspred  = M_.nspred;
nstatic = M_.nstatic;
ipred   = nstatic+(1:nspred)';

kstate  = dr.kstate;
ikx     = [nstatic+1:nstatic+nspred];
k0      = kstate(find(kstate(:,2) <= M_.maximum_lag+1),:);
i0      = find(k0(:,2) == M_.maximum_lag+1);
ikx     = [nstatic+1:nstatic+nspred];
aa      = ghx(iky,:);
ghu1    = zeros(nx,M_.exo_nbr);
ghu1(i0,:) = ghu(ikx,:);

% state space representation for state variables only
[A,B] = kalman_transition_matrix(dr,ipred,1:nx,M_.exo_nbr);

            stationary_vars = (1:length(ivar))';

            SS(exo_names_orig_ord,exo_names_orig_ord)=M_.Sigma_e+1e-14*eye(M_.exo_nbr);
            cs = chol(SS)';
            
            b1(:,exo_names_orig_ord) = ghu1;
            b1 = b1*cs;
            bb(:,exo_names_orig_ord) = ghu(iky,:);
            b2(:,exo_names_orig_ord) = ghu(iky,:);
            b2 = b2*cs;
            
if options_.hp_filter == 0 && ~options_.bandpass.indicator
            vv2 = 0;
            vc2 = 0;
            for i=1:M_.exo_nbr
                % Var-CoVar for predetermined variables
                vx1 = lyapunov_symm(A,b1(:,i)*b1(:,i)',options_.lyapunov_fixed_point_tol,options_.qz_criterium,options_.lyapunov_complex_threshold,[],options_.debug);
                % Variance for each shock
                vx2 = abs(diag(aa*vx1*aa'+b2(:,i)*b2(:,i)'));
                VDi(stationary_vars,i) = vx2;    
                % For all shocks
                vv2 = vv2 + vx2;                
                i1 = find(abs((VDi(stationary_vars,i))) > 1e-12);
                sd = sqrt(VDi(i1,i));
                % Covariance for each shock
                vvv = (aa*vx1*aa'+b2(:,i)*b2(:,i)');       
                COVi(i1,i1,i) = vvv(i1,i1) ;
                vc2 = vc2 +  vvv; 
            end
            
         % Normalize over all variance   
       	  for i=1:M_.exo_nbr
            VD(stationary_vars,i) = VDi(stationary_vars,i)./vv2;
          end
          
          for i=1:M_.exo_nbr
            CVD(stationary_vars,stationary_vars,i) = COVi(stationary_vars,stationary_vars,i)./vc2;
          end
          
           
else 

    lambda = options_.hp_filter;
    ngrid  = options_.hp_ngrid;
    freqs  = 0 : ((2*pi)/ngrid) : (2*pi*(1 - .5/ngrid)); %[0,2*pi)
    tpos   = exp( sqrt(-1)*freqs);  %positive frequencies
    tneg   = exp(-sqrt(-1)*freqs);  %negative frequencies
 

   if options_.bandpass.indicator
        filter_gain = zeros(1,ngrid);
        lowest_periodicity=options_.bandpass.passband(2);
        highest_periodicity=options_.bandpass.passband(1);
        highest_periodicity=max(2,highest_periodicity); % restrict to upper bound of pi
        filter_gain(freqs>=2*pi/lowest_periodicity & freqs<=2*pi/highest_periodicity)=1;
        filter_gain(freqs<=-2*pi/lowest_periodicity+2*pi & freqs>=-2*pi/highest_periodicity+2*pi)=1;
    else
        filter_gain = 4*lambda*(1 - cos(freqs)).^2 ./ (1 + 4*lambda*(1 - cos(freqs)).^2);   %HP transfer function
    end
 

          SS(exo_names_orig_ord,exo_names_orig_ord) = M_.Sigma_e+1e-14*eye(M_.exo_nbr); %make sure Covariance matrix is positive definite
          cs = chol(SS)';
          SS = cs*cs';
          b1(:,exo_names_orig_ord) = ghu1;
          b2(:,exo_names_orig_ord) = ghu(iky,:);

    mathp_col = NaN(ngrid,length(ivar)^2);
    IA = eye(size(A,1));
    IE = eye(M_.exo_nbr);
    for ig = 1:ngrid
        if filter_gain(ig)==0
            f_hp = zeros(length(ivar),length(ivar));
        else
            f_omega  =(1/(2*pi))*([(IA-A*tneg(ig))\ghu1;IE]...
                                  *SS*[ghu1'/(IA-A'*tpos(ig)) IE]); % spectral density of state variables; top formula Uhlig (2001), p. 20 with N=0
            g_omega = [aa*tneg(ig) bb]*f_omega*[aa'*tpos(ig); bb']; % spectral density of selected variables; middle formula Uhlig (2001), p. 20; only middle block, i.e. y_t'
            f_hp = filter_gain(ig)^2*g_omega; % spectral density of selected filtered series; top formula Uhlig (2001), p. 21;
        end
        mathp_col(ig,:) = (f_hp(:))';    % store as matrix row for ifft
    end
    % Covariance of filtered series
    imathp_col = real(ifft(mathp_col))*(2*pi); % Inverse Fast Fourier Transformation; middle formula Uhlig (2001), p. 21;
        vc2 = 0;
        vv  = diag(reshape(imathp_col(1,:),nvar,nvar));
            for i=1:M_.exo_nbr
                mathp_col = NaN(ngrid,length(ivar)^2);
                SSi = cs(:,i)*cs(:,i)';
                for ig = 1:ngrid
                    if filter_gain(ig)==0
                        f_hp = zeros(length(ivar),length(ivar));
                    else
                        f_omega  =(1/(2*pi))*( [(IA-A*tneg(ig))\b1;IE]...
                                               *SSi*[b1'/(IA-A'*tpos(ig)) IE]); % spectral density of state variables; top formula Uhlig (2001), p. 20 with N=0
                        g_omega = [aa*tneg(ig) b2]*f_omega*[aa'*tpos(ig); b2']; % spectral density of selected variables; middle formula Uhlig (2001), p. 20; only middle block, i.e. y_t'
                        f_hp = filter_gain(ig)^2*g_omega; % spectral density of selected filtered series; top formula Uhlig (2001), p. 21;
                    end
                    mathp_col(ig,:) = (f_hp(:))';    % store as matrix row for ifft
                end
                imathp_col = real(ifft(mathp_col))*(2*pi);
                VD(:,i) = abs(diag(reshape(imathp_col(1,:),nvar,nvar)))./vv;
                i1 = find(abs((VD(stationary_vars,i))) > 1e-12);
                vvv = reshape(imathp_col(1,:),nvar,nvar);
                COVi(i1,i1,i) = vvv(i1,i1);
                vc2 = vc2 +  vvv;
            end
          
          for i=1:M_.exo_nbr
            CVD(stationary_vars,stationary_vars,i) = COVi(stationary_vars,stationary_vars,i)./vc2;
          end
          
end

%====================================================================================================================
%====================================================================================================================         
         

       for ii = 1 : size(COVi,3)        
            COVA(:,ii) = [diag(CVD(:,:,ii))];
       end
          
       if  ~(COVA == VD)
           error('Diag CVD different from VD')
       end
  
id1 = find(strcmp(var_list_,var_list_));
count   = 0;
cv_disp = NaN(M_.exo_nbr,1);
VV      = cell(1,1);
for  ii = 1 : length(id1)
    for jj = 1 : length(id1)
        cv1 = round(squeeze(CVD(ii,jj,1 : M_.exo_nbr) * 100),5);
        cvn = [char(var_list_(ii)),'-',  char(var_list_(jj))];
        if (sum(sum(ismember(cv_disp,cv1)) == M_.exo_nbr) == 0) && ~(ii == jj)
            count = count + 1;
        cv_disp(1 : M_.exo_nbr,count) = cv1;
        VV(count) = cellstr(cvn);
        end
    end
end

% turn for table
cv_disp = (cv_disp)';
 
% Check sums to 100
if sum(sum(cv_disp,2) - 100) > 1e-4; warning('CVD does not add up to 100'); end

format bank

TCVD = array2table(cv_disp,'RowNames',VV,'VariableNames',cellstr(M_.exo_names));
