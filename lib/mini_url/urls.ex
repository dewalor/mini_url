defmodule MiniUrl.Urls do
  @moduledoc """
  The Urls context.
  """

  import Ecto.Query, warn: false
  alias MiniUrl.Repo

  alias MiniUrl.Urls.Url

  @doc """
  Returns the list of urls.

  ## Examples

      iex> list_urls()
      [%Url{}, ...]

  """
  def list_urls do
    Repo.all(Url)
  end

  @spec get_url!(any()) :: any()
  @doc """
  Gets a single url.

  Raises `Ecto.NoResultsError` if the Url does not exist.

  ## Examples

      iex> get_url!(123)
      %Url{}

      iex> get_url!(456)
      ** (Ecto.NoResultsError)

  """
  def get_url!(id), do: Repo.get!(Url, id)

  @doc """
  Gets the original url string given the short url string.

  Returns nil if the Url does not exist.

  ## Examples

      iex> get_original(x1y23)
      "http://www.example.com"

      iex> get_original(4a5c6)
      nil

  """
  def get_original(short_url) when is_nil(short_url), do: "/urls"

  def get_original(short_url) do
    case url = Repo.get_by(Url, short: short_url) do
      %Url{} -> url.original
      _ -> "/urls"
    end
  end

  @doc """
  Creates a url.

  ## Examples

      iex> create_url(%{field: value})
      {:ok, %Url{}}

      iex> create_url(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_url(attrs \\ %{}) do
    attrs = Map.put(attrs, "short", generate_random_key())
    %Url{}
    |> Url.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a url.

  ## Examples

      iex> update_url(url, %{field: new_value})
      {:ok, %Url{}}

      iex> update_url(url, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_url(%Url{} = url, attrs) do
    url
    |> Url.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a url.

  ## Examples

      iex> delete_url(url)
      {:ok, %Url{}}

      iex> delete_url(url)
      {:error, %Ecto.Changeset{}}

  """
  def delete_url(%Url{} = url) do
    Repo.delete(url)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking url changes.

  ## Examples

      iex> change_url(url)
      %Ecto.Changeset{data: %Url{}}

  """
  def change_url(%Url{} = url, attrs \\ %{}) do
    Url.changeset(url, attrs)
  end

  defp generate_random_key() do
    :crypto.strong_rand_bytes(8)
    |> Base.url_encode64()
    |> String.replace(~r/[-_\=]/, "")
    |> Kernel.binary_part(0, 8)
  end
end
