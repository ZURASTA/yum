defmodule Yum.Cuisine.Style do
    @moduledoc """
      A struct that contains all the data about a cuisine style.
    """
    use Bitwise

    defstruct [
        ref: nil,
        type: :other,
        translation: %{},
        foods: []
    ]

    @type kind :: :continent | :subregion | :country | :province | :culture | :other
    @type t :: %Yum.Cuisine.Style{ ref: String.t, type: kind, translation: Yum.Data.translation_tree, foods: [%Yum.Cuisine.Food{}] }

    @doc """
      Flatten an cuisine tree into an cuisine style list.

      Each item in the list can be safely operated on individually, as all of the
      data related to that item is inside of its struct (compared to the original
      tree where other data is inferred from its parent).
    """
    @spec new(Yum.Data.cuisine_tree) :: [t]
    def new(data), do: Enum.reduce(data, [], &new(&1, &2, %Yum.Cuisine.Style{}))

    defp new({ key, value = %{ __info__: info } }, styles, group) do
        style = %Yum.Cuisine.Style{
            ref: "#{group.ref}/#{key}",
            translation: info["translation"] || %{}
        }
        |> new_type(info)
        |> new_foods(info)

        [style|Enum.reduce(value, styles, &new(&1, &2, style))]
    end
    defp new(_, styles, _), do: styles

    defp new_type(style, %{ "type" => "province" }), do: %{ style | type: :province }
    defp new_type(style, %{ "type" => "country" }), do: %{ style | type: :country }
    defp new_type(style, %{ "type" => "subregion" }), do: %{ style | type: :subregion }
    defp new_type(style, %{ "type" => "continent" }), do: %{ style | type: :continent }
    defp new_type(style, %{ "type" => "culture" }), do: %{ style | type: :culture }
    defp new_type(style, %{ "type" => _ }), do: %{ style | type: :other }
    defp new_type(style, _), do: style

    defp new_foods(style, %{ "cuisine" => foods }), do: %{ style | foods: Yum.Cuisine.Food.new(foods) }
    defp new_foods(style, _), do: style

    defp create_parent_ref([_|groups]), do: create_parent_ref(groups, "")

    defp create_parent_ref([_], ""), do: nil
    defp create_parent_ref([_], ref), do: ref
    defp create_parent_ref([current|groups], ref), do: create_parent_ref(groups, "#{ref}/#{current}")

    @doc """
      Get the parent ref.

      This can be used to either refer to the parent or find the parent.
    """
    @spec group_ref(t) :: String.t | nil
    def group_ref(%Yum.Cuisine.Style{ ref: ref }) do
        String.split(ref, "/")
        |> create_parent_ref
    end

    @doc """
      Get the reference name of the cuisine style.
    """
    @spec name(t) :: String.t
    def name(%Yum.Cuisine.Style{ ref: ref }) do
        String.split(ref, "/")
        |> List.last
    end

    @doc """
      Get a hash of the cuisine style's ref.

      This can be used to refer to this cuisine style.

      __Note:__ This does not produce a hash representing the cuisine style's
      current state.
    """
    @spec ref_hash(t, atom) :: binary
    def ref_hash(%Yum.Cuisine.Style{ ref: ref }, algo \\ :sha), do: :crypto.hash(algo, ref)

    @encode_charset Enum.zip('abcdefghijklmnopqrstuvwxyz-/', 1..31)

    defp encode_ref(ref, encoding \\ <<>>)
    for { chr, index } <- @encode_charset do
        defp encode_ref(<<unquote(chr), ref :: binary>>, encoding), do: encode_ref(ref, <<encoding :: bitstring, unquote(index) :: size(5)>>)
    end
    defp encode_ref("", encoding), do: encoding

    defp decode_ref(encoding, ref \\ "")
    for { chr, index } <- @encode_charset do
        defp decode_ref(<<unquote(index) :: size(5), encoding :: bitstring>>, ref), do: decode_ref(encoding, ref <> unquote(<<chr>>))
    end
    defp decode_ref(<<>>, ref), do: ref
    defp decode_ref(<<0 :: size(5), _ :: bitstring>>, ref), do: ref

    @doc """
      Encode the cuisine style's ref.

      This can be used to refer to this cuisine style.
    """
    @spec ref_encode(t) :: bitstring
    def ref_encode(%Yum.Cuisine.Style{ ref: ref }), do: encode_ref(ref)

    @doc """
      Decode the encoded cuisine style reference.
    """
    @spec ref_decode(bitstring) :: String.t
    def ref_decode(ref), do: decode_ref(ref)
end
