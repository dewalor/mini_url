defmodule MiniUrl.Repo.Migrations.CreateUrls do
  use Ecto.Migration

  def change do
    create table(:urls) do
      add :original, :string
      add :short, :string
      add :visits, :integer

      timestamps(type: :utc_datetime)
    end

    create index(:urls, [:original], unique: true)
    create index(:urls, [:short], unique: true)
  end
end
