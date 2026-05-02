using DrWatson
@quickactivate "project"
using DifferentialEquations
using Plots
using DataFrames, CSV

N = 20000
I0 = 99
R0 = 5
S0 = N - I0 - R0
u0 = [S0, I0, R0]

α = 0.01
β = 0.02
tspan = (0.0, 200.0)

function epidemic_case2!(du, u, p, t)
    S, I, R = u
    du[1] = -α * S
    du[2] = α * S - β * I
    du[3] = β * I
end

prob2 = ODEProblem(epidemic_case2!, u0, tspan)
sol2 = solve(prob2, Tsit5(), saveat=0.1)

p2 = plot(sol2,
    title = "Эпидемия: случай I(t) > I* (Вариант 1)",
    xlabel = "Время t",
    ylabel = "Численность",
    label = ["S(t)" "I(t)" "R(t)"],
    lw = 2
)
display(p2)

mkpath(plotsdir("lab06"))
savefig(p2, plotsdir("lab06", "case2_epidemic.png"))

df2 = DataFrame(time = sol2.t, S = sol2[1,:], I = sol2[2,:], R = sol2[3,:])
CSV.write(datadir("epidemic_case2.csv"), df2)

println("Задача № 2 завершена. График в plots/lab06/case2_epidemic.png")
