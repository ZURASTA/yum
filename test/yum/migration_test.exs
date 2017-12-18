defmodule Yum.MigrationTest do
    use ExUnit.Case

    test "new/1" do
        assert %Yum.Migration{ timestamp: 1 } == Yum.Migration.new(%{ "timestamp" => "1" })
        assert %Yum.Migration{
            timestamp: 1,
            add: ["a", "b"],
            update: ["c", "d"],
            move: [{ "e", "f" }, { "g", "h" }],
            delete: ["i", "j"]
        } == Yum.Migration.new(%{
            "timestamp" => "1",
            "add" => ["a", "b"],
            "update" => ["c", "d"],
            "move" => [{ "e", "f" }, { "g", "h" }],
            "delete" => ["i", "j"]
        })
    end

    test "merge uses latest timestamp" do
        assert %Yum.Migration{ timestamp: 1 } == Yum.Migration.merge(Yum.Migration.new(%{ "timestamp" => "1" }), Yum.Migration.new(%{ "timestamp" => "0" }))
        assert %Yum.Migration{ timestamp: 1 } == Yum.Migration.merge(Yum.Migration.new(%{ "timestamp" => "0" }), Yum.Migration.new(%{ "timestamp" => "1" }))
    end

    test "merge keeps transactions ordered correctly" do
        assert %Yum.Migration{
            timestamp: 1,
            add: ["a", "b"],
            update: ["c", "d"],
            move: [{ "e", "f" }, { "g", "h" }],
            delete: ["i", "j"]
        } == Yum.Migration.merge(Yum.Migration.new(%{
            "timestamp" => "0",
            "add" => ["a"],
            "update" => ["c"],
            "move" => [{ "e", "f" }],
            "delete" => ["i"]
        }), Yum.Migration.new(%{
            "timestamp" => "1",
            "add" => ["b"],
            "update" => ["d"],
            "move" => [{ "g", "h" }],
            "delete" => ["j"]
        }))

        assert %Yum.Migration{
            timestamp: 1,
            add: ["a", "b"],
            update: ["c", "d"],
            move: [{ "e", "f" }, { "g", "h" }],
            delete: ["i", "j"]
        } == Yum.Migration.merge(Yum.Migration.new(%{
            "timestamp" => "0",
            "add" => ["a", "b"],
            "update" => ["c", "d"],
            "move" => [{ "e", "f" }, { "g", "h" }],
            "delete" => ["i", "j"]
        }), Yum.Migration.new(%{
            "timestamp" => "1"
        }))

        assert %Yum.Migration{
            timestamp: 1,
            add: ["a", "b"],
            update: ["c", "d"],
            move: [{ "e", "f" }, { "g", "h" }],
            delete: ["i", "j"]
        } == Yum.Migration.merge(Yum.Migration.new(%{
            "timestamp" => "0"
        }), Yum.Migration.new(%{
            "timestamp" => "1",
            "add" => ["a", "b"],
            "update" => ["c", "d"],
            "move" => [{ "e", "f" }, { "g", "h" }],
            "delete" => ["i", "j"]
        }))
    end

    test "merge removes redundant transactions" do
        assert %Yum.Migration{
            timestamp: 1,
            add: ["b"],
            update: ["d"],
            move: [{ "e", "f" }, { "g", "h" }],
            delete: ["c", "f"]
        } == Yum.Migration.merge(Yum.Migration.new(%{
            "timestamp" => "0",
            "add" => ["a", "b"],
            "update" => ["c", "d"],
            "move" => [{ "e", "f" }, { "g", "h" }]
        }), Yum.Migration.new(%{
            "timestamp" => "1",
            "delete" => ["a", "c", "f"]
        }))

        assert %Yum.Migration{
            timestamp: 1,
            add: ["a2", "b"],
            update: ["c2", "d"],
            move: [{ "e", "f2" }, { "g", "h" }, {"c", "c2"}]
        } == Yum.Migration.merge(Yum.Migration.new(%{
            "timestamp" => "0",
            "add" => ["a", "b"],
            "update" => ["c", "d"],
            "move" => [{ "e", "f" }, { "g", "h" }]
        }), Yum.Migration.new(%{
            "timestamp" => "1",
            "move" => [{ "a", "a2" }, { "c", "c2" }, { "f", "f2" }]
        }))

        assert %Yum.Migration{
            timestamp: 1,
            add: ["a", "b"],
            update: ["c", "d", "f"],
            move: [{ "e", "f" }, { "g", "h" }]
        } == Yum.Migration.merge(Yum.Migration.new(%{
            "timestamp" => "0",
            "add" => ["a", "b"],
            "update" => ["c", "d"],
            "move" => [{ "e", "f" }, { "g", "h" }]
        }), Yum.Migration.new(%{
            "timestamp" => "1",
            "update" => ["a", "c", "f"]
        }))
    end
end
