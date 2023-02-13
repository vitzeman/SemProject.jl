#TODO: Evaulate model on test set

using Flux, Plots
using BSON: @load, @save
using JLD

using .MyPlots

# Load model
save_loc = joinpath("data", "models", "2023-01-08T11_33_59.575-0.7182852.bson")
BSON.@load save_loc best_model
best_model
# Load test data
y_test = JLD.load(joinpath("data", "dataset0","test", "GT.jld"), "GT")
X_test = JLD.load(joinpath("data", "dataset0","test", "input.jld"), "X")'

# Convert to Float32
X_test = Float32.(X_test)
y_test = Int32.(y_test)
n_outputs = 4

# Predict in test step
Flux.testmode!(best_model)
Flux.reset!(best_model)
y_pred = best_model(X_test)
y_pred = onecold(y_pred)
y_test

# Visualize results
plot(y_pred, label="Predicted", linewidth = 2)
plot!(y_test, label="Ground truth", linewidth = 2)

# Compute accuracy
accuracy = sum(y_pred .== y_test) / length(y_test)
println("Accuracy = $accuracy")

function plot_confusion_matrix(Pred::Array{Int64,1}, GT::Array{Int64,1},num_lab::Int, labels::Array{String})
    conf_mtx = zeros(Int, num_lab, num_lab)
    for i in eachindex(Pred)
        conf_mtx[GT[i], Pred[i]] += 1
    end
    # print(conf_mtx)
    xla = ["A","B","C","D"]
    heatmap(conf_mtx,
        xticks=(1:4, labels),
        yticks=(1:4, labels),
        # title = "Confusion matrix",
        xlabel = "Predicted",
        ylabel = "Ground truth",
        color = :Blues_5,
        legend = false,
        # guide_position=:top,
        # xmirror=true,
        yflip=true
    )
    fontsize = 15
    ann = [(j,i, text(conf_mtx[i,j],fontsize, :black, :center))
                for i in 1:4 for j in 1:4]
    annotate!(ann, linecolor=:black)
end
# Plot confusion matrix
plot_confusion_matrix(Int64.(y_test), y_pred, 4, ["Faultless", "Drift","Offset", "Outlier"])