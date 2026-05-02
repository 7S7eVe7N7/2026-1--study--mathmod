# # Эпидемия при I(0) ≤ I*
#
# Сценарий: начальное число инфицированных ниже критического порога I*.
# Инфицированные изолированы и не заражают здоровых. Происходит только
# выздоровление.
#
# Параметры варианта 1: N = 20000, I(0)=99, R(0)=5, α=0.01, β=0.02.

using Pkg
using DrWatson
Pkg.activate("../project")
using DifferentialEquations
using Plots
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

# ## Система дифференциальных уравнений для случая I ≤ I*
# dS/dt = 0, dI/dt = -β·I, dR/dt = β·I
function epidemic_case1!(du, u, p, t)
    S, I, R = u
    du[1] = 0.0
    du[2] = -β * I
    du[3] = β * I
end

# ## Численное решение
prob1 = ODEProblem(epidemic_case1!, u0, tspan)
sol1 = solve(prob1, Tsit5(), saveat=0.1)

# ## Визуализация
p1 = plot(sol1,
    title = "Эпидемия: случай I(t) ≤ I* (Вариант 1)",
    xlabel = "Время t",
    ylabel = "Численность",
    label = ["S(t)" "I(t)" "R(t)"],
    lw = 2
)
display(p1)

# ## Сохранение результатов
mkpath(plotsdir("lab06"))
savefig(p1, plotsdir("lab06", "case1_epidemic.png"))

# Сохранение данных в CSV
df1 = DataFrame(time = sol1.t, S = sol1[1,:], I = sol1[2,:], R = sol1[3,:])
CSV.write(datadir("epidemic_case1.csv"), df1)

println("Задача № 1 завершена. График в plots/lab06/case1_epidemic.png")
