using Flux

my_model = Chain(
    LSTM(35 =>128),
    Dropout(0.5),
    Dense(128, 4),
    softmax)


my_model(X_train)