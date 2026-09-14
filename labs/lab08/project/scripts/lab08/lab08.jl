using Pkg
using DrWatson
Pkg.activate("../project")
using DifferentialEquations
using Plots

script_name = "lab08"
mkpath(plotsdir(script_name))

p_cr = 40.0
N    = 43.0
q    = 1.0
τ1   = 20.0
τ2   = 14.0
p1   = 10.7
p2   = 19.1

M01 = 2.6
M02 = 6.2
u0  = [M01, M02]

a1 = p_cr / (τ1^2 * p1^2 * N * q)
a2 = p_cr / (τ2^2 * p2^2 * N * q)
b  = p_cr / (τ1^2 * p1^2 * τ2^2 * p2^2 * N * q)
c1 = (p_cr - p1) / (τ1 * p1)
c2 = (p_cr - p2) / (τ2 * p2)

println("Коэффициенты:")
println("a1 = ", a1)
println("a2 = ", a2)
println("b  = ", b)
println("c1 = ", c1)
println("c2 = ", c2)


tspan = (0.0, 30.0)

function f1!(du, u, p, t)
    M1, M2 = u
    du[1] = (c1/c1)*M1 - (a1/c1)*M1^2 - (b/c1)*M1*M2
    du[2] = (c2/c1)*M2 - (a2/c1)*M2^2 - (b/c1)*M1*M2
end

prob1 = ODEProblem(f1!, u0, tspan)
sol1  = solve(prob1, Tsit5(), saveat = 0.05)

M1_case1 = sol1[1, :]
M2_case1 = sol1[2, :]

function f2!(du, u, p, t)
    M1, M2 = u
    du[1] = (c1/c1)*M1 - (a1/c1)*M1^2 - (b/c1 + 0.00026)*M1*M2
    du[2] = (c2/c1)*M2 - (a2/c1)*M2^2 - (b/c1)*M1*M2
end

prob2 = ODEProblem(f2!, u0, tspan)
sol2  = solve(prob2, Tsit5(), saveat = 0.05)

M1_case2 = sol2[1, :]
M2_case2 = sol2[2, :]

p1_plot = plot(sol1.t, M1_case1,
               label = "Фирма 1", xlabel = "θ", ylabel = "M",
               lw = 2, title = "Случай 1: экономическая конкуренция",
               color = :blue)
plot!(p1_plot, sol1.t, M2_case1, label = "Фирма 2", lw = 2, color = :green)
savefig(p1_plot, plotsdir(script_name, "case1.png"))


p2_plot = plot(sol2.t, M1_case2,
               label = "Фирма 1", xlabel = "θ", ylabel = "M",
               lw = 2, title = "Случай 2: с психологическим фактором",
               color = :blue)
plot!(p2_plot, sol2.t, M2_case2, label = "Фирма 2", lw = 2, color = :green)
savefig(p2_plot, plotsdir(script_name, "case2.png"))


p_combined = plot(p1_plot, p2_plot, layout = (1, 2), size = (1200, 500),
                  margin = 8Plots.mm)
savefig(p_combined, plotsdir(script_name, "competition.png"))

denom = a1*a2 - b^2
M1_star = (c1*a2 - b*c2) / denom
M2_star = (a1*c2 - b*c1) / denom

println("\n=== Стационарное состояние (случай 1) ===")
println("M1* = ", M1_star)
println("M2* = ", M2_star)
