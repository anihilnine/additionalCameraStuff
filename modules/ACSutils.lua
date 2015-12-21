function containsKey(t, key)
    for name, _ in t do
        if name == key then
            return true
        end
    end
    return false
end

function containsValue(t, value)
    for _, v in t do
        if v == value then
            return true
        end
    end
    return false
end

