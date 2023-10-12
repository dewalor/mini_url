defmodule MiniUrlWeb.UrlLiveTest do
  use MiniUrlWeb.ConnCase

  import Phoenix.LiveViewTest
  import MiniUrl.UrlsFixtures

  @create_attrs %{original: "some original", short: "some short", visits: 42}
  @update_attrs %{original: "some updated original", short: "some updated short", visits: 43}
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
      assert html =~ "some original"
    end

    test "updates url in listing", %{conn: conn, url: url} do
      {:ok, index_live, _html} = live(conn, ~p"/urls")

      assert index_live |> element("#urls-#{url.id} a", "Edit") |> render_click() =~
               "Edit Url"

      assert_patch(index_live, ~p"/urls/#{url}/edit")

      assert index_live
             |> form("#url-form", url: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#url-form", url: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/urls")

      html = render(index_live)
      assert html =~ "Url updated successfully"
      assert html =~ "some updated original"
    end

    test "deletes url in listing", %{conn: conn, url: url} do
      {:ok, index_live, _html} = live(conn, ~p"/urls")

      assert index_live |> element("#urls-#{url.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#urls-#{url.id}")
    end
  end

  describe "Show" do
    setup [:create_url]

    test "displays url", %{conn: conn, url: url} do
      {:ok, _show_live, html} = live(conn, ~p"/urls/#{url}")

      assert html =~ "Show Url"
      assert html =~ url.original
    end

    test "updates url within modal", %{conn: conn, url: url} do
      {:ok, show_live, _html} = live(conn, ~p"/urls/#{url}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Url"

      assert_patch(show_live, ~p"/urls/#{url}/show/edit")

      assert show_live
             |> form("#url-form", url: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#url-form", url: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/urls/#{url}")

      html = render(show_live)
      assert html =~ "Url updated successfully"
      assert html =~ "some updated original"
    end
  end
end
