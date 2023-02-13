using Flux
using Flux: crossentropy, onecold, onehotbatch, params, train!

# l = LSTM(3 => 5)
# l(rand(Float32,3,10))
X = rand(Float32, 35, 10)
gt = onehotbatch(rand(1:4, 10), 1:4)
model = Chain(
    LSTM(35 =>128),
    Dropout(0.5),
    Dense(128, 4),
    softmax
    )
l_fce(x, y) = Flux.Losses.crossentropy(model(x), y)
epochs = 100
for epoch in 1:epochs
    train!(l_fce, params(model), [(X, gt)], ADAM(0.001))
    # print report
    train_loss = l_fce(X, gt)
    push!(loss_history, train_loss)
    println("Epoch = $epoch : Training Loss = $train_loss")
end
z = rand(Float32, 35, 1)
model(z)