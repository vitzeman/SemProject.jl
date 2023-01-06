# TODO: Wirite a script to train the model

using Flux, Plots

using Flux: crossentropy, onecold, onehotbatch, params, train!

# 
model = Chain(
    Dense(1, 10, relu),
    Dense(10, 10, relu),
    Dense(10, 1),
    softmax)
    
loss(x,y) = Flux.Losses.mse(model(x), y)
# LoadData

# Training
loss_history = Float64[]
for epoch in 1:epochs
    # train model
    train!(loss, ps, [(X_train, y_train)], opt)
    # print report
    train_loss = loss(X_train, y_train)
    push!(loss_history, train_loss)
    println("Epoch = $epoch : Training Loss = $train_loss")
end

# Saving the module
