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
         {:has_slash, true} <- {:has_slash,  not is_nil(path) and String.contains?(path, "/")} do

      changeset
    else
      {:is_http_or_s, false}  -> add_error(changeset, :original, "must begin with http or https")
      {:host_present, false}  -> add_error(changeset, :original, "must have a host, e.g. example.com")
      {:has_slash, false}  -> add_error(changeset, :original, "must have a slash in the path, e.g. example.com/")
    end
  end

  defp validate(changeset) do
    changeset
  end
end
