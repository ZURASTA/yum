defmodule Yum.UtilTest do
    use ExUnit.Case

    test "ref_list/2" do
        assert_raise FunctionClauseError, fn -> Yum.Util.ref_list([]) end

        assert ["foo"] == Yum.Util.ref_list(["foo"])
        assert ["foo/bar", "foo"] == Yum.Util.ref_list(["foo", "bar"])
        assert ["foo/bar/baz", "foo/bar", "foo"] == Yum.Util.ref_list(["foo", "bar", "baz"])
        assert ["foo-a/bar-b/baz-c", "foo-a/bar-b", "foo-a"] == Yum.Util.ref_list(["foo-a", "bar-b", "baz-c"])
    end

    test "match_ref/2" do
        assert [] == Yum.Util.match_ref([])
        assert ["a", "b"] == Yum.Util.match_ref([], ["a", "b"])

        assert ["/foo"] == Yum.Util.match_ref(["foo"])
        assert ["/foo/bar", "/foo"] == Yum.Util.match_ref(["foo/bar"])
        assert ["/foo/bar/baz", "/foo/bar", "/foo"] == Yum.Util.match_ref(["foo/bar/baz"])
        assert ["/foo-a/bar-b/baz-c", "/foo-a/bar-b", "/foo-a"] == Yum.Util.match_ref(["foo-a/bar-b/baz-c"])

        assert ["/foo"] == Yum.Util.match_ref(["/foo"])
        assert ["/foo/bar", "/foo"] == Yum.Util.match_ref(["/foo/bar"])
        assert ["/foo/bar/baz", "/foo/bar", "/foo"] == Yum.Util.match_ref(["/foo/bar/baz"])
        assert ["/foo-a/bar-b/baz-c", "/foo-a/bar-b", "/foo-a"] == Yum.Util.match_ref(["/foo-a/bar-b/baz-c"])

        assert ["/x/y/z", "/x/y", "/x", "/one/two", "/one", "/foo"] == Yum.Util.match_ref(["foo", "one/two", "x/y/z"])
        assert ["/x/y/z", "/x/y", "/x", "/one/two", "/one", "/foo/bar", "/foo"] == Yum.Util.match_ref(["foo/bar", "one/two", "x/y/z"])
        assert ["/x/y/z", "/x/y", "/x", "/one/two", "/one", "/foo/bar/baz", "/foo/bar", "/foo"] == Yum.Util.match_ref(["foo/bar/baz", "one/two", "x/y/z"])
        assert ["/x/y/z", "/x/y", "/x", "/one/two", "/one", "/foo-a/bar-b/baz-c", "/foo-a/bar-b", "/foo-a"] == Yum.Util.match_ref(["foo-a/bar-b/baz-c", "one/two", "x/y/z"])

        assert ["/foo", "a", "b"] == Yum.Util.match_ref(["foo"], ["a", "b"])
        assert ["/foo/bar", "/foo", "a", "b"] == Yum.Util.match_ref(["foo/bar"], ["a", "b"])
        assert ["/foo/bar/baz", "/foo/bar", "/foo", "a", "b"] == Yum.Util.match_ref(["foo/bar/baz"], ["a", "b"])
        assert ["/foo-a/bar-b/baz-c", "/foo-a/bar-b", "/foo-a", "a", "b"] == Yum.Util.match_ref(["foo-a/bar-b/baz-c"], ["a", "b"])
    end

    test "name/1" do
        assert "foo" == Yum.Util.name("/foo")
        assert "bar" == Yum.Util.name("/foo/bar")
        assert "baz" == Yum.Util.name("/foo/bar/baz")
        assert "baz-c" == Yum.Util.name("/foo-a/bar-b/baz-c")
    end

    test "group_ref/1" do
        assert nil == Yum.Util.group_ref("/foo")
        assert "/foo" == Yum.Util.group_ref("/foo/bar")
        assert "/foo/bar" == Yum.Util.group_ref("/foo/bar/baz")
        assert "/foo-a/bar-b" == Yum.Util.group_ref("/foo-a/bar-b/baz-c")
    end
end
