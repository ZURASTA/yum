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
end
