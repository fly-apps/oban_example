defmodule ObanExample.EventFeed.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :inserted_from, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:inserted_from])
    |> validate_required([:inserted_from])
  end
end
