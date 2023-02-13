module MyPlots

using Plots

"""
    plot_confusion_matrix(Pred::Array{Int64,1}, GT::Array{Int64,1}, labels::Array{String})

Plots confusion matrix from predicted and ground truth labels.

# Arguments
- `Pred::Array{Int64,1}`: predicted labels
- `GT::Array{Int64,1}`: ground truth labels
- `num_lab::Int`: number of classes
- `labels::Array{String}`: labels of classes
"""
function plot_confusion_matrix(Pred::Array{Int64,1}, GT::Array{Int64,1},num_lab::Int, labels::Array{String})
    # TODO: Remove prints
    conf_mtx = zeros(Int, num_lab, num_lab)
    for i in eachindex(Pred)
        print(i)
        conf_mtx[GT[i], Pred[i]] += 1
    end
    print(conf_mtx)
    xla = ["A","B","C","D"]
    heatmap(conf_mtx, xticks=(1:4, labels), yticks=(1:4, labels),
        title = "Confusion matrix", xlabel = "Predicted", ylabel = "Real",
        color = :Blues_5, legend = false, guide_position=:top, xmirror=true,
        yflip=true
    )
    fontsize = 15
    ann = [(j,i, text(conf_mtx[i,j],fontsize, :black, :center))
                for i in 1:4 for j in 1:4]
    annotate!(ann, linecolor=:black)
end

"""
    rectangle(w, h, x, y)

Returns Shape object for rectangle with width w, height h, x and y coordinates of the bottom left corner.

# Arguments
- `w::Float64`: width of the rectangle
- `h::Float64`: height of the rectangle
- `x::Float64`: x coordinate of the bottom left corner
- `y::Float64`: y coordinate of the bottom left corner

# Returns
- `Shape`: Shape object for rectangle

# Example
```julia
rectangle(0, 0, 3, 4)
plot(rectangle(0, 0, 3, 4), opacity=.3, color=:blue, label="")
```
"""
rectangle(w, h, x, y) = Shape(x .+ [0,w,w,0], y .+ [0,0,h,h])


end # end of module MyPlots