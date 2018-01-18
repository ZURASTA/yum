defmodule Yum.Data do
    @moduledoc """
      Import food data.

      The location of the data can either be set globally in the config:

        config :yum, path: "path/to/data"

      Or it can be explicitly passed to a function.
    """
    @type translation :: %{ optional(String.t) => translation | String.t }
    @type translation_tree :: %{ optional(String.t) => translation }
    @type diet_list :: [String.t]
    @type diet_info :: %{ optional(String.t) => translation_tree }
    @type diet_tree :: %{ optional(String.t) => diet_info }
    @type allergen_list :: [String.t]
    @type allergen_info :: %{ optional(String.t) => translation_tree }
    @type allergen_tree :: %{ optional(String.t) => allergen_info }
    @type nutrition :: %{ optional(String.t) => any }
    @type food_list :: %{ optional(String.t) => translation_tree }
    @type ingredient_info :: %{ optional(String.t) => translation_tree | diet_list | allergen_list | nutrition }
    @type cuisine_info :: %{ optional(String.t) => translation_tree | food_list }
    @type ingredient_tree :: %{ optional(String.t) => ingredient_tree, required(:__info__) => ingredient_info }
    @type cuisine_tree :: %{ optional(String.t) => cuisine_tree, required(:__info__) => cuisine_info }
    @type migration :: %{ optional(String.t) => String.t | { String.t, String.t } }
    @type file_filter :: ((String.t) -> boolean)

    defp load(path), do: TomlElixir.parse_file!(path)

    defp path(), do: Application.fetch_env!(:yum, :path)

    defp load_all(_), do: true

    defp ref_list(groups, list \\ [])
    defp ref_list([], [_|list]), do: list
    defp ref_list([group|groups], []), do: ref_list(groups, [group, group])
    defp ref_list([group|groups], [prev|list]) do
        ref = prev <> "/" <> group
        ref_list(groups, [ref, ref|list])
    end

    defp match_ref(ref, matches \\ [])
    defp match_ref([], matches), do: matches
    defp match_ref([ref|list], matches), do: match_ref(list, match_ref(ref, matches))
    defp match_ref(ref, matches), do: String.split(ref, "/", trim: true) |> ref_list([""|matches])

    @doc """

    """
    @spec ref_filter(String.t | [String.t]) :: file_filter
    def ref_filter(ref) do
        refs = match_ref(ref)
        &Enum.member?(refs, &1)
    end

    @doc """
      Load the diet names and translations.

      Uses the path set in the config under `:path`.

      See `diets/1`.
    """
    @spec diets() :: diet_tree
    def diets(), do: diets(path())

    @doc """
      Load the diet names and translations.

      Uses the path referenced by `data`.

      The files to be loaded can be filtered by providing a filter.
    """
    @spec diets(String.t | file_filter) :: diet_tree
    def diets(filter) when is_function(filter), do: diets(path(), filter)
    def diets(data), do: diets(data, &load_all/1)

    @doc """
      Load the diet names and translations.

      Uses the path referenced by `data`.

      The files to be loaded can be filtered by providing a filter.
    """
    @spec diets(String.t, file_filter) :: diet_tree
    def diets(data, filter), do: load_list(Path.join(data, "diets"), filter)

    @doc """
      Reduce the diet data.

      Uses the path set in the config under `:path`.

      See `reduce_diets/3`.
    """
    @spec reduce_diets(any, (diet_info, any -> any)) :: any
    def reduce_diets(acc, fun), do: reduce_diets(acc, fun, path())

    @doc """
      Reduce the diet data.

      Each diet is passed to `fun` and an updated accumulator is returned.

      Uses the path referenced by `data`.

      The files to be loaded can be filtered by providing a filter.
    """
    @spec reduce_diets(any, (diet_info, any -> any), String.t | file_filter) :: any
    def reduce_diets(acc, fun, filter) when is_function(filter), do: reduce_diets(acc, fun, path(), filter)
    def reduce_diets(acc, fun, data), do: reduce_diets(acc, fun, data, &load_all/1)

    @doc """
      Reduce the diet data.

      Each diet is passed to `fun` and an updated accumulator is returned.

      Uses the path referenced by `data`.

      The files to be loaded can be filtered by providing a filter.
    """
    @spec reduce_diets(any, (diet_info, any -> any), String.t, file_filter) :: any
    def reduce_diets(acc, fun, data, filter), do: reduce_list(Path.join(data, "diets"), acc, fun, filter)

    @doc """
      Load the allergen names and translations.

      Uses the path set in the config under `:path`.

      See `allergens/1`.
    """
    @spec allergens() :: allergen_tree
    def allergens(), do: allergens(path())

    @doc """
      Load the allergen names and translations.

      Uses the path referenced by `data`.

      The files to be loaded can be filtered by providing a filter.
    """
    @spec allergens(String.t | file_filter) :: allergen_tree
    def allergens(filter) when is_function(filter), do: allergens(path(), filter)
    def allergens(data), do: allergens(data, &load_all/1)

    @doc """
      Load the allergen names and translations.

      Uses the path referenced by `data`.

      The files to be loaded can be filtered by providing a filter.
    """
    @spec allergens(String.t, file_filter) :: allergen_tree
    def allergens(data, filter), do: load_list(Path.join(data, "allergens"), filter)

    @doc """
      Reduce the allergen data.

      Uses the path set in the config under `:path`.

      See `reduce_allergens/3`.
    """
    @spec reduce_allergens(any, (allergen_info, any -> any)) :: any
    def reduce_allergens(acc, fun), do: reduce_allergens(acc, fun, path())

    @doc """
      Reduce the allergen data.

      Each allergen is passed to `fun` and an updated accumulator is returned.

      Uses the path referenced by `data`.

      The files to be loaded can be filtered by providing a filter.
    """
    @spec reduce_allergens(any, (allergen_info, any -> any), String.t | file_filter) :: any
    def reduce_allergens(acc, fun, filter) when is_function(filter), do: reduce_allergens(acc, fun, path(), filter)
    def reduce_allergens(acc, fun, data), do: reduce_allergens(acc, fun, data, &load_all/1)

    @doc """
      Reduce the allergen data.

      Each allergen is passed to `fun` and an updated accumulator is returned.

      Uses the path referenced by `data`.

      The files to be loaded can be filtered by providing a filter.
    """
    @spec reduce_allergens(any, (allergen_info, any -> any), String.t, file_filter) :: any
    def reduce_allergens(acc, fun, data, filter), do: reduce_list(Path.join(data, "allergens"), acc, fun, filter)

    @doc """
      Load the ingredient data.

      Uses the path set in the config under `:path`.

      See `ingredients/2`.
    """
    @spec ingredients(String.t | file_filter) :: ingredient_tree
    def ingredients(group \\ "")
    def ingredients(filter) when is_function(filter), do: ingredients("", filter)
    def ingredients(group), do: ingredients(group, path())

    @doc """
      Load the ingredient data.

      If only a particular group of ingredients is required, the path to
      find these can be provided to `group`. This will however not include
      any parent information that should be applied to these child ingredients.

      Uses the path referenced by `data`.

      The files to be loaded can be filtered by providing a filter.
    """
    @spec ingredients(String.t, String.t | file_filter) :: ingredient_tree
    def ingredients(group, filter) when is_function(filter), do: ingredients(group, path(), filter)
    def ingredients(group, data), do: ingredients(group, data, &load_all/1)

    @doc """
      Load the ingredient data.

      If only a particular group of ingredients is required, the path to
      find these can be provided to `group`. This will however not include
      any parent information that should be applied to these child ingredients.

      Uses the path referenced by `data`.

      The files to be loaded can be filtered by providing a filter.
    """
    @spec ingredients(String.t, String.t, file_filter) :: ingredient_tree
    def ingredients(group, data, filter), do: load_tree(Path.join([data, "ingredients", group]), filter)

    @doc """
      Reduce the ingredient data.

      Uses the path set in the config under `:path`.

      See `reduce_ingredients/4`
    """
    @spec reduce_ingredients(any, (ingredient_info, [{ String.t, ingredient_info }], any -> any), String.t | file_filter) :: any
    def reduce_ingredients(acc, fun, group \\ "")
    def reduce_ingredients(acc, fun, filter) when is_function(filter), do: reduce_ingredients(acc, fun, "", filter)
    def reduce_ingredients(acc, fun, group), do: reduce_ingredients(acc, fun, group, path())

    @doc """
      Reduce the ingredient data.

      Each ingredient is passed to `fun` and an updated accumulator is returned.

      If only a particular group of ingredients is required, the path to
      find these can be provided to `group`. This will however not include
      any parent information that should be applied to these child ingredients.

      Uses the path referenced by `data`.

      The files to be loaded can be filtered by providing a filter.
    """
    @spec reduce_ingredients(any, (ingredient_info, [{ String.t, ingredient_info }], any -> any), String.t, String.t | file_filter) :: any
    def reduce_ingredients(acc, fun, group, filter) when is_function(filter), do: reduce_ingredients(acc, fun, group, path(), filter)
    def reduce_ingredients(acc, fun, group, data), do: reduce_ingredients(acc, fun, group, data, &load_all/1)

    @doc """
      Reduce the ingredient data.

      Each ingredient is passed to `fun` and an updated accumulator is returned.

      If only a particular group of ingredients is required, the path to
      find these can be provided to `group`. This will however not include
      any parent information that should be applied to these child ingredients.

      Uses the path referenced by `data`.

      The files to be loaded can be filtered by providing a filter.
    """
    @spec reduce_ingredients(any, (ingredient_info, [{ String.t, ingredient_info }], any -> any), String.t, String.t, file_filter) :: any
    def reduce_ingredients(acc, fun, group, data, filter), do: reduce_tree(Path.join([data, "ingredients", group]), acc, fun, filter)

    @doc """
      Load the cuisine data.

      Uses the path set in the config under `:path`.

      See `cuisines/2`
    """
    @spec cuisines(String.t | file_filter) :: cuisine_tree
    def cuisines(group \\ "")
    def cuisines(filter) when is_function(filter), do: cuisines("", filter)
    def cuisines(group), do: cuisines(group, path())

    @doc """
      Load the cuisine data.

      If only a particular group of cuisines is required, the path to
      find these can be provided to `group`. This will however not include
      any parent information that should be applied to these child cuisines.

      Uses the path referenced by `data`.

      The files to be loaded can be filtered by providing a filter.
    """
    @spec cuisines(String.t, String.t | file_filter) :: cuisine_tree
    def cuisines(group, filter) when is_function(filter), do: cuisines(group, path(), filter)
    def cuisines(group, data), do: cuisines(group, data, &load_all/1)

    @doc """
      Load the cuisine data.

      If only a particular group of cuisines is required, the path to
      find these can be provided to `group`. This will however not include
      any parent information that should be applied to these child cuisines.

      Uses the path referenced by `data`.

      The files to be loaded can be filtered by providing a filter.
    """
    @spec cuisines(String.t, String.t, file_filter) :: cuisine_tree
    def cuisines(group, data, filter), do: load_tree(Path.join([data, "cuisines", group]), filter)

    @doc """
      Reduce the cuisine data.

      Uses the path set in the config under `:path`.

      See `reduce_cuisines/4`
    """
    @spec reduce_cuisines(any, (cuisine_info, [{ String.t, cuisine_info }], any -> any), String.t | file_filter) :: any
    def reduce_cuisines(acc, fun, group \\ "")
    def reduce_cuisines(acc, fun, filter) when is_function(filter), do: reduce_cuisines(acc, fun, "", filter)
    def reduce_cuisines(acc, fun, group), do: reduce_cuisines(acc, fun, group, path())

    @doc """
      Reduce the cuisine data.

      Each cuisine is passed to `fun` and an updated accumulator is returned.

      If only a particular group of cuisines is required, the path to
      find these can be provided to `group`. This will however not include
      any parent information that should be applied to these child cuisines.

      Uses the path referenced by `data`.

      The files to be loaded can be filtered by providing a filter.
    """
    @spec reduce_cuisines(any, (cuisine_info, [{ String.t, cuisine_info }], any -> any), String.t, String.t | file_filter) :: any
    def reduce_cuisines(acc, fun, group, filter) when is_function(filter), do: reduce_cuisines(acc, fun, group, path(), filter)
    def reduce_cuisines(acc, fun, group, data), do: reduce_cuisines(acc, fun, group, data, &load_all/1)

    @doc """
      Reduce the cuisine data.

      Each cuisine is passed to `fun` and an updated accumulator is returned.

      If only a particular group of cuisines is required, the path to
      find these can be provided to `group`. This will however not include
      any parent information that should be applied to these child cuisines.

      Uses the path referenced by `data`.

      The files to be loaded can be filtered by providing a filter.
    """
    @spec reduce_cuisines(any, (cuisine_info, [{ String.t, cuisine_info }], any -> any), String.t, String.t, file_filter) :: any
    def reduce_cuisines(acc, fun, group, data, filter), do: reduce_tree(Path.join([data, "cuisines", group]), acc, fun, filter)

    @doc """
      Load the migration data.

      Uses the path set in the config under `:path`.

      See `migrations/3`
    """
    @spec migrations(String.t, integer) :: [migration]
    def migrations(type, timestamp \\ -1), do: migrations(type, timestamp, path())

    @doc """
      Load the migration data.

      The path to the set of migration data for a certain type should be passed
      to `type`.

      Any migration files after `timestamp` will be loaded, any earlier or
      equal to will be ignored.

      Uses the path referenced by `data`.
    """
    @spec migrations(String.t, integer, String.t) :: [migration]
    def migrations(type, timestamp, data) do
        Path.wildcard(Path.join([data, type, "__migrations__", "*.yml"]))
        |> Enum.filter(&(to_timestamp(&1) > timestamp))
        |> Enum.sort(&(to_timestamp(&1) < to_timestamp(&2)))
        |> Enum.map(&load_migration/1)
    end

    @doc """
      Reduce the migration data.

      Uses the path set in the config under `:path`.

      See `reduce_migrations/5`
    """
    @spec reduce_migrations(any, String.t, (migration, any -> any), integer) :: any
    def reduce_migrations(acc, type, fun, timestamp \\ -1), do: reduce_migrations(acc, type, fun, timestamp, path())

    @doc """
      Reduce the migration data.

      Each migration is passed to `fun` and an updated accumulator is returned.

      The path to the set of migration data for a certain type should be passed
      to `type`.

      Any migration files after `timestamp` will be loaded, any earlier or
      equal to will be ignored.

      Uses the path referenced by `data`.
    """
    @spec reduce_migrations(any, String.t, (migration, any -> any), integer, String.t) :: any
    def reduce_migrations(acc, type, fun, timestamp, data) do
        Path.wildcard(Path.join([data, type, "__migrations__", "*.yml"]))
        |> Enum.filter(&(to_timestamp(&1) > timestamp))
        |> Enum.sort(&(to_timestamp(&1) < to_timestamp(&2)))
        |> Enum.reduce(acc, &(fun.(load_migration(&1), &2)))
    end

    defp load_list(path, filter) do
        Path.wildcard(Path.join(path, "*.toml"))
        |> Enum.filter(&(trim_path_ref(&1, path) |> filter.()))
        |> Enum.reduce(%{}, fn file, acc ->
            [_|paths] = Enum.reverse(Path.split(Path.relative_to(file, path)))
            contents = Enum.reduce([Path.basename(file, ".toml")|paths], load(file), fn name, contents ->
                %{ name => contents}
            end)

            Map.merge(acc, contents)
        end)
    end

    defp load_tree(path, filter) do
        Path.wildcard(Path.join(path, "**/*.toml"))
        |> Enum.filter(&(trim_path_ref(&1, path) |> filter.()))
        |> Enum.reduce(%{}, fn file, acc ->
            [_|paths] = Enum.reverse(Path.split(Path.relative_to(file, path)))
            contents = Enum.reduce([Path.basename(file, ".toml")|paths], %{ __info__: load(file) }, fn name, contents ->
                %{ name => contents }
            end)

            Map.merge(acc, contents, &merge_nested_contents/3)
        end)
    end

    defp load_migration(path) do
        [content] = YamlElixir.read_all_from_file(path)

        Enum.reduce(content, %{ "timestamp" => filename(path) }, fn
            %{ "A" => ref }, acc -> Map.put(acc, "add", [ref|(acc["add"] || [])])
            %{ "U" => ref }, acc -> Map.put(acc, "update", [ref|(acc["update"] || [])])
            %{ "D" => ref }, acc -> Map.put(acc, "delete", [ref|(acc["delete"] || [])])
            %{ "M" => ref }, acc ->
                [ref_a, ref_b] = String.split(ref, " ")
                Map.put(acc, "move", [{ ref_a, ref_b }|(acc["move"] || [])])
        end)
        |> Enum.map(fn
            { key, list } when is_list(list) -> { key, Enum.reverse(list) }
            other -> other
        end)
        |> Map.new
    end

    defp merge_nested_contents(_key, a, b), do: Map.merge(a, b, &merge_nested_contents/3)

    defp reduce_list(path, acc, fun, filter) do
        Path.wildcard(Path.join(path, "*.toml"))
        |> Enum.filter(filter)
        |> Enum.reduce(acc, &(fun.(load(&1), &2)))
    end

    defp reduce_tree(path, acc, fun, filter) do
        Path.wildcard(Path.join(path, "**/*.toml"))
        |> Enum.filter(filter)
        |> Enum.reduce({ [], acc }, fn file, { parent, acc } ->
            [name|paths] = Enum.reverse(Path.split(Path.relative_to(file, path)))

            parent = remove_stale_nodes(parent, paths)
            data = load(file)
            acc = fun.(data, parent, acc)

            { [{ Path.basename(name, ".toml"), data }|parent], acc }
        end)
        |> elem(1)
    end

    defp remove_stale_nodes([dep = { name, _ }], [name]), do: [dep]
    defp remove_stale_nodes([dep = { name, _ }|deps], [name|new_deps]), do: [dep|remove_stale_nodes(deps, new_deps)]
    defp remove_stale_nodes([_|deps], new_deps), do: remove_stale_nodes(deps, new_deps)
    defp remove_stale_nodes([], _), do: []

    defp filename(file), do: Path.basename(file) |> Path.rootname

    defp to_timestamp(file), do: filename(file) |> String.to_integer

    defp trim_path_ref(ref, path), do: String.replace_prefix(ref, path, "") |> String.replace_suffix(".toml", "")
end
