using Random
using Plots
using Distributions
using JLD

using .FaultGenerator
using .LoadData
using .Conversion
using .MyPlots

data = LoadData.load_data(joinpath("data","House_7 - Copy.csv"))
for (e, name) in enumerate(names(data))
    println(e, "-",name)
end

data_copy = copy(data)


# TODO remove lines 12267-12277
# Select colums 8:24, 29, 31:47  ie relevant data
selection = [8:24; 29; 31:47]
relevant = data_copy[:, selection]
# Convert to Kelvin
for i in 1:18
    relevant[:,i] = Conversion.F2K(relevant[:,i])
end

# convert to matrix
relevant = Matrix(relevant)


for (e,i) in enumerate([22,27]) # c onvert String to Float64
    z= 0
    for j in eachindex(relevant[:,i])
        try
            relevant[j,i] = parse(Float64, relevant[j,i])
            z += 1
        catch
            relevant[j,i] = 0.0
        end
    end
    println("Number of converted values: ", z)
end
relevant[:,22]
relevant[:,27]

for i in [25,28]
    global relevant
    for j in eachindex(relevant[:,i])
        global relevant
        if typeof(relevant[j,i]) == Missing
            println("not float", typeof(relevant[j,i]))
            relevant[j,i] = 0.0
        end
    end
    # replace!(relevant[:,i], "missing" => 0.0)
end
relevant[:,25]
relevant[:,28]


# Convert to Float64
println(size(relevant))
relevant = convert(Matrix{Float64}, relevant)
energies = copy(relevant[:, 19:34])
sort(unique(energies[:,1]))
# replace -6999.0 with 0.0
energies[energies .== -6999.0] .= 0.0
energies
relevant[:,19:34] = energies
# pocad dobrý 


# remove lines 12267-12277 due to certain faulty data
train = copy(relevant[1:12266,:])
test = copy(relevant[12278:end,:])

t_mbr_cus_train = copy(train[:,13])
t_mbr_cus_test = copy(test[:,13])

Plots.plot(t_mbr_cus_train, label="original", xlabel="t [h]", ylabel="T [K]")
# Plots.plot!(t_mbr_cus_test, label="original")
num_of_faults_train = Dict(1 => 0, 2 => 0, 3 => 0, 4 => 0)
y_hat_train = ones(Int, length(t_mbr_cus_train))

my_sample(items, weights) = items[findfirst(cumsum(weights) .> rand())]

i = 1
# Generate random faults for train data
while i<length(t_mbr_cus_train)
    global i # scoping
    # fault = rand(1:4)
    fault = my_sample(collect(1:4), [0.4, 0.2, 0.2, 0.2])
    num_of_faults_train[fault] += 1

    len = rand(24*6:24*8)
    # For fault 1 that is no fault do nothing
    if fault == 2 # drift
        len = rand(24*5:24*9)
        if (i + len) > length(t_mbr_cus_train)
               len = length(t_mbr_cus_train) - i
        end
        f = FaultGenerator.generate_drift(t_mbr_cus_train, [i],[i+len],rand(Uniform(0.75/120, 1.25/120),1))
        y_hat_train[i:i+len] .= 2
        t_mbr_cus_train[i:i+len] = f[i:i+len]

        plot!(rectangle(len, 298-287.5,i,287.5), opacity=.3, color=:red, label="")

    elseif fault == 3 # offset
        len = rand(24*3:24*7)
        if (i + len) > length(t_mbr_cus_train)
               len = length(t_mbr_cus_train) - i
        end
        f = FaultGenerator.generate_offset(t_mbr_cus_train, [i],[i+len],rand(Uniform(0.5,5),1)*rand([1,-1]))
        y_hat_train[i:i+len] .= 3
        t_mbr_cus_train[i:i+len] = f[i:i+len]
        plot!(rectangle(len, 298-287.5,i,287.5), opacity=.3, color=:green, label="")
    elseif fault == 4 # outliers
        # Možná zmenšit rozsah
        len = rand(24*3:24*7)
        if (i + len) > length(t_mbr_cus_train)
               len = length(t_mbr_cus_train) - i
        end
        out_val = rand([rand(Uniform(289, 291)), rand(Uniform(295, 299))])
        # print(out_val)
        f = FaultGenerator.generate_outliers(t_mbr_cus_train, [i],[i+len],[out_val]);
        y_hat_train[i:i+len] .= 4
        t_mbr_cus_train[i:i+len] = f[i:i+len]
        plot!(rectangle(len, 298-287.5,i,287.5), opacity=.3, color=:blue, label="")
    end
    i += len
