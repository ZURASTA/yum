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
            },
            diets: %{
                "carnivorous" => %{ "translation" => %{ "en" => %{ "term" => "carnivorous" } } },
                "fruitarian" => %{ "translation" => %{ "en" => %{ "term" => "fruitarian" } } },
                "halal" => %{ "translation" => %{ "en" => %{ "term" => "halal" } } },
                "ketogenic" => %{ "translation" => %{ "en" => %{ "term" => "ketogenic" } } },
                "kosher" => %{ "translation" => %{ "en" => %{ "term" => "kosher" } } },
                "lacto-vegetarian" => %{ "translation" => %{ "en" => %{ "term" => "lacto-vegetarian" } } },
                "omnivorous" => %{ "translation" => %{ "en" => %{ "term" => "omnivorous" } } },
                "ovo-lacto-vegetarian" => %{ "translation" => %{ "en" => %{ "term" => "ovo-lacto-vegetarian" } } },
                "paleolithic" => %{ "translation" => %{ "en" => %{ "term" => "paleolithic" } } },
                "pescetarian" => %{ "translation" => %{ "en" => %{ "term" => "pescetarian" } } },
                "raw-vegan" => %{ "translation" => %{ "en" => %{ "term" => "raw-vegan" } } },
                "vegan" => %{ "translation" => %{ "en" => %{ "term" => "vegan" } } },
                "vegetarian" => %{ "translation" => %{ "en" => %{ "term" => "vegetarian" } } }
            },
            allergens: %{
                "balsam-of-peru" => %{ "translation" => %{ "en" => %{ "term" => "balsam of peru" } } },
                "egg" => %{ "translation" => %{ "en" => %{ "term" => "egg allergy" } } },
                "fruit" => %{ "translation" => %{ "en" => %{ "term" => "fruit allergy" } } },
                "garlic" => %{ "translation" => %{ "en" => %{ "term" => "garlic allergy" } } },
                "gluten" => %{ "translation" => %{ "en" => %{ "term" => "gluten allergy" } } },
                "hot-pepper" => %{ "translation" => %{ "en" => %{ "term" => "hot pepper allergy" } } },
                "meat" => %{ "translation" => %{ "en" => %{ "term" => "meat allergy" } } },
                "milk" => %{ "translation" => %{ "en" => %{ "term" => "milk allergy" } } },
                "oat" => %{ "translation" => %{ "en" => %{ "term" => "oat allergy" } } },
                "peanut" => %{ "translation" => %{ "en" => %{ "term" => "peanut allergy" } } },
                "rice" => %{ "translation" => %{ "en" => %{ "term" => "rice allergy" } } },
                "seafood" => %{ "translation" => %{ "en" => %{ "term" => "seafood allergy" } } },
                "soy" => %{ "translation" => %{ "en" => %{ "term" => "soy allergy" } } },
                "sulfite" => %{ "translation" => %{ "en" => %{ "term" => "sulfite allergy" } } },
                "tartrazine" => %{ "translation" => %{ "en" => %{ "term" => "tartrazine allergy" } } },
                "tree-nut" => %{ "translation" => %{ "en" => %{ "term" => "tree nut allergy" } } },
                "wheat" => %{ "translation" => %{ "en" => %{ "term" => "wheat allergy" } } }
            },
            migrations: %{
                ingredients: [
                    %{
                        "timestamp" => "0",
                        "add" => [
                            "dairy",
                            "dairy/cheeses",
                            "dairy/cheeses/mozzarella",
                            "herbs",
                            "herbs/basil",
                            "meats",
                            "meats/pork",
                            "meats/poultry",
                            "sauces",
                            "sauces/tomato-sauce",
                            "vegetables",
                            "vegetables/spring-onion",
                            "vegetables/tomato",
                            "vegetables/tubers",
                            "vegetables/tubers/potato"
                        ]
                    }
                ],
                cuisines: [
                    %{
                        "timestamp" => "0",
                        "add" => [
                            "african",
                            "african/central-african",
                            "african/east-african",
                            "african/horn-african",
                            "african/north-african",
                            "african/southern-african",
                            "african/west-african",
                            "americas",
                            "americas/caribbean",
                            "americas/central-american",
                            "americas/latin-american",
                            "americas/north-american",
                            "americas/south-american",
                            "asian",
                            "asian/central-asian",
                            "asian/east-asian",
                            "asian/south-asian",
                            "asian/southeast-asian",
                            "asian/west-asian",
                            "european",
                            "european/central-european",
                            "european/eastern-european",
                            "european/northern-european",
                            "european/southern-european",
                            "european/southern-european/italian",
                            "european/western-european",
                            "oceanian",
                            "oceanian/australasian",
                            "oceanian/melanesian",
                            "oceanian/micronesian",
                            "oceanian/polynesian"
                        ]
                    }
                ],
                diets: [
                    %{
                        "timestamp" => "0",
                        "add" => [
                            "carnivorous",
                            "fruitarian",
                            "halal",
                            "ketogenic",
                            "kosher",
                            "lacto-vegetarian",
                            "omnivorous",
                            "ovo-lacto-vegetarian",
                            "paleolithic",
                            "pescetarian",
                            "raw-vegan",
                            "vegan",
                            "vegetarian"
                        ]
                    }
                ],
                allergens: [
                    %{
                        "timestamp" => "0",
                        "add" => [
                            "balsam-of-peru",
                            "egg",
                            "fruit",
                            "garlic",
                            "gluten",
                            "hot-pepper",
                            "meat",
                            "milk",
                            "oat",
                            "peanut",
                            "rice",
                            "seafood",
                            "soy",
                            "sulfite",
                            "tartrazine",
                            "tree-nut",
                            "wheat"
                        ]
                    }
                ]
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
        assert expected_ingredients == ingredients
    end

    test "reducing ingredients" do
        assert Yum.Data.reduce_ingredients(0, fn _, _, acc -> acc + 1 end) == tree_counter(Yum.Data.ingredients())
    end

    test "loading ingredient migrations", %{ migrations: %{ ingredients: expected_migrations } } do
        migrations = Yum.Data.migrations("ingredients")
        assert expected_migrations == migrations
    end

    test "reducing ingredient migrations", %{ migrations: %{ ingredients: expected_migrations } } do
        assert Enum.reduce(expected_migrations, %Yum.Migration{}, &Yum.Migration.merge(&2, Yum.Migration.new(&1))) == Yum.Data.reduce_migrations(%Yum.Migration{}, "ingredients", &Yum.Migration.merge(&2, Yum.Migration.new(&1)))
    end

    test "loading cuisines", %{ cuisines: expected_cuisines } do
        cuisines = Yum.Data.cuisines()
        assert tree_counter(cuisines) == Enum.count(Yum.Cuisine.Style.new(cuisines))
        assert expected_cuisines == cuisines
    end

    test "reducing cuisines" do
        assert Yum.Data.reduce_cuisines(0, fn _, _, acc -> acc + 1 end) == tree_counter(Yum.Data.cuisines())
    end

    test "loading cuisine migrations", %{ migrations: %{ cuisines: expected_migrations } } do
        migrations = Yum.Data.migrations("cuisines")
        assert expected_migrations == migrations
    end

    test "reducing cuisine migrations", %{ migrations: %{ cuisines: expected_migrations } } do
        assert Enum.reduce(expected_migrations, %Yum.Migration{}, &Yum.Migration.merge(&2, Yum.Migration.new(&1))) == Yum.Data.reduce_migrations(%Yum.Migration{}, "cuisines", &Yum.Migration.merge(&2, Yum.Migration.new(&1)))
    end

    test "loading diets", %{ diets: expected_diets } do
        diets = Yum.Data.diets()
        assert Enum.count(diets) == Enum.count(Yum.Diet.new(diets))
        assert expected_diets == diets
    end

    test "reducing diets" do
        assert Yum.Data.reduce_diets(0, fn _, acc -> acc + 1 end) == Enum.count(Yum.Data.diets())
    end

    test "loading diet migrations", %{ migrations: %{ diets: expected_migrations } } do
        migrations = Yum.Data.migrations("diets")
        assert expected_migrations == migrations
    end

    test "reducing diet migrations", %{ migrations: %{ diets: expected_migrations } } do
        assert Enum.reduce(expected_migrations, %Yum.Migration{}, &Yum.Migration.merge(&2, Yum.Migration.new(&1))) == Yum.Data.reduce_migrations(%Yum.Migration{}, "diets", &Yum.Migration.merge(&2, Yum.Migration.new(&1)))
    end

    test "loading allergens", %{ allergens: expected_allergens } do
        allergens = Yum.Data.allergens()
        assert Enum.count(allergens) == Enum.count(Yum.Allergen.new(allergens))
        assert expected_allergens == allergens
    end

    test "reducing allergens" do
        assert Yum.Data.reduce_allergens(0, fn _, acc -> acc + 1 end) == Enum.count(Yum.Data.allergens())
    end

    test "loading allergen migrations", %{ migrations: %{ allergens: expected_migrations } } do
        migrations = Yum.Data.migrations("allergens")
        assert expected_migrations == migrations
    end

    test "reducing allergen migrations", %{ migrations: %{ allergens: expected_migrations } } do
        assert Enum.reduce(expected_migrations, %Yum.Migration{}, &Yum.Migration.merge(&2, Yum.Migration.new(&1))) == Yum.Data.reduce_migrations(%Yum.Migration{}, "allergens", &Yum.Migration.merge(&2, Yum.Migration.new(&1)))
    end
end
