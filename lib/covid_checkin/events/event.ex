defmodule CovidCheckin.Events.Event do
  use Ecto.Schema
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime]

  import Ecto.Changeset

  alias CovidCheckin.Events.Attendee

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
