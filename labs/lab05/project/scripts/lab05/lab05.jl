using Pkg
using DrWatson
Pkg.activate("../project")
using DifferentialEquations
using Plots

script_name = "lab05"
mkpath(plotsdir(script_name))

a = 0.32
b = 0.04
c = 0.42
d = 0.02

x0 = 9.0
y0 = 20.0
u0 = [x0, y0]
tspan = [0.0, 400.0]

function lotka!(du, u, p, t)
	x, y = u
	du[1] = -a*x + b*x*y
	du[2] = c*y - d*x*y
end

prob = ODEProblem(lotka!, u0, tspan)
sol = solve(prob, Tsit5(), saveat = 0.1)

xs = [u[1] for u in sol.u]
ys = [u[2] for u in sol.u]
ts = sol.t

x_star = c / d
y_star = a / b
println("Стационарное состояние x* = $x_star, y* = $y_star")

p1 = plot(ts, xs, label = "Хищники x(t)", xlabel = "Время t", ylabel = "Численность", lw = 2, title = "Динамика популяций")
plot!(p1, ts, ys, label = "Жертвы y(t)", lw = 2)
savefig(p1, plotsdir(script_name, "populations.png"))

p2 = plot(ys, xs, label = "Фазовая траектория", xlabel = "Жертвы y", ylabel = "Хищники x", lw = 2, title = "Фазовый портрет")
scatter!(p2, [y_star], [x_star], label = "Стационарная точка", markersize = 6, color = :red)
savefig(p2, plotsdir(script_name, "phase_portrait.png"))

starts = [(5.0, 15.0), (9.0, 20.0), (15.0, 25.0), (25.0,12.0)]
p3 = plot(xlabel = "Жертвы y", ylabel = "Хищники y", title = "Семейство фазовых траекторий", legend = :topright)

for (x0i, y0i) in starts
	probi = ODEProblem(lotka!, [x0i, y0i], tspan)
	soli = solve(probi, Tsit5(), saveat = 0.1)
	plot!(p3, [u[2] for u in sol.u], [u[1] for u in sol.u], lw = 1.8, label = "($x0i, $y0i)")
end
scatter!(p3, [y_star], [x_star], label = "Стационар", markersize = 6, color = :red)
savefig(p3, plotsdir(script_name, "phase_family.png"))

println("Готово")
