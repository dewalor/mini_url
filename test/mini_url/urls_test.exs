defmodule MiniUrl.UrlsTest do
  use MiniUrl.DataCase

  alias MiniUrl.Urls

  describe "urls" do
    alias MiniUrl.Urls.Url

    import MiniUrl.UrlsFixtures

    @invalid_attrs %{original: nil, short: nil, visits: nil}

    test "list_urls/0 returns all urls" do
      url = url_fixture()
      assert Urls.list_urls() == [url]
    end

    test "get_url!/1 returns the url with given id" do
      url = url_fixture()
      assert Urls.get_url!(url.id) == url
    end

    test "create_url/1 with valid data creates a url" do
      valid_attrs = %{original: "http://example.com/", short: nil, visits: 42}

      assert {:ok, %Url{} = url} = Urls.create_url(valid_attrs)
      assert url.original == "http://example.com/"
      assert String.length(url.short) == 8
      assert url.visits == 42
    end

    test "create_url/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Urls.create_url(@invalid_attrs)
    end

    test "delete_url/1 deletes the url" do
      url = url_fixture()
      assert {:ok, %Url{}} = Urls.delete_url(url)
      assert_raise Ecto.NoResultsError, fn -> Urls.get_url!(url.id) end
    end

    test "change_url/1 returns a url changeset" do
      url = url_fixture()
      assert %Ecto.Changeset{} = Urls.change_url(url)
    end
  end
end
