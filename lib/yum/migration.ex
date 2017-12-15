defmodule Yum.Migration do
    defstruct [
        timestamp: -1,
        moved: [],
        deleted: [],
        added: [],
        updated: [],
    ]

    def new(data) do
        %Yum.Migration{ timestamp: String.to_integer(data["timestamp"]) }
        |> new_moved(data)
        |> new_deleted(data)
        |> new_added(data)
        |> new_updated(data)
    end

    defp new_moved(migration, %{ "moved" => moved }), do: %{ migration | moved: moved }
    defp new_moved(migration, _), do: migration

    defp new_deleted(migration, %{ "deleted" => deleted }), do: %{ migration | deleted: deleted }
    defp new_deleted(migration, _), do: migration

    defp new_added(migration, %{ "added" => added }), do: %{ migration | added: added }
    defp new_added(migration, _), do: migration

    defp new_updated(migration, %{ "updated" => updated }), do: %{ migration | updated: updated }
    defp new_updated(migration, _), do: migration
end
