defmodule Yum.DataTest do
    use ExUnit.Case

    defp tree_counter(tree, n \\ 0)
    defp tree_counter({ :__info__, _ }, n), do: n
    defp tree_counter({ _, tree }, n), do: tree_counter(tree, n + 1)
    defp tree_counter(tree, n), do: Enum.reduce(tree, n, &tree_counter/2)

    test "loading ingredients" do
        ingredients = Yum.Data.ingredients()
        assert tree_counter(ingredients) == Enum.count(Yum.Ingredient.new(ingredients))
    end

    test "loading cuisines" do
        cuisines = Yum.Data.cuisines()
        assert tree_counter(cuisines) == Enum.count(Yum.Cuisine.Style.new(cuisines))
    end
end
