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


Structs
-------

Structs are available for each data type to provide a standard interface to the data.

```elixir
iex(1)> Yum.Data.ingredients |> Yum.Ingredient.new                    
[%Yum.Ingredient{exclude_allergen: [],
  exclude_diet: ["carnivorous", "ketogenic"], nutrition: %{},
  ref: "/vegetables",
  translation: %{"en" => %{"term" => "vegetable"},
    "fr" => %{"term" => "légume"}}},
 %Yum.Ingredient{exclude_allergen: [],
  exclude_diet: ["fruitarian", "carnivorous", "ketogenic"], nutrition: %{},
  ref: "/vegetables/tubers", translation: %{"en" => %{"term" => "tuber"}}},
 %Yum.Ingredient{exclude_allergen: [],
  exclude_diet: ["fruitarian", "carnivorous", "ketogenic"], nutrition: %{},
  ref: "/vegetables/tubers/potato",
  translation: %{"en" => %{"term" => "potato"},
    "fr" => %{"term" => "pomme de terre"}}},
 %Yum.Ingredient{exclude_allergen: [],
  exclude_diet: ["carnivorous", "ketogenic"], nutrition: %{},
  ref: "/vegetables/tomato",
  translation: %{"en" => %{"term" => "tomato"}, "fr" => %{"term" => "tomate"}}},
 %Yum.Ingredient{exclude_allergen: [],
  exclude_diet: ["carnivorous", "ketogenic"], nutrition: %{},
  ref: "/vegetables/spring-onion",
  translation: %{"en" => %{"AU" => %{"term" => "shallot"},
      "CA" => %{"term" => "green onion"},
      "GB" => %{"WLS" => %{"term" => "gibbon"}},
      "US" => %{"term" => "scallion"}, "term" => "spring onion"},
    "fr" => %{"term" => "ciboule"}}},
 %Yum.Ingredient{exclude_allergen: [], exclude_diet: [], nutrition: %{},
  ref: "/sauces", translation: %{"en" => %{"term" => "sauce"}}},
 %Yum.Ingredient{exclude_allergen: [], exclude_diet: [], nutrition: %{},
  ref: "/sauces/tomato-sauce",
  translation: %{"en" => %{"term" => "tomato sauce"}}},
 %Yum.Ingredient{exclude_allergen: [],
  exclude_diet: ["vegan", "vegetarian", "pescetarian", "raw-vegan",
   "fruitarian"], nutrition: %{}, ref: "/meats",
  translation: %{"en" => %{"term" => "meat"}, "fr" => %{"term" => "viande"}}},
 %Yum.Ingredient{exclude_allergen: [],
  exclude_diet: ["vegan", "vegetarian", "pescetarian", "raw-vegan",
   "fruitarian"], nutrition: %{}, ref: "/meats/poultry",
  translation: %{"en" => %{"term" => "poultry"},
    "fr" => %{"term" => "volaille"}}},
 %Yum.Ingredient{exclude_allergen: [],
  exclude_diet: ["kosher", "halal", "vegan", "vegetarian", "pescetarian",
   "raw-vegan", "fruitarian"], nutrition: %{}, ref: "/meats/pork",
  translation: %{"en" => %{"term" => "pork"},
    "fr" => %{"term" => "viande de porc"}}},
 %Yum.Ingredient{exclude_allergen: [],
  exclude_diet: ["carnivorous", "ketogenic"], nutrition: %{}, ref: "/herbs",
  translation: %{"en" => %{"term" => "herb"}}},
 %Yum.Ingredient{exclude_allergen: [],
  exclude_diet: ["carnivorous", "ketogenic"], nutrition: %{},
  ref: "/herbs/basil", translation: %{"en" => %{"term" => "basil"}}},
 %Yum.Ingredient{exclude_allergen: [],
  exclude_diet: ["carnivorous", "vegetarian", "vegan", "raw-vegan",
   "paleolithic", "fruitarian"], nutrition: %{}, ref: "/dairy",
  translation: %{"en" => %{"term" => "dairy"},
    "fr" => %{"term" => "produits laitiers"}}},
 %Yum.Ingredient{exclude_allergen: [],
  exclude_diet: ["carnivorous", "vegetarian", "vegan", "raw-vegan",
   "paleolithic", "fruitarian"], nutrition: %{}, ref: "/dairy/cheeses",
  translation: %{"en" => %{"term" => "cheese"},
    "fr" => %{"term" => "fromage"}}},
 %Yum.Ingredient{exclude_allergen: [],
  exclude_diet: ["carnivorous", "vegetarian", "vegan", "raw-vegan",
   "paleolithic", "fruitarian"], nutrition: %{},
  ref: "/dairy/cheeses/mozzarella",
  translation: %{"en" => %{"term" => "mozzarella"}}}]
```


