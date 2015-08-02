appender = function(element)
    return function(str)
        return str .. element
    end
end

celsius_appender = appender(" °C")

print(celsius_appender(24))
