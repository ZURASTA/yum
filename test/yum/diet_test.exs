defmodule Yum.DietTest do
    use ExUnit.Case

    setup do
        %{
            diets: %{
                "foo" => %{ "translation" => %{ "en" => %{ "term" => "1" } } },
                "bar" => %{ "translation" => %{ "en" => %{ "term" => "2" } } }
            }
        }
    end

    test "new/1", %{ diets: diets } do
        assert [
            %Yum.Diet{ ref: "bar", translation: %{ "en" => %{ "term" => "2" } } },
            %Yum.Diet{ ref: "foo", translation: %{ "en" => %{ "term" => "1" } } }
        ] == Enum.sort(Yum.Diet.new(diets), &(&1.ref < &2.ref))

        assert [] == Yum.Diet.new(%{})
    end
end
