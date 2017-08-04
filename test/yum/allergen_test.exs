defmodule Yum.AllergenTest do
    use ExUnit.Case

    setup do
        %{
            allergens: %{
                "foo" => %{ "en" => %{ "term" => "1" } },
                "bar" => %{ "en" => %{ "term" => "2" } }
            }
        }
    end

    test "new/1", %{ allergens: allergens } do
        assert [
            %Yum.Allergen{ ref: "bar", translation: %{ "en" => %{ "term" => "2" } } },
            %Yum.Allergen{ ref: "foo", translation: %{ "en" => %{ "term" => "1" } } }
        ] == Enum.sort(Yum.Allergen.new(allergens), &(&1.ref < &2.ref))

        assert [] == Yum.Allergen.new(%{})
    end
end
