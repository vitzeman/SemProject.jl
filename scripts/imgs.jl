data = LoadData.load_data(joinpath("data","House_7 - Copy.csv"))
for (e, name) in enumerate(names(data))
    println(e, "-",name)
end
data_copy = copy(data)

selection = [8:24; 29; 31:47]
relevant = data_copy[:, selection]

relevant.T_MBR_AVG
plot(relevant.T_MBR_AVG, label="T_MBR_AVG", xlabel="Time[h]", ylabel="Temperature[°F]", linewidth=2)
plot(relevant.T_MBR_AVG[1:7*24], label="T_MBR_AVG", xlabel="Time[h]", ylabel="Temperature[°F]", linewidth=2)