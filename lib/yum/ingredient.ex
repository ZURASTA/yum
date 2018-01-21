defmodule Yum.Ingredient do
    @moduledoc """
      A struct that contains all the data about an ingredient.
    """

    defstruct [
        ref: nil,
        translation: %{},
        exclude_diet: [],
        exclude_allergen: [],
        nutrition: %{}
    ]

    @type t :: %Yum.Ingredient{ ref: String.t, translation: Yum.Data.translation_tree, exclude_diet: [String.t], exclude_allergen: [String.t], nutrition: %{ optional(String.t) => any } }

    @doc """
      Flatten an ingredient tree into an ingredient list.

      Each item in the list can be safely operated on individually, as all of the
      data related to that item is inside of its struct (compared to the original
      tree where other data is inferred from its parent).
    """
    @spec new(Yum.Data.ingredient_tree) :: [t]
    def new(data), do: Enum.reduce(data, [], &new(&1, &2, %Yum.Ingredient{}))

    defp new({ key, value = %{ __info__: info } }, ingredients, group) do
        ingredient = %Yum.Ingredient{
            ref: "#{group.ref}/#{key}",
            translation: info["translation"] || %{}
        }
        |> new_exclude_diet(info, group)
        |> new_exclude_allergen(info, group)
        |> new_nutrition(info)

        [ingredient|Enum.reduce(value, ingredients, &new(&1, &2, ingredient))]
    end
    defp new(_, ingredients, _), do: ingredients

    defp new_exclude_diet(ingredient, %{ "exclude-diet" => diets }, parent), do: %{ ingredient | exclude_diet: Enum.uniq(diets ++ parent.exclude_diet) }
    defp new_exclude_diet(ingredient, _, parent), do: %{ ingredient | exclude_diet: parent.exclude_diet }

    defp new_exclude_allergen(ingredient, %{ "exclude-allergen" => allergens }, parent), do: %{ ingredient | exclude_allergen: Enum.uniq(allergens ++ parent.exclude_allergen) }
    defp new_exclude_allergen(ingredient, _, parent), do: %{ ingredient | exclude_allergen: parent.exclude_allergen }

    defp new_nutrition(ingredient, %{ "nutrition" => nutrition }), do: %{ ingredient | nutrition: nutrition }
    defp new_nutrition(ingredient, _), do: ingredient
end
