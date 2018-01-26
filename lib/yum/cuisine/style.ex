defmodule Yum.Cuisine.Style do
    @moduledoc """
      A struct that contains all the data about a cuisine style.
    """

    defstruct [
        ref: nil,
        type: :other,
        translation: %{},
        foods: []
    ]

    @type kind :: :continent | :subregion | :country | :province | :culture | :other
    @type t :: %Yum.Cuisine.Style{ ref: String.t, type: kind, translation: Yum.Data.translation_tree, foods: [%Yum.Cuisine.Food{}] }

    @doc """
      Flatten an cuisine tree into a cuisine style list.

      Each item in the list can be safely operated on individually, as all of the
      data related to that item is inside of its struct (compared to the original
      tree where other data is inferred from its parent).
    """
    @spec new(Yum.Data.cuisine_tree) :: [t]
    def new(data), do: Enum.reduce(data, [], &new(&1, &2, %Yum.Cuisine.Style{}))

    defp new({ key, value = %{ __info__: info } }, styles, group) do
        style = %Yum.Cuisine.Style{
            ref: "#{group.ref}/#{key}",
            translation: info["translation"] || %{}
        }
        |> new_type(info)
        |> new_foods(info)

        [style|Enum.reduce(value, styles, &new(&1, &2, style))]
    end
    defp new(_, styles, _), do: styles

    defp new_type(style, %{ "type" => "province" }), do: %{ style | type: :province }
    defp new_type(style, %{ "type" => "country" }), do: %{ style | type: :country }
    defp new_type(style, %{ "type" => "subregion" }), do: %{ style | type: :subregion }
    defp new_type(style, %{ "type" => "continent" }), do: %{ style | type: :continent }
    defp new_type(style, %{ "type" => "culture" }), do: %{ style | type: :culture }
    defp new_type(style, %{ "type" => _ }), do: %{ style | type: :other }
    defp new_type(style, _), do: style

    defp new_foods(style, %{ "cuisine" => foods }), do: %{ style | foods: Yum.Cuisine.Food.new(foods) }
    defp new_foods(style, _), do: style
end
