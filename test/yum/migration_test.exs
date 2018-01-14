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

        assert %Yum.Migration{
            timestamp: 1,
            add: [{ 1, "a" }, { 2, "b" }],
            update: [{ 3, "c" }, { 4, "d" }],
            move: [{ 5, { "e", "f" } }, { 6, { "g", "h" } }],
            delete: [{ 7, "i" }, { 8, "j" }]
        } == Yum.Migration.new(%{
            "timestamp" => "1",
            "add" => [{ 1, "a" }, { 2, "b" }],
            "update" => [{ 3, "c" }, { 4, "d" }],
            "move" => [{ 5, { "e", "f" } }, { 6, { "g", "h" } }],
            "delete" => [{ 7, "i" }, { 8, "j" }]
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
            add: ["a"],
            update: ["c"],
            move: [{ "e", "f" }, { "g", "h" }],
            delete: ["d", "h"]
        } == Yum.Migration.merge(Yum.Migration.new(%{
            "timestamp" => "0",
            "add" => ["a", "b"],
            "update" => ["c", "d"],
            "move" => [{ "e", "f" }, { "g", "h" }]
        }), Yum.Migration.new(%{
            "timestamp" => "1",
            "delete" => ["b", "d", "h"]
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
            add: ["a", "b2"],
            update: ["c", "d2"],
            move: [{ "e", "f" }, { "g", "h2" }, {"d", "d2"}]
        } == Yum.Migration.merge(Yum.Migration.new(%{
            "timestamp" => "0",
            "add" => ["a", "b"],
            "update" => ["c", "d"],
            "move" => [{ "e", "f" }, { "g", "h" }]
        }), Yum.Migration.new(%{
            "timestamp" => "1",
            "move" => [{ "b", "b2" }, { "d", "d2" }, { "h", "h2" }]
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

        assert %Yum.Migration{
            timestamp: 1,
            add: ["a", "b"],
            update: ["c", "d", "h"],
            move: [{ "e", "f" }, { "g", "h" }]
        } == Yum.Migration.merge(Yum.Migration.new(%{
            "timestamp" => "0",
            "add" => ["a", "b"],
            "update" => ["c", "d"],
            "move" => [{ "e", "f" }, { "g", "h" }]
        }), Yum.Migration.new(%{
            "timestamp" => "1",
            "update" => ["b", "d", "h"]
        }))
    end

    test "merge removes redundant meta transactions" do
        assert %Yum.Migration{
            timestamp: 1,
            add: [{ 2, "b" }],
            update: [{ 4, "d" }],
            move: [{ 5, { "e", "f" } }, { 6, { "g", "h" } }],
            delete: ["c", "f"]
        } == Yum.Migration.merge(Yum.Migration.new(%{
            "timestamp" => "0",
            "add" => [{ 1, "a" }, { 2, "b" }],
            "update" => [{ 3, "c" }, { 4, "d" }],
            "move" => [{ 5, { "e", "f" } }, { 6, { "g", "h" } }]
        }), Yum.Migration.new(%{
            "timestamp" => "1",
            "delete" => ["a", "c", "f"]
        }))

        assert %Yum.Migration{
            timestamp: 1,
            add: [{ 1, "a" }],
            update: [{ 3, "c" }],
            move: [{ 5, { "e", "f" } }, { 6, { "g", "h" } }],
            delete: ["d", "h"]
        } == Yum.Migration.merge(Yum.Migration.new(%{
            "timestamp" => "0",
            "add" => [{ 1, "a" }, { 2, "b" }],
            "update" => [{ 3, "c" }, { 4, "d" }],
            "move" => [{ 5, { "e", "f" } }, { 6, { "g", "h" } }]
        }), Yum.Migration.new(%{
            "timestamp" => "1",
            "delete" => ["b", "d", "h"]
        }))

        assert %Yum.Migration{
            timestamp: 1,
            add: [{ 1, "a2" }, { 2, "b" }],
            update: [{ 3, "c2" }, { 4, "d" }],
            move: [{ 5, { "e", "f2" } }, { 6, { "g", "h" } }, {"c", "c2"}]
        } == Yum.Migration.merge(Yum.Migration.new(%{
            "timestamp" => "0",
            "add" => [{ 1, "a" }, { 2, "b" }],
            "update" => [{ 3, "c" }, { 4, "d" }],
            "move" => [{ 5, { "e", "f" } }, { 6, { "g", "h" } }]
        }), Yum.Migration.new(%{
            "timestamp" => "1",
            "move" => [{ "a", "a2" }, { "c", "c2" }, { "f", "f2" }]
        }))

        assert %Yum.Migration{
            timestamp: 1,
            add: [{ 1, "a" }, { 2, "b2" }],
            update: [{ 3, "c" }, { 4, "d2" }],
            move: [{ 5, { "e", "f" } }, { 6, { "g", "h2" } }, {"d", "d2"}]
        } == Yum.Migration.merge(Yum.Migration.new(%{
            "timestamp" => "0",
            "add" => [{ 1, "a" }, { 2, "b" }],
            "update" => [{ 3, "c" }, { 4, "d" }],
            "move" => [{ 5, { "e", "f" } }, { 6, { "g", "h" } }]
        }), Yum.Migration.new(%{
            "timestamp" => "1",
            "move" => [{ "b", "b2" }, { "d", "d2" }, { "h", "h2" }]
        }))

        assert %Yum.Migration{
            timestamp: 1,
            add: [{ 1, "a" }, { 2, "b" }],
            update: [{ 3, "c" }, { 4, "d" }, "f"],
            move: [{ 5, { "e", "f" } }, { 6, { "g", "h" } }]
        } == Yum.Migration.merge(Yum.Migration.new(%{
            "timestamp" => "0",
            "add" => [{ 1, "a" }, { 2, "b" }],
            "update" => [{ 3, "c" }, { 4, "d" }],
            "move" => [{ 5, { "e", "f" } }, { 6, { "g", "h" } }]
        }), Yum.Migration.new(%{
            "timestamp" => "1",
            "update" => ["a", "c", "f"]
        }))

        assert %Yum.Migration{
            timestamp: 1,
            add: [{ 1, "a" }, { 2, "b" }],
            update: [{ 3, "c" }, { 4, "d" }, "h"],
            move: [{ 5, { "e", "f" } }, { 6, { "g", "h" } }]
        } == Yum.Migration.merge(Yum.Migration.new(%{
            "timestamp" => "0",
            "add" => [{ 1, "a" }, { 2, "b" }],
            "update" => [{ 3, "c" }, { 4, "d" }],
            "move" => [{ 5, { "e", "f" } }, { 6, { "g", "h" } }]
        }), Yum.Migration.new(%{
            "timestamp" => "1",
            "update" => ["a", "c", "h"]
        }))

        assert %Yum.Migration{
            timestamp: 1,
            add: [{ 2, "b" }],
            update: [{ 4, "d" }],
            move: [{ 5, { "e", "f" } }, { 6, { "g", "h" } }],
            delete: [{ 8, "c" }, { 9, "f" }]
        } == Yum.Migration.merge(Yum.Migration.new(%{
            "timestamp" => "0",
            "add" => [{ 1, "a" }, { 2, "b" }],
            "update" => [{ 3, "c" }, { 4, "d" }],
            "move" => [{ 5, { "e", "f" } }, { 6, { "g", "h" } }]
        }), Yum.Migration.new(%{
            "timestamp" => "1",
            "delete" => [{ 7, "a" }, { 8, "c" }, { 9, "f" }]
        }))

        assert %Yum.Migration{
            timestamp: 1,
            add: [{ 1, "a2" }, { 2, "b" }],
            update: [{ 3, "c2" }, { 4, "d" }],
            move: [{ 5, { "e", "f2" } }, { 6, { "g", "h" } }, { 8, {"c", "c2"} }]
        } == Yum.Migration.merge(Yum.Migration.new(%{
            "timestamp" => "0",
            "add" => [{ 1, "a" }, { 2, "b" }],
            "update" => [{ 3, "c" }, { 4, "d" }],
            "move" => [{ 5, { "e", "f" } }, { 6, { "g", "h" } }]
        }), Yum.Migration.new(%{
            "timestamp" => "1",
            "move" => [{ 7, { "a", "a2" } }, { 8, { "c", "c2" } }, { 9, { "f", "f2" } }]
        }))

        assert %Yum.Migration{
            timestamp: 1,
            add: [{ 1, "a" }, { 2, "b" }],
            update: [{ 3, "c" }, { 4, "d" }, { 9, "f" }],
            move: [{ 5, { "e", "f" } }, { 6, { "g", "h" } }]
        } == Yum.Migration.merge(Yum.Migration.new(%{
            "timestamp" => "0",
            "add" => [{ 1, "a" }, { 2, "b" }],
            "update" => [{ 3, "c" }, { 4, "d" }],
            "move" => [{ 5, { "e", "f" } }, { 6, { "g", "h" } }]
        }), Yum.Migration.new(%{
            "timestamp" => "1",
            "update" => [{ 7, "a" }, { 8, "c" }, { 9, "f" }]
        }))
    end

    test "transactions/1" do
        assert [
            move: { "e", "f" },
            move: { "g", "h" },
            delete: "i",
            delete: "j",
            add: "a",
            add: "b",
            update: "c",
            update: "d"
        ] == Yum.Migration.transactions(%Yum.Migration{
            timestamp: 1,
            add: ["a", "b"],
            update: ["c", "d"],
            move: [{ "e", "f" }, { "g", "h" }],
            delete: ["i", "j"]
        })

        assert [
            move: { 5, { "e", "f" } },
            move: { 6, { "g", "h" } },
            delete: { 7, "i" },
            delete: { 8, "j" },
            add: { 1, "a" },
            add: { 2, "b" },
            update: { 3, "c" },
            update: { 4, "d" }
        ] == Yum.Migration.transactions(%Yum.Migration{
            timestamp: 1,
            add: [{ 1, "a" }, { 2, "b" }],
            update: [{ 3, "c" }, { 4, "d" }],
            move: [{ 5, { "e", "f" } }, { 6, { "g", "h" } }],
            delete: [{ 7, "i" }, { 8, "j" }]
        })
    end
end
