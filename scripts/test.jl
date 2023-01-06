# check = data[:,34]
# d = Dict()
# for i in eachindex(check)
#     if typeof(check[i]) in keys(d)
#         d[typeof(check[i])] += 1
#     else
#         d[typeof(check[i])] = 1
#     end
# end
# print(d)

check = copy(data[:,47])
new = zeros(length(check))
for i in eachindex(check)
    try 
        new[i] = parse(Float64, check[i])
    catch
        new[i] = 0.0
    end
end
new

check = copy(data[:,37])
new = zeros(length(check))
for i in eachindex(check)
    if typeof(check[i]) == Missing
        new[i] = 0.0
    else
        new[i] = check[i]
    end
    end
end