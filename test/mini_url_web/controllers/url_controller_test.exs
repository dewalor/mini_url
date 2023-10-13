defmodule MiniUrlWeb.UrlControllerTest do
  use MiniUrlWeb.ConnCase
  import MiniUrl.UrlsFixtures

  alias MiniUrl.Repo
  alias MiniUrl.Urls.Url

  defp create_url(_) do
    url = url_fixture()
    %{url: url}
  end

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "original"
  end
  describe "translate" do
    setup [:create_url]

    test "visiting short url redirects to original url", %{conn: conn, url: url} do
      conn = get(conn, ~p"/#{url.short}")
      assert redirected_to(conn,302) == url.original
    end

    test "visiting short url increments the url's visits", %{conn: conn, url: url} do
      initial_visits = url.visits
      conn = get(conn, ~p"/#{url.short}")
      updated_url = Repo.get!(Url, url.id)
      assert updated_url.visits == initial_visits + 1
    end

    test "visiting non-existent short url redirects to Index", %{conn: conn, url: url} do
      conn = get(conn, ~p"/0piJkuSs")
      assert {:error, {:redirect, %{flash: %{}, to: "/urls"}}}
    end
  end
end
