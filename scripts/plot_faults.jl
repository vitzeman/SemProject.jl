using Plots
using LaTeXStrings
using .FaultGenerator
using .LoadData
using .Conversion

TIME_AXIS_CZ = "Čas [h]"
TEMP_AXIS_CZ = "Teplota [°C]"
TEMP_AXIS_EN = "Temperature [°C]"
TIME_AXIS_EN = "Time [h]"
TITLE_CZ = "Generování chyb"
TITLE_EN = "Fault generation"
XLABEL_CZ = "Čas [h]"
XLABEL_EN = "Time [h]"
YLABEL_CZ = "Teplota [K]"
YLABEL_EN = "Temperature [K]"
OFFSET_CZ = "Ofset"
OFFSET_EN = "Offset"
DRIFT_CZ = "Drift"
DRIFT_EN = "Drift"
OUTLIERS_CZ = "Vychýlené hodnoty"
OUTLIERS_EN = "Outliers"
ORIG_CZ = "Původní data"
ORIG_EN = "Original data"

language = "en"
if language == "cz"
    TIME_AXIS = TIME_AXIS_CZ
    TEMP_AXIS = TEMP_AXIS_CZ
    TITLE = TITLE_CZ
    XLABEL = XLABEL_CZ
    YLABEL = YLABEL_CZ
    OFFSET = OFFSET_CZ
    DRIFT = DRIFT_CZ
    OUTLIERS = OUTLIERS_CZ
    ORIG = ORIG_CZ
elseif language == "en"
    TIME_AXIS = TIME_AXIS_EN
    TEMP_AXIS = TEMP_AXIS_EN
    TITLE = TITLE_EN
    XLABEL = XLABEL_EN
    YLABEL = YLABEL_EN
    OFFSET = OFFSET_EN
    DRIFT = DRIFT_EN
    OUTLIERS = OUTLIERS_EN
    ORIG = ORIG_EN
else
    println("Language not supported")
end


data = LoadData.load_data(joinpath("data","House_7 - Copy.csv"))
for name in names(data)
    println(name)
end

t_mbr = data.T_MBR_AVG
t_mbr_sel = t_mbr[1:24*7]
t_mbr_sel = Conversion.F2K(t_mbr_sel)
offset = FaultGenerator.generate_offset(t_mbr_sel, [24],[48],[0.5])
Plots.plot(offset, label=OFFSET, color=:red,linewidth = 2, legend=:bottomright)
drift = FaultGenerator.generate_drift(t_mbr_sel, [60],[84],[1/(2*24)])
# Plots.vline!([24,48,60,84],linewidth = 1, linestyle=:dash, color=:black)
# for i in 60:84
#     println(t_mbr_sel[i],"\t",drift[i])
# end
Plots.plot!(drift, label=DRIFT, color=:blue,linewidth = 2)
outliers = FaultGenerator.generate_outliers(t_mbr_sel, [100, 115, 125], [102, 115, 125], Conversion.F2K([66, 70.5, 66]))
Plots.plot!(outliers, label=OUTLIERS, color=:green,linewidth = 2)
Plots.plot!(t_mbr_sel, label=ORIG,xlabel=XLABEL,ylabel=YLABEL, color=:black,linewidth = 2, legend =false)

h_line = fill(1.,length(t_mbr_sel))
line_offset = FaultGenerator.generate_offset(h_line, [24],[48],[0.5])
Plots.plot(line_offset, label=OFFSET, color=:red, linestyle=:dash,linewidth = 2)
line_drift = FaultGenerator.generate_drift(h_line, [60],[84],[1/(2*24)])
Plots.plot!(line_drift, label=DRIFT, color=:blue, linestyle=:dash,linewidth = 2)
line_outliers = FaultGenerator.generate_outliers(h_line, [100, 115, 125], [102, 115, 125], [0.5, 1.5, 0.5])
Plots.plot!(line_outliers, label=OUTLIERS, color=:green, linestyle=:dash,linewidth = 2, legend=:bottomleft)
Plots.plot!(h_line, label=ORIG, color=:black,linewidth = 2)

# Plots.title!(TITLE)
# Plots.plot!([24:48],offset[24:48], label="offset", color=:red, linestyle=:dash,linewidth = 2)
