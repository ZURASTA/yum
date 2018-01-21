defmodule Yum.Util do
    @moduledoc """
      Common utilities for interacting with the data.
    """

    defp create_parent_ref([_|groups]), do: create_parent_ref(groups, "")

    defp create_parent_ref([_], ""), do: nil
    defp create_parent_ref([_], ref), do: ref
    defp create_parent_ref([current|groups], ref), do: create_parent_ref(groups, "#{ref}/#{current}")

    @doc """
      Get the parent ref.

      This can be used to either refer to the parent or find the parent.
    """
    @spec group_ref(String.t) :: String.t | nil
    def group_ref(ref) do
        String.split(ref, "/")
        |> create_parent_ref
    end

    @doc """
      Get the reference name.
    """
    @spec name(String.t) :: String.t
    def name(ref) do
        String.split(ref, "/")
        |> List.last
    end

    @doc """
      Convert a list of names into a list of refs.
    """
    @spec ref_list([String.t], [String.t]) :: [String.t]
    def ref_list(groups, list \\ [])
    def ref_list([], [_|list]), do: list
    def ref_list([group|groups], []), do: ref_list(groups, [group, group])
    def ref_list([group|groups], [prev|list]) do
        ref = prev <> "/" <> group
        ref_list(groups, [ref, ref|list])
    end

    @doc """
      Convert a ref or list of refs into a list of refs for each individual ref in the group.
    """
    @spec ref_list(String.t | [String.t], [String.t]) :: [String.t]
    def match_ref(ref, matches \\ [])
    def match_ref([], matches), do: matches
    def match_ref([ref|list], matches), do: match_ref(list, match_ref(ref, matches))
    def match_ref(ref, matches), do: String.split(ref, "/", trim: true) |> ref_list([""|matches])
end
