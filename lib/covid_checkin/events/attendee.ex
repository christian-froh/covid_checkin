defmodule CovidCheckin.Events.Attendee do
  use Ecto.Schema
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime]

  import Ecto.Changeset

  alias CovidCheckin.Events.Event

  schema "attendees" do
    field :first_name, :string
    field :last_name, :string
    field :address, :string
    field :telefon, :string
    field :healthy, :boolean
    field :currently_at_event, :boolean
    field :registered_at, :utc_datetime
    field :left_event_at, :utc_datetime

    belongs_to(:event, Event)

    timestamps()
  end

  @doc false
  def register_changeset(attendee, attrs) do
    attendee
    |> cast(attrs, [:first_name, :last_name, :address, :telefon, :healthy])
    |> validate_required([:first_name, :last_name, :address, :telefon, :healthy])
    |> set_currently_at_event_to(true)
    |> set_registered_at()
  end

  def leave_changeset(attendee) do
    attendee
    |> cast(%{}, [])
    |> set_currently_at_event_to(false)
    |> set_left_event_at()
  end

  defp set_currently_at_event_to(changeset, boolean) do
    put_change(changeset, :currently_at_event, boolean)
  end

  defp set_registered_at(changeset) do
    now = DateTime.utc_now() |> DateTime.truncate(:second)
    put_change(changeset, :registered_at, now)
  end

  defp set_left_event_at(changeset) do
    now = DateTime.utc_now() |> DateTime.truncate(:second)
    put_change(changeset, :left_event_at, now)
  end
end
