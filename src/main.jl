# NOTE: This should be probably the main file
include("LoadData.jl")

data = load_data(joinpath("data","test_data.csv"))

names(data)
data.A
data." t"

using Plots
using LaTeXStrings
using .FaultGenerator
Plots.plot(data." t",data."A",label="test",title="test",xlabel=L"[s_n]",ylabel="y")
Plots.plot!(data." t",data." B",label="test2")

a = data."A"
Plots.plot(a[1:10], label="test",title="test",xlabel=L"[s_n]",ylabel="y")
offset = FaultGenerator.generate_offset(a[1:10], 1)
Plots.plot!(offset, label="offset")
drift = FaultGenerator.generate_drift(a[1:10], 1)