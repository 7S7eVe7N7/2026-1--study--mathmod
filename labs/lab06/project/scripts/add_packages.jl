#!/usr/bin/env julia
using Pkg
Pkg.activate(".")

packages = [
    "DrWatson",
    "DifferentialEquations",
    "Plots",
    "DataFrames",
    "CSV",
    "Literate",
    "IJulia",
    "Quarto"
]

Pkg.add(packages)
