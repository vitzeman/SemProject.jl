# TODO: COnvert to module
module Conversion
"""
    F2C(data::Vector{<:Real})

Converts data from Fahrenheit to Celsius. Returns Vector{Real} with converted data.

# Arguments
- `data::Vector{<:Real}`: data to be converted
"""
function F2C(data::Vector{<:Real})
    data_in_C = copy(data)
    return (data_in_C .- 32) .* 5 ./ 9
end

"""
    C2F(data::Vector{<:Real})

Converts data from Celsius to Fahrenheit. Returns Vector{Real} with converted data.

# Arguments
- `data::Vector{<:Real}`: data to be converted
"""
function C2F(data::Vector{<:Real})
    data_in_F = copy(data)
    return (data_in_F .* 9 ./ 5) .+ 32
end


"""
    F2K(data::Vector{<:Real})

Converts data from Fahrenheit to Kelvin. Returns Vector{Real} with converted data.

# Arguments
- `data::Vector{<:Real}`: data to be converted
"""
function F2K(data::Vector{<:Real})
    data_in_K = copy(data)
    return (data_in_K .+ 459.67) .* 5 ./ 9
end

"""
    K2F(data::Vector{<:Real})

Converts data from Kelvin to Fahrenheit. Returns Vector{Real} with converted data.

# Arguments
- `data::Vector{<:Real}`: data to be converted
"""
function K2F(data::Vector{<:Real})
    data_in_F = copy(data)
    return (data_in_F .* 9 ./ 5) .- 459.67
end

"""
    C2K(data::Vector{<:Real})

Converts data from Celsius to Kelvin. Returns Vector{Real} with converted data.

# Arguments
- `data::Vector{<:Real}`: data to be converted
"""
function C2K(data::Vector{<:Real})
    data_in_K = copy(data)
    return data_in_K .+ 273.15
end

"""
    K2C(data::Vector{<:Real})

Converts data from Kelvin to Celsius. Returns Vector{Real} with converted data.

# Arguments
- `data::Vector{<:Real}`: data to be converted
"""
end # end of module Conversion