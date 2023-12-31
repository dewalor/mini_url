defmodule MiniUrl.Urls.Url do
  use Ecto.Schema
  import Ecto.Changeset

  schema "urls" do
    field :original, :string
    field :short, :string
    field :visits, :integer, default: 0

    timestamps(type: :utc_datetime)
  end

  @spec changeset(
          {map(), map()}
          | %{
              :__struct__ => atom() | %{:__changeset__ => map(), optional(any()) => any()},
              optional(atom()) => any()
            },
          :invalid | %{optional(:__struct__) => none(), optional(atom() | binary()) => any()}
        ) :: Ecto.Changeset.t()
  @doc false
  def changeset(url, attrs) do
    url
    |> cast(attrs, [:original, :short, :visits])
    |> unique_constraint([:original], message: "This original url already exists in the system.  Please enter a unique value.")
    |> unique_constraint([:short])
    |> validate_required([:original, :short, :visits])
    |> validate()
  end

  defp validate(%Ecto.Changeset{errors: errors, changes: %{ original: original_url }} = changeset)
                                    when Kernel.length(errors) == 0 do

    {:ok, %URI{
      scheme: scheme,
      host: host,
      path: path
    }} = URI.new(original_url)


    with {:is_http_or_s, true} <- {:is_http_or_s, scheme in ["http", "https"]},
         {:host_present, true} <- {:host_present, not is_nil(host)},
         {:has_slash, true} <- {:has_slash,  not is_nil(path) and String.contains?(path, "/")},
         {:valid_host, true} <- {:valid_host, resolve(host)} do
      changeset
    else
      {:is_http_or_s, false}  -> add_error(changeset, :original, "must begin with http or https")
      {:host_present, false}  -> add_error(changeset, :original, "must have a host, e.g. http://example.com/")
      {:has_slash, false}  -> add_error(changeset, :original, "must have a slash in the path, e.g. http://example.com/")
      {:valid_host, false} -> add_error(changeset, :original, "must have a valid host you can visit in a browser: e.g. http:example.com/")
    end
  end

  defp validate(changeset) do
    changeset
  end

  defp resolve(host) do
    case :inet.gethostbyname(Kernel.to_charlist(host)) do
      {:ok, _} -> true
      {:error, _} -> false
    end
  end
end
