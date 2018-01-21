defmodule Yum.Allergen do
    @moduledoc """
      A struct that contains all the data about a allergen.
    """

    defstruct [
        ref: nil,
        translation: %{},
    ]

    @type t :: %Yum.Allergen{ ref: String.t, translation: Yum.Data.translation_tree }

    @doc """
      Convert to a allergen struct.
    """
    @spec new(Yum.Data.allergen_tree) :: [t]
    def new(data) do
        Enum.map(data, fn { key, info } ->
            %Yum.Allergen{
                ref: "#{key}",
                translation: info["translation"] || %{}
            }
        end)
    end
end
