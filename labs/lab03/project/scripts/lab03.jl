using Pkg
using DrWatson
Pkg.activate("../project")
using DifferentialEquations
using Plots

script_name = "lab03"
mkpath(plotsdir(script_name))

# ## Параметры
x0 = 22222
y0 = 11111
u0 = [x0, y0]
tspan = (0.0, 60.0)

# ## Модель 1: регулярные vs регулярные
function f1!(du, u, p, t)
	x, y = u
	a,b,c,h = 0.22, 0.77, 0.66, 0.11
	du[1] = -a*x - b*y + sin(0.5t) + 2
	du[2] = -c*x - h*y + cos(0.5t) + 2
end

# ## Завершение боевых действий, когда одна из армий станет <= 0
function condition1(u, t, integrator)
	return min(u[1], u[2])
end
function affect1!(integrator)
	terminate!(integrator)
end

cb1 = ContinuousCallback(condition1, affect1!, affect_neg! = affect1!)

prob1 = ODEProblem(f1!, u0, tspan)
sol1 = solve(prob1, Tsit5(), callback = cb1, saveat = 0.1)

# ## Модель 2: регулярные vs партизаны
function f2!(du, u, p, t)
	x, y = u
	a,b,c,h = 0.31, 0.79, 0.59, 0.21
	du[1] = -a*x - b*y + sin(2.5t) + 2
	du[2] = -c*x - h*y + cos(2t) + 2
end

# ### Завершение боевых действий, когда одна из армий станет <= 0
function condition2(u, t, integrator)
	return min(u[1], u[2])
end
function affect2!(integrator)
	terminate!(integrator)
end

cb2 = ContinuousCallback(condition2, affect2!, affect_neg! = affect2!)

prob2 = ODEProblem(f2!, u0, tspan)
sol2 = solve(prob2, Tsit5(), callback = cb2, saveat = 0.1)

# ## Визуализация
p1 = plot(sol1.t, sol1[1, :], label = "Армия X", xlabel = "Время t", ylabel = "Численность", lw = 2, 
	title = "Модель1: регулярные vs регулярные")
plot!(p1, sol1.t, sol1[2, :], label = "Армия Y", lw = 2)

p2 = plot(sol2.t, sol2[1, :], label = "Армия X", xlabel = "Время t", ylabel = "Численность", lw = 2, 
	title = "Модель2: регулярные vs партизаны")
plot!(p2, sol2.t, sol2[2, :], label = "Армия Y", lw = 2)

final_plot = plot(p1, p2, layout = (1, 2), size = (1200, 500), margin = 8Plots.mm)
savefig(final_plot, plotsdir(script_name, "lanchesters_models.png"))

# ## Фазовые портреты
p3 = plot(sol1[1, :], sol1[2, :], label = "Модель 1", xlabel = "x", ylabel = "y", lw = 2, title = "Фазовые траектории")
plot!(p3, sol2[1, :], sol2[2, :], label = "Модель 2", lw = 2)
plot!(p3, [0, x0], [0, y0], linestyle = :dash, color = :grey, label = "Прямая x/y = const")
savefig(p3, plotsdir(script_name, "phase_portrait.png"))

# ## Итоги
println("Модель 1: x_final = ", sol1[1, end], ",y_final = ", sol1[2, end], "(t = ", sol1.t[end], ")")
println("Модель 2: x_final = ", sol2[1, end], ",y_final = ", sol2[2, end], "(t = ", sol2.t[end], ")")

if sol1[1, end] > sol1[2, end]
	println("Модель 1: Армия X победила")
else
	println("Модель 1: Армия Y победила")
end 

if sol2[1, end] > sol2[2, end]
	println("Модель 2: Армия X победила")
else
	println("Модель 2: Армия Y победила")
end 
