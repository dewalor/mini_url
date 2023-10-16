defmodule MiniUrlWeb.UrlLiveTest do
  use MiniUrlWeb.ConnCase

  import Phoenix.LiveViewTest
  import MiniUrl.UrlsFixtures

  @create_attrs %{original: "http://example1.com/", short: nil, visits: 0}
  @invalid_attrs %{original: nil, short: nil, visits: nil}

  defp create_url(_) do
    url = url_fixture()
    %{url: url}
  end

  describe "Index" do
    setup [:create_url]

    test "lists all urls", %{conn: conn, url: url} do
      {:ok, _index_live, html} = live(conn, ~p"/urls")

      assert html =~ "Listing Urls"
      assert html =~ url.original
    end

    test "saves new url", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/urls")

      assert index_live |> element("a", "New Url") |> render_click() =~
               "New Url"

      assert_patch(index_live, ~p"/urls/new")

      assert index_live
             |> form("#url-form", url: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#url-form", url: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/urls")

      html = render(index_live)
      assert html =~ "Url created successfully"
      assert html =~ "example1"
    end
  end

  describe "Show" do
    setup [:create_url]
    test "displays url", %{conn: conn, url: url} do
      {:ok, _show_live, html} = live(conn, ~p"/urls/#{url}")

      assert html =~ "Show Url"
      assert html =~ url.original
    end
  end
end
