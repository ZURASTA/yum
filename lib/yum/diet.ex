defmodule Yum.Diet do
    @moduledoc """
      A struct that contains all the data about a diet.
    """
    use Bitwise

    defstruct [
        ref: nil,
        translation: %{},
    ]

    @type t :: %Yum.Diet{ ref: String.t, translation: Yum.Data.translation_tree }

    @doc """
      Convert to a diet struct.
    """
    @spec new(Yum.Data.diet_tree) :: [t]
    def new(data) do
        Enum.map(data, fn { key, info } ->
            %Yum.Diet{
                ref: "#{key}",
                translation: info["translation"] || %{}
            }
        end)
    end
end
