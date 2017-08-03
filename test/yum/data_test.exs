defmodule Yum.DataTest do
    use ExUnit.Case

    setup do
        %{
            ingredients: %{
                "dairy" => %{
                    :__info__ => %{ "exclude-diet" => ["carnivorous", "vegetarian", "vegan", "raw-vegan", "paleolithic", "fruitarian"], "translation" => %{ "en" => %{ "term" => "dairy" }, "fr" => %{ "term" => "produits laitiers" } } },
                    "cheeses" => %{
                        :__info__ => %{ "translation" => %{ "en" => %{ "term" => "cheese" }, "fr" => %{ "term" => "fromage" } } },
                        "mozzarella" => %{ __info__: %{ "translation" => %{ "en" => %{ "term" => "mozzarella" } } } }
                    }
                },
                "herbs" => %{
                    :__info__ => %{ "exclude-diet" => ["carnivorous", "ketogenic"], "translation" => %{ "en" => %{ "term" => "herb" } } },
                    "basil" => %{
                        __info__: %{ "translation" => %{ "en" => %{ "term" => "basil" } } }
                    }
                },
                "meats" => %{
                    :__info__ => %{ "exclude-diet" => ["vegan", "vegetarian", "pescetarian", "raw-vegan", "fruitarian"], "translation" => %{ "en" => %{ "term" => "meat" }, "fr" => %{ "term" => "viande" } } },
                    "pork" => %{
                        __info__: %{ "exclude-diet" => ["kosher", "halal"], "translation" => %{ "en" => %{ "term" => "pork" }, "fr" => %{ "term" => "viande de porc" } } }
                    },
                    "poultry" => %{
                        __info__: %{ "translation" => %{ "en" => %{ "term" => "poultry" }, "fr" => %{ "term" => "volaille" } } }
                    }
                },
                "sauces" => %{
                    :__info__ => %{ "translation" => %{ "en" => %{ "term" => "sauce" } } },
                    "tomato-sauce" => %{
                        __info__: %{ "translation" => %{ "en" => %{ "term" => "tomato sauce" } } }
                    }
                },
                "vegetables" => %{
                    :__info__ => %{ "exclude-diet" => ["carnivorous", "ketogenic"], "translation" => %{ "en" => %{ "term" => "vegetable" }, "fr" => %{ "term" => "légume" } } },
                    "spring-onion" => %{
                        __info__: %{ "translation" => %{ "en" => %{ "AU" => %{ "term" => "shallot" }, "CA" => %{ "term" => "green onion" }, "GB" => %{ "WLS" => %{ "term" => "gibbon" } }, "US" => %{ "term" => "scallion" }, "term" => "spring onion" }, "fr" => %{ "term" => "ciboule" } } }
                    },
                    "tomato" => %{
                        __info__: %{ "translation" => %{ "en" => %{ "term" => "tomato" }, "fr" => %{ "term" => "tomate" } } }
                    },
                    "tubers" => %{
                        :__info__ => %{ "exclude-diet" => ["fruitarian"], "translation" => %{ "en" => %{ "term" => "tuber" } } },
                        "potato" => %{
                            __info__: %{ "translation" => %{ "en" => %{ "term" => "potato" }, "fr" => %{ "term" => "pomme de terre" } } }
                        }
                    }
                }
            },
            cuisines: %{
                "african" => %{
                    :__info__ => %{ "translation" => %{ "en" => %{ "adj" => "african", "term" => "africa" } }, "type" => "continent" },
                    "central-african" => %{
                        __info__: %{ "translation" => %{ "en" => %{ "adj" => "central african", "term" => "central africa" } }, "type" => "subregion" }
                    },
                    "east-african" => %{
                        __info__: %{ "translation" => %{ "en" => %{ "adj" => "east african", "term" => "east africa" } }, "type" => "subregion" }
                    },
                    "horn-african" => %{
                        __info__: %{ "translation" => %{ "en" => %{ "adj" => "horn african", "term" => "horn africa" } }, "type" => "subregion" }
                    },
                    "north-african" => %{
                        __info__: %{ "translation" => %{ "en" => %{ "adj" => "north african", "term" => "north africa" } }, "type" => "subregion" }
                    },
                    "southern-african" => %{
                    __info__: %{ "translation" => %{ "en" => %{ "adj" => "southern african", "term" => "southern africa" } }, "type" => "subregion" }
                    },
                    "west-african" => %{
                        __info__: %{ "translation" => %{ "en" => %{ "adj" => "west african", "term" => "west africa" } }, "type" => "subregion" }
                    }
                },
                "americas" => %{
                    :__info__ => %{ "translation" => %{ "en" => %{ "adj" => "american", "term" => "america" } }, "type" => "continent" },
                    "caribbean" => %{
                        __info__: %{ "translation" => %{ "en" => %{ "adj" => "caribbean", "term" => "caribbean" } }, "type" => "subregion" }
                    },
                    "central-american" => %{
                        __info__: %{ "translation" => %{ "en" => %{ "adj" => "central american", "term" => "central america" } }, "type" => "subregion" }
                    },
                    "latin-american" => %{
                        __info__: %{ "translation" => %{ "en" => %{ "adj" => "latin american", "term" => "latin america" } }, "type" => "subregion" }
                    },
                    "north-american" => %{
                        __info__: %{ "translation" => %{ "en" => %{ "adj" => "north american", "term" => "north america" } }, "type" => "subregion" }
                    },
                    "south-american" => %{
                        __info__: %{ "translation" => %{ "en" => %{ "adj" => "south american", "term" => "south america" } }, "type" => "subregion" }
                    }
                },
                "asian" => %{
                    :__info__ => %{ "translation" => %{ "en" => %{ "adj" => "asian", "term" => "asia" } }, "type" => "continent" },
                    "central-asian" => %{
                        __info__: %{ "translation" => %{ "en" => %{ "adj" => "central asian", "term" => "central asia" } }, "type" => "subregion" }
                    },
                    "east-asian" => %{
                        __info__: %{ "translation" => %{ "en" => %{ "adj" => "east asian", "term" => "east asia" } }, "type" => "subregion" }
                    },
                    "south-asian" => %{
                        __info__: %{ "translation" => %{ "en" => %{ "adj" => "south asian", "term" => "south asia" } }, "type" => "subregion" }
                    },
                    "southeast-asian" => %{
                        __info__: %{ "translation" => %{ "en" => %{ "adj" => "southeast asian", "term" => "southeast asia" } }, "type" => "subregion" }
                    },
                    "west-asian" => %{
                        __info__: %{ "translation" => %{ "en" => %{ "adj" => "west asian", "term" => "west asia" } }, "type" => "subregion" }
                    }
                },
                "european" => %{
                    :__info__ => %{ "translation" => %{ "en" => %{ "adj" => "european", "term" => "europe" } }, "type" => "continent" },
                    "central-european" => %{
                        __info__: %{ "translation" => %{ "en" => %{ "adj" => "central european", "term" => "central europe" } }, "type" => "subregion" }
                    },
                    "eastern-european" => %{
                        __info__: %{ "translation" => %{ "en" => %{ "adj" => "eastern european", "term" => "eastern europe" } }, "type" => "subregion" }
                    },
                    "northern-european" => %{
                        __info__: %{ "translation" => %{ "en" => %{ "adj" => "northern european", "term" => "northern europe" } }, "type" => "subregion" }
                    },
                    "southern-european" => %{
                        :__info__ => %{ "translation" => %{ "en" => %{ "adj" => "southern european", "term" => "southern europe" } }, "type" => "subregion" },
                        "italian" => %{
                            __info__: %{ "cuisine" => %{ "pizza" => %{ "translation" => %{ "en" => %{ "term" => "pizza" } } } }, "translation" => %{ "en" => %{ "adj" => "italian", "term" => "italy" } }, "type" => "country" }
                        }
                    },
                    "western-european" => %{
                        __info__: %{ "translation" => %{ "en" => %{ "adj" => "western european", "term" => "western europe" } }, "type" => "subregion" }
                    }
                },
                "oceanian" => %{
                    :__info__ => %{ "translation" => %{ "en" => %{ "adj" => "oceanian", "term" => "oceania" } }, "type" => "continent" },
                    "australasian" => %{
                        __info__: %{ "translation" => %{ "en" => %{ "adj" => "australasian", "term" => "australasia" } }, "type" => "subregion" }
                    },
                    "melanesian" => %{
                        __info__: %{ "translation" => %{ "en" => %{ "adj" => "melanesian", "term" => "melanesia" } }, "type" => "subregion" }
                    },
                    "micronesian" => %{
                        __info__: %{ "translation" => %{ "en" => %{ "adj" => "micronesian", "term" => "micronesia" } }, "type" => "subregion" }
                    },
                    "polynesian" => %{
                        __info__: %{ "translation" => %{ "en" => %{ "adj" => "polynesian", "term" => "polynesia" } }, "type" => "subregion" }
                    }
                }
            }
        }
    end

    defp tree_counter(tree, n \\ 0)
    defp tree_counter({ :__info__, _ }, n), do: n
    defp tree_counter({ _, tree }, n), do: tree_counter(tree, n + 1)
    defp tree_counter(tree, n), do: Enum.reduce(tree, n, &tree_counter/2)

    test "loading ingredients", %{ ingredients: expected_ingredients } do
        ingredients = Yum.Data.ingredients()
        assert tree_counter(ingredients) == Enum.count(Yum.Ingredient.new(ingredients))
        assert ingredients == expected_ingredients
    end

    test "reducing ingredients" do
        assert Yum.Data.reduce_ingredients(0, fn _, _, acc -> acc + 1 end) == tree_counter(Yum.Data.ingredients())
    end

    test "loading cuisines", %{ cuisines: expected_cuisines } do
        cuisines = Yum.Data.cuisines()
        assert tree_counter(cuisines) == Enum.count(Yum.Cuisine.Style.new(cuisines))
        assert cuisines == expected_cuisines
    end

    test "reducing cuisines" do
        assert Yum.Data.reduce_cuisines(0, fn _, _, acc -> acc + 1 end) == tree_counter(Yum.Data.cuisines())
    end
end
