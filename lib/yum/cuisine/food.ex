defmodule Yum.Cuisine.Food do
    @moduledoc """
      A struct that contains all the data about food type.
    """
    use Bitwise

    defstruct [
        ref: nil,
        translation: %{},
    ]

    @type t :: %Yum.Cuisine.Food{ ref: String.t, translation: Yum.Data.translation_tree }

    @doc """
      Convert to a food struct.
    """
    @spec new(Yum.Data.food_list) :: [t]
    def new(data) do
        Enum.map(data, fn { key, info } ->
            %Yum.Cuisine.Food{
                ref: "#{key}",
                translation: info["translation"] || %{}
            }
        end)
    end
end
