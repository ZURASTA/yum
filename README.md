# yum

[![Stories in Ready](https://badge.waffle.io/ZURASTA/yum.png?label=ready&title=Ready)](https://waffle.io/ZURASTA/yum?utm_source=badge)
[![CircleCI](https://circleci.com/gh/ZURASTA/yum.svg?style=svg)](https://circleci.com/gh/ZURASTA/yum)

An Elixir library to retrieve various food related data from the [Food-Data](https://github.com/ZURASTA/Food-Data) dataset.


Reading Food-Data
-----------------

The library provides convenient functions to retrieve data from the dataset.

#### Load
These variants will load the entire dataset desired:

```elixir
iex(1)> Yum.Data.ingredients
%{"dairy" => %{:__info__ => %{"exclude-diet" => ["carnivorous", "vegetarian",
       "vegan", "raw-vegan", "paleolithic", "fruitarian"],
      "translation" => %{"en" => %{"term" => "dairy"},
        "fr" => %{"term" => "produits laitiers"}}},
    "cheeses" => %{:__info__ => %{"translation" => %{"en" => %{"term" => "cheese"},
          "fr" => %{"term" => "fromage"}}},
      "mozzarella" => %{__info__: %{"translation" => %{"en" => %{"term" => "mozzarella"}}}}}},
  "herbs" => %{:__info__ => %{"exclude-diet" => ["carnivorous", "ketogenic"],
      "translation" => %{"en" => %{"term" => "herb"}}},
    "basil" => %{__info__: %{"translation" => %{"en" => %{"term" => "basil"}}}}},
  "meats" => %{:__info__ => %{"exclude-diet" => ["vegan", "vegetarian",
       "pescetarian", "raw-vegan", "fruitarian"],
      "translation" => %{"en" => %{"term" => "meat"},
        "fr" => %{"term" => "viande"}}},
    "pork" => %{__info__: %{"exclude-diet" => ["kosher", "halal"],
        "translation" => %{"en" => %{"term" => "pork"},
          "fr" => %{"term" => "viande de porc"}}}},
    "poultry" => %{__info__: %{"translation" => %{"en" => %{"term" => "poultry"},
          "fr" => %{"term" => "volaille"}}}}},
  "sauces" => %{:__info__ => %{"translation" => %{"en" => %{"term" => "sauce"}}},
    "tomato-sauce" => %{__info__: %{"translation" => %{"en" => %{"term" => "tomato sauce"}}}}},
  "vegetables" => %{:__info__ => %{"exclude-diet" => ["carnivorous",
       "ketogenic"],
      "translation" => %{"en" => %{"term" => "vegetable"},
        "fr" => %{"term" => "légume"}}},
    "spring-onion" => %{__info__: %{"translation" => %{"en" => %{"AU" => %{"term" => "shallot"},
            "CA" => %{"term" => "green onion"},
            "GB" => %{"WLS" => %{"term" => "gibbon"}},
            "US" => %{"term" => "scallion"}, "term" => "spring onion"},
          "fr" => %{"term" => "ciboule"}}}},
    "tomato" => %{__info__: %{"translation" => %{"en" => %{"term" => "tomato"},
          "fr" => %{"term" => "tomate"}}}},
    "tubers" => %{:__info__ => %{"exclude-diet" => ["fruitarian"],
        "translation" => %{"en" => %{"term" => "tuber"}}},
      "potato" => %{__info__: %{"translation" => %{"en" => %{"term" => "potato"},
            "fr" => %{"term" => "pomme de terre"}}}}}}}
```

#### Reduce

These variants will load only one file at a time before passing it to a callback. This can be more memory efficient when only certain data is desired.

```elixir
iex(1)> Yum.Data.reduce_ingredients([], fn
...(1)>     { name, data }, groups, acc ->
...(1)>         cond do
...(1)>             "fruitarian" in (data["exclude-diet"] || []) -> [name|acc]
...(1)>             Enum.any?(groups, &("fruitarian" in (elem(&1, 1)["exclude-diet"] || []))) -> [name|acc]
...(1)>             true -> acc
...(1)>         end
...(1)> end)
["potato", "tubers", "poultry", "pork", "meats", "mozzarella", "cheeses",
 "dairy"]
```

### Filtering and Groups

When only a specific set of the data is required, filtering can be used to decide which files to process, while groups can be specified to indicate the starting directory. This process can have an affect on the final output data however, when the file depends on some data specified in a parent (tree data sources).

Using a group to only load files under the `vegetables/tubers` directory.

```elixir
iex(1)> Yum.Data.ingredients "/vegetables/tubers"
%{"potato" => %{__info__: %{"translation" => %{"en" => %{"term" => "potato"},
        "fr" => %{"term" => "pomme de terre"}}}}}
```

Using a filter to only load a file with the ref `/vegetables/tubers`.

```elixir
iex(1)> Yum.Data.ingredients &(&1 == "/vegetables/tubers")
%{"vegetables" => %{"tubers" => %{__info__: %{"exclude-diet" => ["fruitarian"],
        "translation" => %{"en" => %{"term" => "tuber"}}}}}}
```

Using a filter to load only the files that match each part of the ref `/vegetables/tubers`. e.g. `/vegetables` and `/vegetables/tubers`.

```elixir
iex(1)> Yum.Data.ingredients Yum.Data.ref_filter("/vegetables/tubers")
%{"vegetables" => %{:__info__ => %{"exclude-diet" => ["carnivorous",
       "ketogenic"],
      "translation" => %{"en" => %{"term" => "vegetable"},
        "fr" => %{"term" => "légume"}}},
    "tubers" => %{__info__: %{"exclude-diet" => ["fruitarian"],
        "translation" => %{"en" => %{"term" => "tuber"}}}}}}
```