end
X_train = copy(train)
X_train[:,13] = t_mbr_cus_train
plot!(y_hat_train.+280, label="y_hat", color=:black)
println(num_of_faults_train)
Plots.plot!(t_mbr_cus_train, label="modified", color=:magenta)
JLD.save(joinpath("data", "dataset","train", "GT.jld"), "GT", y_hat_train)
JLD.save(joinpath("data", "dataset","train", "input.jld"), "X", X_train)

# Generate random faults for test data
i = 1
num_of_faults_test = Dict(1 => 0, 2 => 0, 3 => 0, 4 => 0)
y_hat_test = ones(Int, length(t_mbr_cus_test))
Plots.plot(t_mbr_cus_test, label="original", xlabel="t [h]", ylabel="T [K]")
# Generate random faults for test data
while i<length(t_mbr_cus_test)
    global i # scoping
    # fault = rand(1:4)
    fault = my_sample(collect(1:4), [0.4, 0.2, 0.2, 0.2])
    num_of_faults_test[fault] += 1

    len = rand(24*6:24*8)
    # For fault 1 that is no fault do nothing
    if fault == 2 # drift
        len = rand(24*5:24*9)
        if (i + len) > length(t_mbr_cus_test)
               len = length(t_mbr_cus_test) - i
        end
        f = FaultGenerator.generate_drift(t_mbr_cus_test, [i],[i+len],rand(Uniform(0.75/120, 1.25/120),1))
        y_hat_test[i:i+len] .= 2
        t_mbr_cus_test[i:i+len] = f[i:i+len]

        plot!(rectangle(len, 298-287.5,i,287.5), opacity=.3, color=:red, label="")

    elseif fault == 3 # offset
        len = rand(24*3:24*7)
        if (i + len) > length(t_mbr_cus_test)
               len = length(t_mbr_cus_test) - i
        end
        f = FaultGenerator.generate_offset(t_mbr_cus_test, [i],[i+len],rand(Uniform(0.5,5),1)*rand([1,-1]))
        y_hat_test[i:i+len] .= 3
        t_mbr_cus_test[i:i+len] = f[i:i+len]
        plot!(rectangle(len, 298-287.5,i,287.5), opacity=.3, color=:green, label="")
    elseif fault == 4 # outliers
        # Možná zmenšit rozsah
        len = rand(24*3:24*7)
        if (i + len) > length(t_mbr_cus_test)
               len = length(t_mbr_cus_test) - i
        end
        out_val = rand([rand(Uniform(289, 291)), rand(Uniform(295, 299))])
        # print(out_val)
        f = FaultGenerator.generate_outliers(t_mbr_cus_test, [i],[i+len],[out_val]);
        y_hat_test[i:i+len] .= 4
        t_mbr_cus_test[i:i+len] = f[i:i+len]
        plot!(rectangle(len, 298-287.5,i,287.5), opacity=.3, color=:blue, label="")
    end
    i += len
end
X_test= copy(test)
X_test[:,13] = t_mbr_cus_test
plot!(y_hat_test.+280, label="y_hat", color=:black)
println(num_of_faults_test)
Plots.plot!(t_mbr_cus_test, label="modified", color=:magenta)
JLD.save(joinpath("data", "dataset","test", "GT.jld"), "GT", y_hat_test)
JLD.save(joinpath("data", "dataset","test", "input.jld"), "X", X_test)

