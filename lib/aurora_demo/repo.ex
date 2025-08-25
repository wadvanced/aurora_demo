defmodule AuroraDemo.Repo do
  use Ecto.Repo,
    otp_app: :aurora_demo,
    adapter: Ecto.Adapters.Postgres
end
