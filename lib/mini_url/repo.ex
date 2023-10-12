defmodule MiniUrl.Repo do
  use Ecto.Repo,
    otp_app: :mini_url,
    adapter: Ecto.Adapters.Postgres
end
