defmodule MiniUrlWeb.UrlController do
  use MiniUrlWeb, :controller
  alias MiniUrl.Repo
  alias MiniUrl.Urls
  alias MiniUrl.Urls.Url

  def translate(conn, %{"short" => short_url}) when is_nil(short_url), do: redirect(conn, to: "/urls")
  @spec translate(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def translate(conn, %{"short" => short_url}) do
    next_url = if url = Repo.get_by(Url, short: short_url) do
      Urls.update_url(url, %{visits: url.visits + 1})
      url.original
    else
      "/urls"
    end
    redirect(conn, external: next_url)
  end
end
