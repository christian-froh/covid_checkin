defmodule CovidCheckin.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  alias CovidCheckin.Events.Attendee

  @timestamps_opts [type: :utc_datetime]

  schema "events" do
    field :max_attendees, :integer
    field :name, :string

    has_many(:attendees, Attendee, on_delete: :delete_all)

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :max_attendees])
    |> validate_required([:name, :max_attendees])
  end
end
