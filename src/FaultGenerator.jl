"""
    generate_offset(data::Vector{Real}, ofset::Real)

Generates ofset for data. Returns Vector{Real} with ofsetted data.

# Arguments
- `data::Vector{Real}`: data to be ofsetted
- `ofset::Real`: ofset value
"""
function generate_offset(data::Vector{Real}, ofset::Real)
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
    generate_drift(data::Vector{Real},drift_step::Real, drift_start::Int, drift_end::Int=0)

Generates drift for data. Returns Vector{Real} with data with drift.

# Arguments
- `data::Vector{Real}`: data to be drift_end
- `drift_step::Real`: drift step
- `drift_start::Int`: drift start index
- `drift_end::Int`: drift end index
"""
function generate_drift(data::Vector{Real},drift_step::Real, drift_start::Int, drift_end::Int=nothing)
    data_with_drift = copy(data)
    if drift_end === nothing
        drift_end = length(data)
    end
    # TODO: Check if it would be possible/faster to use indexing with vector and generating the step vecotr, then adding it to data
    for i in drift_start:drift_end
        data_with_drift[i] = data_with_drift[i] + drift_step
    end
    return data_with_drift
end
