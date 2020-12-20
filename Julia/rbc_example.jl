# Example of RBC model using Dynare with Julia (v0.6.4)
# David Gauthier
# 2019
# davd.gauthier@gmail.com

# Load packages
using  Dynare, PyPlot

# Create model instance
model =
@modfile begin

    # Declarations
    @var        y c k a h b
    @varexo     e u
    @parameters beta rho alpha delta theta psi tau

    # Model
    @model begin
        c*theta*h^(1+psi) = (1-alpha)*y
        k = beta*(((exp(b)*c)/(exp(b(+1))*c(+1)))*(exp(b(+1))*alpha*y(+1)+(1-delta)*k))
        y = exp(a)*(k(-1)^alpha)*(h^(1-alpha))
        k = exp(b)*(y-c)+(1-delta)*k(-1)
        a = rho*a(-1)+tau*b(-1) + e
        b = tau*a(-1)+rho*b(-1) + u

    end
end

# Check model construction
compute_model_info(model)  

# Model calibration
calibration = Dict(
         :alpha => 0.36,
         :rho   => 0.95,
         :tau   => 0.025,
         :beta  => 0.99,
         :delta => 0.025,
         :psi   => 0.0,
         :theta => 2.95
        )

# Steady state initial values
initval = Dict(
           :y => 1.08068253095672,
           :c => 0.80359242014163,
           :h => 0.29175631001732,
           :k => 11.08360443260358,
           :a => 0.0,
           :b => 0.0
           )

# Compute and print the steady state for the given calibration
ys = steady_state(model, calibration, initval)
print_steady_state(model, ys)

# Compute and print eigenvalues and first order decision rules
(gy, gu, eigs) = decision_rules(model, calibration, ys)
println("Eigenvalues: ", eigs)

# Functions
#-------------------------------------------------------------
function simul_dyn(ys,gy,gu,ex_,maximum_lag,m_zeta_back_mixed)
    # Run simulation of the model
    iter = size(ex_)[1];
    y_   = zeros(size(ys)[1],iter+maximum_lag);
    epsilon = gu*transpose(ex_);
    for i in 2:iter+maximum_lag
        yhat    = y_[:,i-1];
        y_[:,i] = gy*yhat[m_zeta_back_mixed] + epsilon[:,i-1];
    end
return y_
end

function irf_dyn(ys,gy,gu,e1,long,maximum_lag,m_zeta_back_mixed,n_exo)
    # Compute impulse response functions
    y1  = repmat(ys,1,long);
    ex2 = zeros(long,n_exo);
    ex2[1, :] = e1';
    y2 = simul_dyn(ys,gy,gu,ex2,maximum_lag,m_zeta_back_mixed);
    y  = y2[:,maximum_lag + 1:end];
    y = y * 100
    return y
end
#-------------------------------------------------------------

# Plot impulse response function
long        = 40;
cs          = 1e-2*eye(model.n_exo);
maximum_lag = 1

for ij in 1:2
y2    = irf_dyn(ys,gy,gu,cs[:,ij],long,maximum_lag,model.zeta_back_mixed,model.n_exo)

var   = [:y :c :k]
i_var = [x = find(repmat([var[ii]],length(model.endo)) .== model.endo) for ii in 1:length(var)];

fig, axs = subplots(3,2)
for ii in 1:length(var)
ax = axs[ii]
irfi = y2[i_var[ii],:]'[:]
ax[:plot](irfi)
ax[:plot]([0;long],[0;0],color = "red",linewidth=0.75)
ax[:set_title](var[i_var[ii]]); ax[:set_xlim](1,long-1)
if min(irfi...) >= 0.0; ax[:set_ylim](0,1.3*max(irfi...)); end
end
tight_layout()
show(fig)
end

