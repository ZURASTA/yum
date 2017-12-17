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

    def merge(migration_a = %{ timestamp: a }, migration_b = %{ timestamp: b }) when a > b, do: merge(migration_b, migration_a)
    def merge(migration_a, migration_b) do
        { added, moved_removals } = merge_move(migration_a.added, migration_b.moved)
        { updated, _ } = merge_move(migration_a.updated, migration_b.moved)
        { moved, moved_removals } = merge_move(migration_a.moved, migration_b.moved, moved_removals)

        { added, deleted_removals } = merge_delete(added, migration_b.deleted)
        { updated, _ } = merge_delete(updated, migration_b.deleted)

        %Yum.Migration{
            timestamp: migration_b.timestamp,
            added: added ++ migration_b.added,
            updated: updated ++ Enum.filter(migration_b.updated, &changes?(&1, added)),
            moved: moved ++ (migration_b.moved -- moved_removals),
            deleted: migration_a.deleted ++ (migration_b.deleted -- deleted_removals)
        }
    end

    defp merge_move(transactions, move_transactions, removals \\ []) do
        Enum.reduce(transactions, { [], removals }, fn transaction, { merged_transactions, removals } ->
            case move(transaction, move_transactions) do
                { transaction, nil } -> { [transaction|merged_transactions], removals }
                { transaction, move_transaction } -> { [transaction|merged_transactions], [move_transaction|removals] }
            end
        end)
    end

    defp move({ old_file, file }, move_transactions) do
        { new_file, transaction } = move(file, move_transactions)
        { { old_file, new_file }, transaction }
    end
    defp move(file, move_transactions) do
        Enum.find_value(move_transactions, { file, nil }, fn
            transaction = { ^file, new_file } -> { new_file, transaction }
            _ -> false
        end)
    end

    defp merge_delete(transactions, delete_transactions, removals \\ []) do
        Enum.reduce(transactions, { [], removals }, fn transaction, { merged_transactions, removals } ->
            if changes?(transaction, delete_transactions) do
                case transaction do
                    { _, file } -> { merged_transactions, [file|removals] }
                    file -> { merged_transactions, [file|removals] }
                end
            else
                { [transaction|merged_transactions], [removals] }
            end
        end)
    end

    defp changes?({ _, file }, transactions), do: changes?(file, transactions)
    defp changes?(file, transactions) do
        Enum.find_value(transactions, false, fn
            ^file -> true
            _ -> false
        end)
    end
end