Working with refs
-----------------

Refs are the unique path name for the data source. The library provides convenient functions for working with refs to produce filters (`Yum.Data.ref_filter/1`), ref lists (`Yum.Util.match_ref/1` and `Yum.Util.ref_list/1`), get the name (`Yum.Util.name/1`), get the parent group (`Yum.Util.group_ref/1`).

```elixir
iex(1)> Yum.Data.ref_filter("/vegetables/tubers").("/vegetables")
true
iex(2)> Yum.Data.ref_filter("/vegetables/tubers").("/tubers")    
false
iex(3)> Yum.Data.ref_filter("/vegetables/tubers").("/vegetables/tubers")
true
iex(4)> Yum.Util.match_ref "/vegetables/tubers"
["/vegetables/tubers", "/vegetables"]
iex(5)> Yum.Util.ref_list ["vegetables", "tubers"]  
["vegetables/tubers", "vegetables"]
iex(6)> Yum.Util.name "/vegetables/tubers"
"tubers"
iex(7)> Yum.Util.group_ref "/vegetables/tubers"
"/vegetables"
```


Migrations
----------

The library provides some functions for more efficiently working with migrations.

#### Transactions

Handling migrations can be done easily using transactions (`Yum.Migration.transactions/1`) which are a list of operations ordered in the order they should be handled to correctly migrate the data.

```elixir
iex(1)> Yum.Migration.transactions %Yum.Migration{
...(1)>     timestamp: 1,
...(1)>     add: ["a", "b"],
...(1)>     update: ["c", "d"],
...(1)>     move: [{ "e", "f" }, { "g", "h" }],
...(1)>     delete: ["i", "j"]
...(1)> }
[move: {"e", "f"}, move: {"g", "h"}, delete: "i", delete: "j", add: "a",
 add: "b", update: "c", update: "d"]

```

#### Merging

Migrations can be merged into one single migration, removing any redundant operations so migrating the data can be done more efficiently.

```elixir
iex(1)> Yum.Migration.merge(%Yum.Migration{
...(1)>     timestamp: 1,
...(1)>     add: ["a", { :b, "b" }, "c"]
...(1)> }, %Yum.Migration{
...(1)>     timestamp: 2, 
...(1)>     update: ["a", "b", { :c, "c" }, "d"]
...(1)> })
%Yum.Migration{add: ["a", {:b, "b"}, "c"], delete: [], move: [], timestamp: 2,
 update: ["d"]}
```

#### Metadata

Transaction operations can optionally have metadata attached to them. These are useful for attaching some contextual information with the given operation. Note that metadata will not be merged, rather whatever operation ends up in the output will still retain its metadata (but there will be no trace of the metadata from the operation that was deemed redundant and removed).

Metadata is of the form `{ metadata, op }` where `op` is the operation value that has the metadata attached.

```elixir
iex(1)> Yum.Migration.new(%{
...(1)>     "timestamp" => "1",
...(1)>     "add" => [{ :my_custom_data, "a" }, "b"],
...(1)> })
%Yum.Migration{add: [my_custom_data: "a", "b"], delete: [], move: [], timestamp: 1,
 update: []}
```
