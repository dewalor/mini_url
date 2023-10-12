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
      valid_attrs = %{original: "some original", short: "some short", visits: 42}

      assert {:ok, %Url{} = url} = Urls.create_url(valid_attrs)
      assert url.original == "some original"
      assert url.short == "some short"
      assert url.visits == 42
    end

    test "create_url/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Urls.create_url(@invalid_attrs)
    end

    test "update_url/2 with valid data updates the url" do
      url = url_fixture()
      update_attrs = %{original: "some updated original", short: "some updated short", visits: 43}

      assert {:ok, %Url{} = url} = Urls.update_url(url, update_attrs)
      assert url.original == "some updated original"
      assert url.short == "some updated short"
      assert url.visits == 43
    end

    test "update_url/2 with invalid data returns error changeset" do
      url = url_fixture()
      assert {:error, %Ecto.Changeset{}} = Urls.update_url(url, @invalid_attrs)
      assert url == Urls.get_url!(url.id)
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
