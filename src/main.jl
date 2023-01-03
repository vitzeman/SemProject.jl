# NOTE: This should be probably the main file
include("LoadData.jl")

data = load_data(joinpath("data","test_data.csv"))

names(data)
data.A
data."B"

