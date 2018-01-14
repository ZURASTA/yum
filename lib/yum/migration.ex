defmodule Yum.Migration do
    @moduledoc """
      A struct that contains the migration info.

      Migration items can optionally contain metadata associated with that
      individual transaction.
    """

    defstruct [
        timestamp: -1,
        move: [],
        delete: [],
        add: [],
        update: [],
    ]

    @type meta :: any
    @type file :: String.t
    @type item(item) :: item | { meta, item }
    @type transaction(op, item) :: { op, item(item) }
    @type delete :: transaction(:delete, file)
    @type add :: transaction(:add, file)
    @type update :: transaction(:update, file)
    @type move :: transaction(:move, { file, file })

    @type t :: %Yum.Migration{ timestamp: integer, move: [item({ file, file })], delete: [item(file)], add: [item(file)], update: [item(file)] }

    @doc """
      Convert to a migration struct
    """
    @spec new(Yum.Data.migration) :: [t]
    def new(data) do
        %Yum.Migration{ timestamp: String.to_integer(data["timestamp"]) }
        |> new_moved(data)
        |> new_deleted(data)
        |> new_added(data)
        |> new_updated(data)
    end

    defp new_moved(migration, %{ "move" => moved }), do: %{ migration | move: moved }
    defp new_moved(migration, _), do: migration

    defp new_deleted(migration, %{ "delete" => deleted }), do: %{ migration | delete: deleted }
    defp new_deleted(migration, _), do: migration

    defp new_added(migration, %{ "add" => added }), do: %{ migration | add: added }
    defp new_added(migration, _), do: migration

    defp new_updated(migration, %{ "update" => updated }), do: %{ migration | update: updated }
    defp new_updated(migration, _), do: migration

    @doc """
      Get the list of transactions that the migration represents.

      These transactions are ordered in the order they should be applied.
    """
    @spec transactions(t) :: [move | delete | add | update]
    def transactions(migration) do
        Enum.map(migration.move, &({ :move, &1 }))
        ++ Enum.map(migration.delete, &({ :delete, &1 }))
        ++ Enum.map(migration.add, &({ :add, &1 }))
        ++ Enum.map(migration.update, &({ :update, &1 }))
    end

    @doc """
      Merge two migrations into one.
    """
    @spec merge(t, t) :: t
    def merge(migration_a = %{ timestamp: a }, migration_b = %{ timestamp: b }) when a > b, do: merge(migration_b, migration_a)
    def merge(migration_a, migration_b) do
        { added, moved_removals } = merge_move(migration_a.add, migration_b.move)
        { updated, _ } = merge_move(migration_a.update, migration_b.move)
        { moved, moved_removals } = merge_move(migration_a.move, migration_b.move, moved_removals)

        { added, deleted_removals } = merge_delete(added, migration_b.delete)
        { updated, _ } = merge_delete(updated, migration_b.delete)

        moved = Enum.reverse(moved)

        %Yum.Migration{
            timestamp: migration_b.timestamp,
            add: added ++ migration_b.add,
            update: updated ++ Enum.filter(migration_b.update, &(!changes?(&1, added) && !changes?(&1, updated))),
            move: moved ++ Enum.filter(migration_b.move, &(!changes?(&1, moved_removals))),
            delete: migration_a.delete ++ Enum.filter(migration_b.delete, &(!changes?(&1, deleted_removals)))
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
            { _, transaction = { ^file, new_file } } -> { new_file, transaction }
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
                { [transaction|merged_transactions], removals }
            end
        end)
    end

    defp changes?({ _, file }, transactions), do: changes?(file, transactions)
    defp changes?(file, transactions) do
        Enum.find_value(transactions, false, fn
            { _, ^file } -> true
            ^file -> true
            _ -> false
        end)
    end
end
