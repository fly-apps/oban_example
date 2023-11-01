defmodule ObanExample.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :inserted_from, :string

      timestamps(type: :utc_datetime)
    end
  end
end
