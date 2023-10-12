defmodule MiniUrl.Urls.Url do
  use Ecto.Schema
  import Ecto.Changeset

  schema "urls" do
    field :original, :string
    field :short, :string
    field :visits, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(url, attrs) do
    url
    |> cast(attrs, [:original, :short, :visits])
    |> validate_required([:original, :short, :visits])
  end
end
