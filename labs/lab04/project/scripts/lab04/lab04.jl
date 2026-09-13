using Pkg
using DrWatson
Pkg.activate("../project")
using DifferentialEquations
using Plots

script_name = "lab04"
mkpath(plotsdir(script_name))

x0 = 0.2
y0 = -0.3
u0 = [x0, y0]
tspan = (0.0, 58.0)

function f1!(du, u, p, t)
	x, y = u
	omega2 = 17.0
	du[1] = y
	du[2] = -omega2 * x
end

prob1 = ODEProblem(f1!, u0, tspan)
sol1 = solve(prob1, Tsit5(), saveat = 0.05)

function f2!(du, u, p, t)
	x, y = u
	omega2 = 23.0
	gamma2 = 22.0
	du[1] = y
	du[2] = -omega2 * x - gamma2 * y
end

prob2 = ODEProblem(f2!, u0, tspan)
sol2 = solve(prob2, Tsit5(), saveat = 0.05)

function f3!(du, u, p, t)
	x, y = u
	omega2 = 8.0
	gamma2 = 5.0
	du[1] = y
	du[2] = -omega2 * x - gamma2 * y + 0.25 * sin(8t)
end

prob3 = ODEProblem(f3!, u0, tspan)
sol3 = solve(prob3, Tsit5(), saveat = 0.05)

p1 = plot(sol1.t, sol1[1, :], label = "x(t)", xlabel = "Время t", ylabel = "x", lw = 2,
	title = "Случай 1: свободные колебания без затухания")
p2 = plot(sol2.t, sol2[1, :], label = "x(t)", xlabel = "Время t", ylabel = "x", lw = 2,
	title = "Случай 2: затухающие колебания")
p3 = plot(sol3.t, sol3[1, :], label = "x(t)", xlabel = "Время t", ylabel = "x", lw = 2,
	title = "Случай 3: вынужденные колебания с затуханием")

solutions_plot = plot(p1, p2, p3, layout = (3, 1), size = (900, 900), margin = 6Plots.mm)
savefig(solutions_plot, plotsdir(script_name, "solutions.png"))

xs1 = [u[1] for u in sol1.u]
ys1 = [u[2] for u in sol1.u]
xs2 = [u[1] for u in sol2.u]
ys2 = [u[2] for u in sol2.u]
xs3 = [u[1] for u in sol3.u]
ys3 = [u[2] for u in sol3.u]

fp1 = plot(xs1, ys1,
           label = "Случай 1", xlabel = "x", ylabel = "y = dx/dt",
           lw = 2, title = "Фазовый портрет: без затухания",
           aspect_ratio = 1)
fp2 = plot(xs2, ys2,
           label = "Случай 2", xlabel = "x", ylabel = "y = dx/dt",
           lw = 2, title = "Фазовый портрет: с затуханием",
           aspect_ratio = 1)
fp3 = plot(xs3, ys3,
           label = "Случай 3", xlabel = "x", ylabel = "y = dx/dt",
           lw = 2, title = "Фазовый портрет: с внешней силой",
           aspect_ratio = 1)

phase_plot = plot(fp1, fp2, fp3, layout = (3, 1), size = (900, 900),
                  margin = 6Plots.mm)
savefig(phase_plot, plotsdir(script_name, "phase_portraits.png"))

print("Готово")
