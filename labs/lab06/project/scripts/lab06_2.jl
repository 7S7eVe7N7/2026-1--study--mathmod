# # Эпидемия при I(0) > I*
#
# Сценарий: начальное число инфицированных превышает критический порог I*.
# Инфекция свободно распространяется.
#
# Параметры варианта 1: N = 20000, I(0)=99, R(0)=5, α=0.01, β=0.02.

using Pkg
using DrWatson
Pkg.activate("../project")
using DifferentialEquations
using Plots
gr(fmt = :png)
default(fmt = :png, size = (800, 500))
using DataFrames, CSV

# ## Параметры модели
N = 20000
I0 = 99
R0 = 5
S0 = N - I0 - R0
u0 = [S0, I0, R0]

α = 0.01
β = 0.02
tspan = (0.0, 200.0)

# ## Система дифференциальных уравнений для случая I > I*
# dS/dt = -α·S, dI/dt = α·S - β·I, dR/dt = β·I
function epidemic_case2!(du, u, p, t)
    S, I, R = u
    du[1] = -α * S
    du[2] = α * S - β * I
    du[3] = β * I
end

# ## Численное решение
prob2 = ODEProblem(epidemic_case2!, u0, tspan)
sol2 = solve(prob2, Tsit5(), saveat=0.1)

# ## Визуализация
p2 = plot(sol2,
    title = "Эпидемия: случай I(t) > I* (Вариант 1)",
    xlabel = "Время t",
    ylabel = "Численность",
    label = ["S(t)" "I(t)" "R(t)"],
    lw = 2
)
display(p2)

# ## Сохранение результатов
mkpath(plotsdir("lab06"))
savefig(p2, plotsdir("lab06", "case2_epidemic.png"))

df2 = DataFrame(time = sol2.t, S = sol2[1,:], I = sol2[2,:], R = sol2[3,:])
CSV.write(datadir("epidemic_case2.csv"), df2)

println("Задача № 2 завершена. График в plots/lab06/case2_epidemic.png")
