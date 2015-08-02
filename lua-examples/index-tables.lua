example_table = { id1 = "Titi" }
example_table[666] = "Tutu"
example_function = function()
    return 42
end
example_table[example_function] = "Haha" -- Oui oui, des fonctions aussi.

for key, value in pairs(example_table) do
    print("Key type: " .. type(key))
    print("Value: " .. example_table[key])
    print(" ----- ")
end
