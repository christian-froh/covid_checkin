defmodule CovidCheckin.Events.Attendee do
  use Ecto.Schema
  import Ecto.Changeset

  alias CovidCheckin.Events.Event

  @timestamps_opts [type: :utc_datetime]

  schema "attendees" do
    field :first_name, :string
    field :last_name, :string
    field :address, :string
    field :telefon, :string
    field :healthy, :boolean
    field :currently_at_event, :boolean

    belongs_to(:event, Event)

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :max_attendees])
    |> validate_required([:name, :max_attendees])
  end
end
