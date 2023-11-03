defmodule ObanExample.Repo.Local do
  use Ecto.Repo,
    otp_app: :oban_example,
    adapter: Ecto.Adapters.Postgres
end

defmodule ObanExample.Repo do
  use Fly.CustomRepo, local_repo: ObanExample.Repo.Local
end
