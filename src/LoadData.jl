module LoadData

import CSV
import DataFrames
import Plots


"""
    load_data(path2file::String)

Loads data from file specified by path2file. Returns DataFrame with data.

# Arguments
- `path2file::String`: path to file with data
"""
function load_data(path2file::String)
    data = CSV.read(path2file, DataFrames.DataFrame)
    return data
end

export load_data
# end # module
# DEL: JUST FOR testing
# data = CSV.read(joinpath("data","House_7.csv"), DataFrames.DataFrame)
# print(data)

# num_data = CSV.read(joinpath("data","test_data.csv"),DataFrames.DataFrame)
# print(num_data[1:2,:])
# # Takže tohle jde

# Plots.plot(num_data[1:10,4],num_data[1:10,1],label="test",title="test",xlabel="t",ylabel="y")
# Plots.plot!(num_data[1:10,4],num_data[1:10,2],label="test2")
end