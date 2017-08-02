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

    test "reducing ingredients" do
        assert Yum.Data.reduce_ingredients(0, fn _, _, acc -> acc + 1 end) == tree_counter(Yum.Data.ingredients())
    end

    test "loading cuisines" do
        cuisines = Yum.Data.cuisines()
        assert tree_counter(cuisines) == Enum.count(Yum.Cuisine.Style.new(cuisines))
    end

    test "reducing cuisines" do
        assert Yum.Data.reduce_cuisines(0, fn _, _, acc -> acc + 1 end) == tree_counter(Yum.Data.cuisines())
    end
end
