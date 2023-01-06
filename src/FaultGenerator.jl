module FaultGenerator

# TODO: Napsat prto od do funkce generate_outliers
"""
    generate_offset(data::Vector{Float64}, starts::Vector{Int}, ends::Vector{Int}, offset_value::Vector{Float64})

Generates ofset for data. Returns Vector{Real} with ofsetted data.

# Arguments
- `data::Vector{<:Real}`: data to be ofsetted
- `starts::Vector{Int}`: starts of offsets
- `ends::Vector{Int}`: ends of offsets
- `offset_value::Vector{<:Real}`: value of offsets
"""
function generate_offset(data::Vector{<:Real}, starts::Vector{Int}, ends::Vector{Int}, offset_value::Vector{<:Real})
    data_with_offset = copy(data)
    if length(starts) != length(ends)
        error("Length of starts, ends and offset_value must be the same.")
    end
    if length(offset_value) == 1
        offset_value = fill(offset_value[1], length(starts))
    elseif length(offset_value) != length(starts)
        error("Length of starts, ends and offset_value must be the same or length of offset_value must be 1.")
    end
    for i in 1:length(starts)
        data_with_offset[starts[i]:ends[i]] .+= offset_value[i]
    end
    return data_with_offset
end
"""
    generate_offset(data::Vector{Real}, ofset::Real)

Generates ofset for data. Returns Vector{Real} with ofsetted data.

# Arguments
- `data::Vector{Real}`: data to be ofsetted
- `ofset::Real`: ofset value
"""
function generate_offset(data::Vector{Number}, ofset::Number)
    data_with_offset = copy(data)
    return data_with_offset .+ ofset
end

"""
    generate_outliers(data::Vector{Real}, location::Vector{Int}, outlier_value::Real)

Generates outliers for data at specified locations. Returns Vector{Real} with data with outliers.

# Arguments
- `data::Vector{Real}`: data to be ofsetted
- `location::Vector{Int}`: locations of outliers
- `outlier_value::Real`: value of outliers
"""
function generate_outliers(data::Vector{Real}, location::Vector{Int}, outlier_value::Real)
    data_with_outliers = copy(data)
    # TODO: Check if indexing with vector is possible
    for i in location
        data_with_outliers[i] = outlier_value
    end
    return data_with_outliers
end

"""
    generate_outliers(data::Vector{Real}, starts::Vector{Int}, ends::Vector{Int}, outlier_value::Real)

Generates outliers for data at specified locations. Returns Vector{Real} with data with outliers.

# Arguments
- `data::Vector{Real}`: data to be ofsetted
- `starts::Vector{Int}`: starts of outliers
- `ends::Vector{Int}`: ends of outliers
- `outlier_value::Real`: value of outliers
"""
function generate_outliers(data::Vector{<:Real}, starts::Vector{<:Int}, ends::Vector{<:Int}, outlier_values::Vector{<:Real})
    if length(starts) != length(ends)
        error("Length of starts and ends must be the same")
    end
    if length(outlier_values) == 1
        outlier_values = fill(outlier_values[1],length(starts))
    elseif length(outlier_values) != length(starts)
        error("Length of starts and outlier_values must be the same or outlier_values must be of length 1")
    end

    data_with_outliers = copy(data)
    # TODO: Check if indexing with vector is possible
    for i in 1:length(starts)
        for j in starts[i]:ends[i]
            data_with_outliers[j] = outlier_values[i]
        end
    end
    return data_with_outliers
end

"""
    generate_drift(data::Vector{Real},drift_step::Real, drift_start::Int, drift_end::Int=0)

Generates drift for data. Returns Vector{Real} with data with drift.

# Arguments
- `data::Vector{Real}`: data to be drifted
- `drift_start::Int`: drift start index
- `drift_end::Int`: drift end index
- `drift_step::Real`: drift step value
"""
function generate_drift(data::Vector{<:Real}, drift_start::Vector{<:Int}, drift_end::Vector{<:Int},drift_step::Vector{<:Real})
    data_with_drift = copy(data)
    if length(drift_start) != length(drift_end)
        error("Length of drift_start and drift_end must be the same")
    end
    if length(drift_step) == 1
        drift_step = fill(drift_step[1],length(drift_start))
    elseif length(drift_step) != length(drift_start)
        error("Length of drift_start and drift_step must be the same or drift_step must be of length 1")
    end

    for i in 1:length(drift_start)
        for (e,j) in enumerate(drift_start[i]:drift_end[i])
            data_with_drift[j] += drift_step[i] * e
        end
    end

    return data_with_drift
end

end # End of module FaultGenerator