defmodule BowApi.Repo do
  use Ecto.Repo,
    otp_app: :bow_api,
    adapter: Ecto.Adapters.SQLite3
end
