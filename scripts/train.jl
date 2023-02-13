# TODO: Wirite a script to train the model

using Flux, Plots
using JLD
using BSON: @save
using Dates
using Random
using BSON
using Flux: crossentropy, onecold, onehotbatch, params, train!

# load_data
y_train = JLD.load(joinpath("data", "dataset0","train", "GT.jld"), "GT")
X_train = JLD.load(joinpath("data", "dataset0","train", "input.jld"), "X")'
y_train = onehotbatch(y_train, 1:4)
# Convert to Float32
# unique(y_train)
X_train = Float32.(X_train)
y_train = Int32.(y_train)
n_outputs = 4
# TODO: Create a LSTM model for X_train
# add some activation function maybe try other more complicaterd modules for classification
model = Chain(
    LSTM(35 =>128),
    Dropout(0.5),
    Dense(128, 4),
    softmax)

loss(x,y) = Flux.Losses.crossentropy(model(x), y)
ps = params(model)
lr = 0.0001
opt = ADAM(lr)

# Training
loss_history = Float64[]
epochs = 50000
best_tl = Inf
best_model = deepcopy(model)
for epoch in 1:epochs
    global best_tl, best_model
    train!(loss, ps, [(X_train, y_train)], opt)
    # print report
    train_loss = loss(X_train, y_train)
    if train_loss < best_tl
        best_tl = train_loss
        best_model = deepcopy(model)
    end
    push!(loss_history, train_loss)
    println("Epoch = $epoch : Training Loss = $train_loss")
end

# TODO: onecold(y_pred) # Convert to onehot
# and visualize the results

pl = plot(loss_history, xlabel="Epoch[-]",
    ylabel="Loss[-]",
    label="",
    title="Training loss history",
    linewidth = 2
)
# Saving the model
# TODO: save the model in a file using BSON
# In future make somethin with joinpath
t_now = replace(string(now()), ":" => "_")
save_loc = joinpath("data", "models", string(t_now, "-", best_tl, ".bson"))
BSON.@save save_loc best_model

BSON.@load save_loc best_model
Flux.reset!(best_model)
preds = onecold(best_model(X_train))
plot(preds, label="Predicted")
plot!(onecold(y_train), label="Ground truth")
plot!(onecold(best_model(X_train)), label="Predicted")