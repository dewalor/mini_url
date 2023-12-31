defmodule MiniUrl.UrlsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MiniUrl.Urls` context.
  """

  @doc """
  Generate a url.
  """
  def url_fixture(attrs \\ %{}) do
    {:ok, url} =
      attrs
      |> Enum.into(%{
        original: "http://example.com/",
        short: nil,
        visits: 42
      })
      |> MiniUrl.Urls.create_url()
    url
  end
end
