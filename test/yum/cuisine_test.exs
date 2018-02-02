defmodule Yum.CuisineTest do
    use ExUnit.Case

    setup do
        %{
            cuisines: %{
                "one" => %{
                    :__info__ => %{ "type" => "test" },
                    "foo" => %{
                        :__info__ => %{
                            "translation" => %{ "en" => %{ "term" => "1" } },
                            "type" => "country"
                        },
                        "bar-a" => %{ :__info__ => %{} },
                        "bar-b" => %{ :__info__ => %{ "type" => "subregion" } },
                        "bar-c" => %{
                            :__info__ => %{ "type" => "continent" },
                            "test" => %{ :__info__ => %{ "type" => "province" } }
                        }
                    }
                },
                "two" => %{},
                "three" => %{
                    :__info__ => %{
                        "translation" => %{ "en" => %{ "term" => "2" } },
                        "type" => "culture"
                    },
                    "foo" => %{
                        :__info__ => %{
                            "translation" => %{ "en" => %{ "term" => "1" } },
                            "type" => "dish"
                        }
                    }
                }
            }
        }
    end

    test "new/1", %{ cuisines: cuisines } do
        assert [
            %Yum.Cuisine{ ref: "/one", type: :other },
            %Yum.Cuisine{ ref: "/one/foo", translation: %{ "en" => %{ "term" => "1" } }, type: :country },
            %Yum.Cuisine{ ref: "/one/foo/bar-a" },
            %Yum.Cuisine{ ref: "/one/foo/bar-b", type: :subregion },
            %Yum.Cuisine{ ref: "/one/foo/bar-c", type: :continent },
            %Yum.Cuisine{ ref: "/one/foo/bar-c/test", type: :province },
            %Yum.Cuisine{ ref: "/three", translation: %{ "en" => %{ "term" => "2" } }, type: :culture },
            %Yum.Cuisine{ ref: "/three/foo", translation: %{ "en" => %{ "term" => "1" } }, type: :dish },
        ] == Enum.sort(Yum.Cuisine.new(cuisines), &(&1.ref < &2.ref))

        assert [] == Yum.Cuisine.new(%{})
        assert [%Yum.Cuisine{ ref: "/test", type: :province }] == Yum.Cuisine.new(cuisines["one"]["foo"]["bar-c"])
    end
end
