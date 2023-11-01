defmodule ObanExample.Repo.Local do
  use Ecto.Repo,
    otp_app: :oban_example,
    adapter: Ecto.Adapters.Postgres
end

defmodule ObanExample.Repo.Replica.Local do
  use Ecto.Repo,
    otp_app: :oban_example,
    adapter: Ecto.Adapters.Postgres,
    read_only: true
end

defmodule ObanExample.Repo.Replica do
  use Fly.CustomRepo,
    local_repo: Application.compile_env(:oban_example, [__MODULE__, :local_repo])
end

defmodule ObanExample.Repo do
  use Fly.CustomRepo, local_repo: ObanExample.Repo.Local

  def replica, do: ObanExample.Repo.Repo.Local
end
